package com.example.miniblognoframework.dao;

import com.example.miniblognoframework.model.Post;
import com.example.miniblognoframework.utils.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PostDAO {

    public static final int PAGE_SIZE = 10;

    /** Считает общее число постов (с учётом optional search) */
    public int countPosts(String search) {
        String sql = "SELECT COUNT(*) FROM posts p " +
                "LEFT JOIN users u ON p.user_id=u.id " +
                (search != null && !search.isEmpty()
                        ? "WHERE p.title LIKE ? OR p.content LIKE ? "
                        : "");
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            if (search != null && !search.isEmpty()) {
                String pattern = "%" + search + "%";
                stmt.setString(1, pattern);
                stmt.setString(2, pattern);
            }
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** Выбирает одну страницу постов с учётом пагинации и поиска */
    public List<Post> getPostsPage(String search, int page) {
        List<Post> posts = new ArrayList<>();
        String sql = "SELECT p.id, p.title, p.content, p.created_at, p.user_id, u.username " +
                "FROM posts p LEFT JOIN users u ON p.user_id = u.id " +
                (search != null && !search.isEmpty()
                        ? "WHERE p.title LIKE ? OR p.content LIKE ? "
                        : "") +
                "ORDER BY p.created_at DESC LIMIT ? OFFSET ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            int idx = 1;
            if (search != null && !search.isEmpty()) {
                String pattern = "%" + search + "%";
                stmt.setString(idx++, pattern);
                stmt.setString(idx++, pattern);
            }
            stmt.setInt(idx++, PAGE_SIZE);
            stmt.setInt(idx, (page - 1) * PAGE_SIZE);

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
        }
        return posts;
    }

    public List<Post> getAllPosts() {
        List<Post> posts = new ArrayList<>();
        // Здесь объединяем таблицы posts и users (с LEFT JOIN, чтобы даже если пользователь удалён, пост может отображаться)
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
                post.setUsername(rs.getString("username")); // имя автора
                posts.add(post);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        System.out.println("Получено постов: " + posts.size());
        return posts;
    }


    public void addPost(Post post) {
        String sql = "INSERT INTO posts (title, content, user_id) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, post.getTitle());
            stmt.setString(2, post.getContent());
            stmt.setInt(3, post.getUserId()); // устанавливаем ID пользователя
            int affectedRows = stmt.executeUpdate();
            System.out.println("Добавлено записей: " + affectedRows);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    public Post getPostById(int id) {
        Post post = null;
        String sql = "SELECT * FROM posts WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    post = new Post();
                    post.setId(rs.getInt("id"));
                    post.setTitle(rs.getString("title"));
                    post.setContent(rs.getString("content"));
                    post.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
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
            int affectedRows = stmt.executeUpdate();
            System.out.println("Обновлено записей: " + affectedRows);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deletePost(int id) {
        String sql = "DELETE FROM posts WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            int affectedRows = stmt.executeUpdate();
            System.out.println("Удалено записей: " + affectedRows);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
