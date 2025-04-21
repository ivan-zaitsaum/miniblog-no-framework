package com.example.miniblognoframework.dao;

import com.example.miniblognoframework.model.Post;
import com.example.miniblognoframework.utils.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PostDAO {

    // Размер страницы (сколько постов выводить на одной странице)
    public static final int PAGE_SIZE = 10;

    /**
     * Считает общее число опубликованных постов, опционально фильтруя по строке поиска.
     */
    public int countPosts(String search) {
        String sql = "SELECT COUNT(*) FROM posts p " +
                "LEFT JOIN users u ON p.user_id=u.id " +
                "WHERE p.status='PUBLISHED' " +
                (search != null && !search.isEmpty()
                        ? "AND (p.title LIKE ? OR p.content LIKE ?) "
                        : "");
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (search != null && !search.isEmpty()) {
                String pattern = "%" + search.trim() + "%";
                stmt.setString(1, pattern);
                stmt.setString(2, pattern);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Ошибка подсчёта постов", e);
        }
        return 0;
    }

    public int getLastInsertId() {
        String sql = "SELECT LAST_INSERT_ID()";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Ошибка получения последнего ID", e);
        }
        return 0;
    }

    /**
     * Возвращает список опубликованных постов для указанной страницы
     * с учётом опционального поиска по заголовку или контенту.
     *
     * @param search строка для поиска (или null/пусто, чтобы без фильтра)
     * @param page   номер страницы (1‑based)
     */
    public List<Post> getPostsPage(String search, int page) {
        List<Post> posts = new ArrayList<>();

        // 1) Собираем SQL в StringBuilder
        StringBuilder sb = new StringBuilder();
        sb.append("SELECT p.id, p.title, p.content, p.created_at, p.user_id, u.username ")
                .append("FROM posts p ")
                .append("LEFT JOIN users u ON p.user_id = u.id ")
                .append("WHERE p.status='PUBLISHED' ");

        if (search != null && !search.trim().isEmpty()) {
            sb.append("AND (p.title LIKE ? OR p.content LIKE ?) ");
        }

        sb.append("ORDER BY p.created_at DESC ");
        sb.append("LIMIT ?, ?");  // Обязательно пробел перед LIMIT

        String sql = sb.toString();
        System.out.println("DEBUG getPostsPage SQL -> " + sql);

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            int idx = 1;
            if (search != null && !search.trim().isEmpty()) {
                String pattern = "%" + search.trim() + "%";
                stmt.setString(idx++, pattern);
                stmt.setString(idx++, pattern);
            }

            int offset = (page - 1) * PAGE_SIZE;
            stmt.setInt(idx++, offset);
            stmt.setInt(idx, PAGE_SIZE);

            System.out.println("DEBUG getPostsPage params -> offset=" + offset + ", limit=" + PAGE_SIZE);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Post post = new Post();
                    post.setId(rs.getInt("id"));
                    post.setTitle(rs.getString("title"));
                    post.setContent(rs.getString("content"));
                    post.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    post.setUserId(rs.getInt("user_id"));
                    post.setUsername(rs.getString("username"));
                    posts.add(post);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Ошибка выборки страницы постов", e);
        }

        return posts;
    }


    /**
     * (Старый метод) Возвращает все посты без разбивки на страницы.
     */
    public List<Post> getAllPosts() {
        List<Post> posts = new ArrayList<>();
        String sql = "SELECT p.id, p.title, p.content, p.created_at, p.user_id, u.username " +
                "FROM posts p LEFT JOIN users u ON p.user_id = u.id " +
                "ORDER BY p.created_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Post post = new Post();
                post.setId(rs.getInt("id"));
                post.setTitle(rs.getString("title"));
                post.setContent(rs.getString("content"));
                post.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                post.setUserId(rs.getInt("user_id"));
                post.setUsername(rs.getString("username"));
                posts.add(post);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Ошибка выборки всех постов", e);
        }
        return posts;
    }

    public void addPost(Post post) {
        String sql = "INSERT INTO posts (title, content, user_id) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, post.getTitle());
            stmt.setString(2, post.getContent());
            stmt.setInt(3, post.getUserId());
            stmt.executeUpdate();
            try (ResultSet keys = stmt.getGeneratedKeys()) {
                if (keys.next()) {
                    post.setId(keys.getInt(1));        // Заполнить поле ID в объекте
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }


    public Post getPostById(int id) {
        Post post = null;
        String sql = "SELECT p.id, p.title, p.content, p.created_at, p.user_id, u.username " +
                "FROM posts p LEFT JOIN users u ON p.user_id=u.id " +
                "WHERE p.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    post = new Post();
                    post.setId(id);
                    post.setTitle(rs.getString("title"));
                    post.setContent(rs.getString("content"));
                    post.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    post.setUserId(rs.getInt("user_id"));
                    post.setUsername(rs.getString("username"));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Ошибка получения поста по ID", e);
        }
        return post;
    }

    public void updatePost(Post post) {
        String sql = "UPDATE posts SET title = ?, content = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, post.getTitle());
            stmt.setString(2, post.getContent());
            stmt.setInt(3, post.getId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Ошибка обновления поста", e);
        }
    }

    public void deletePost(int id) {
        String sql = "DELETE FROM posts WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Ошибка удаления поста", e);
        }
    }

    public List<Post> getPostsByUserId(int userId) {
        List<Post> posts = new ArrayList<>();
        String sql = "SELECT p.id, p.title, p.content, p.created_at, u.username "
                + "FROM posts p LEFT JOIN users u ON p.user_id=u.id "
                + "WHERE p.user_id=? ORDER BY p.created_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Post p = new Post();
                    p.setId(rs.getInt("id"));
                    p.setTitle(rs.getString("title"));
                    p.setContent(rs.getString("content"));
                    p.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    p.setUsername(rs.getString("username"));
                    posts.add(p);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return posts;
    }

    public List<Post> getPostsByCategory(int categoryId, int page) {
        List<Post> posts = new ArrayList<>();
        String sql =
                "SELECT p.id, p.title, p.content, p.created_at, p.user_id, u.username " +
                        "FROM posts p " +
                        "JOIN post_category pc ON p.id = pc.post_id " +
                        "LEFT JOIN users u ON p.user_id = u.id " +
                        "WHERE p.status='PUBLISHED' AND pc.category_id = ? " +
                        "ORDER BY p.created_at DESC " +
                        "LIMIT ?, ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            int offset = (page - 1) * PAGE_SIZE;
            stmt.setInt(1, categoryId);
            stmt.setInt(2, offset);
            stmt.setInt(3, PAGE_SIZE);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Post p = new Post();
                    p.setId(rs.getInt("id"));
                    p.setTitle(rs.getString("title"));
                    p.setContent(rs.getString("content"));
                    p.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    p.setUserId(rs.getInt("user_id"));
                    p.setUsername(rs.getString("username"));
                    posts.add(p);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Ошибка выборки постов по категории", e);
        }
        return posts;
    }

    public int countPostsByCategory(int categoryId) {
        String sql =
                "SELECT COUNT(*) FROM posts p " +
                        "JOIN post_category pc ON p.id = pc.post_id " +
                        "WHERE p.status='PUBLISHED' AND pc.category_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, categoryId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Ошибка подсчёта постов по категории", e);
        }
    }

    public List<Post> getPostsByTag(int tagId, int page) {
        List<Post> posts = new ArrayList<>();
        String sql =
                "SELECT p.id, p.title, p.content, p.created_at, p.user_id, u.username " +
                        "FROM posts p " +
                        "JOIN post_tag pt ON p.id = pt.post_id " +
                        "LEFT JOIN users u ON p.user_id = u.id " +
                        "WHERE p.status='PUBLISHED' AND pt.tag_id = ? " +
                        "ORDER BY p.created_at DESC " +
                        "LIMIT ?, ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            int offset = (page - 1) * PAGE_SIZE;
            stmt.setInt(1, tagId);
            stmt.setInt(2, offset);
            stmt.setInt(3, PAGE_SIZE);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Post p = new Post();
                    p.setId(rs.getInt("id"));
                    p.setTitle(rs.getString("title"));
                    p.setContent(rs.getString("content"));
                    p.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    p.setUserId(rs.getInt("user_id"));
                    p.setUsername(rs.getString("username"));
                    posts.add(p);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Ошибка выборки постов по тегу", e);
        }
        return posts;
    }

    public int countPostsByTag(int tagId) {
        String sql =
                "SELECT COUNT(*) FROM posts p " +
                        "JOIN post_tag pt ON p.id = pt.post_id " +
                        "WHERE p.status='PUBLISHED' AND pt.tag_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, tagId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Ошибка подсчёта постов по тегу", e);
        }
    }




}
