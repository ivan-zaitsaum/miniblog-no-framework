package com.example.miniblognoframework.dao;

import com.example.miniblognoframework.model.Tag;
import com.example.miniblognoframework.utils.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PostTagDAO {

    public List<Integer> getTagIds(int postId) {
        List<Integer> ids = new ArrayList<>();
        String sql = "SELECT tag_id FROM post_tags WHERE post_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, postId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ids.add(rs.getInt("tag_id"));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Ошибка загрузки тегов поста", e);
        }
        return ids;
    }

    public void setTags(int postId, List<Integer> tagIds) {
        String deleteSql = "DELETE FROM post_tags WHERE post_id = ?";
        String insertSql = "INSERT INTO post_tags(post_id, tag_id) VALUES(?,?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement del = conn.prepareStatement(deleteSql);
             PreparedStatement ins = conn.prepareStatement(insertSql)) {

            conn.setAutoCommit(false);

            del.setInt(1, postId);
            del.executeUpdate();

            for (Integer tid : tagIds) {
                ins.setInt(1, postId);
                ins.setInt(2, tid);
                ins.executeUpdate();
            }

            conn.commit();
        } catch (SQLException e) {
            throw new RuntimeException("Ошибка сохранения тегов поста", e);
        }
    }

    public List<Tag> getTagsByPostId(int postId) {
        List<Tag> result = new ArrayList<>();
        String sql =
                "SELECT t.id, t.name " +
                        "FROM tags t " +
                        "JOIN post_tag pt ON t.id = pt.tag_id " +
                        "WHERE pt.post_id = ?";
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, postId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Tag tag = new Tag();
                    tag.setId(rs.getInt("id"));
                    tag.setName(rs.getString("name"));
                    result.add(tag);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Ошибка чтения тегов поста", e);
        }
        return result;
    }

    public void addMapping(int postId, int tagId) {
        String sql = "INSERT INTO post_tag(post_id, tag_id) VALUES(?, ?)";
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ps.setInt(2, tagId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Ошибка добавления тега к посту", e);
        }
    }


}
