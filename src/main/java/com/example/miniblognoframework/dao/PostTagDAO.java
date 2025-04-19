package com.example.miniblognoframework.dao;

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

}
