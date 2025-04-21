package com.example.miniblognoframework.dao;

import com.example.miniblognoframework.model.Category;
import com.example.miniblognoframework.utils.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {

    /** Возвращает все категории (id + name) */
    public List<Category> findAll() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT id, name FROM categories ORDER BY name";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Category c = new Category();
                c.setId   (rs.getInt   ("id"));
                c.setName (rs.getString("name"));
                list.add(c);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Ошибка выборки категорий", e);
        }
        return list;
    }
    public int addAndGetId(String name) {
        String sql = "INSERT INTO categories(name) VALUES(?)";
        try (Connection c=DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, name);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        throw new RuntimeException("Failed to insert");
    }
    public void add(String name) {
        String sql = "INSERT INTO categories(name) VALUES(?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Ошибка при добавлении категории", e);
        }
    }

    public void addCategory(String name) {
        String sql = "INSERT INTO categories(name) VALUES(?)";
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Ошибка добавления категории", e);
        }
    }

}
