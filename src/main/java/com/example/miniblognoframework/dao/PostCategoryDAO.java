package com.example.miniblognoframework.dao;

import com.example.miniblognoframework.utils.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PostCategoryDAO {

    /** Возвращает все category_id для данного поста */
    public List<Integer> getCategoryIds(int postId) {
        List<Integer> ids = new ArrayList<>();
        String sql = "SELECT category_id FROM post_categories WHERE post_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, postId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ids.add(rs.getInt("category_id"));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Ошибка загрузки категорий поста", e);
        }
        return ids;
    }

    /** Перезаписывает набор категорий для поста */
    public void setCategories(int postId, List<Integer> categoryIds) {
        String deleteSql = "DELETE FROM post_categories WHERE post_id=?";
        String insertSql = "INSERT INTO post_categories(post_id, category_id) VALUES (?, ?)";
        try (Connection conn = DBUtil.getConnection()) {
            // 1) удаляем старые связи
            try (PreparedStatement del = conn.prepareStatement(deleteSql)) {
                del.setInt(1, postId);
                del.executeUpdate();
            }
            // 2) вставляем новые
            try (PreparedStatement ins = conn.prepareStatement(insertSql)) {
                for (Integer catId : categoryIds) {
                    ins.setInt(1, postId);
                    ins.setInt(2, catId);
                    ins.addBatch();
                }
                ins.executeBatch();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Ошибка сохранения категорий поста", e);
        }
    }
}
