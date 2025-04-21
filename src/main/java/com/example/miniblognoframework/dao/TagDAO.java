package com.example.miniblognoframework.dao;

import com.example.miniblognoframework.model.Tag;
import com.example.miniblognoframework.utils.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TagDAO {

    /** Возвращает все теги (id + name) */
    public List<Tag> findAll() {
        List<Tag> list = new ArrayList<>();
        String sql = "SELECT id, name FROM tags ORDER BY name";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Tag t = new Tag();
                t.setId   (rs.getInt   ("id"));
                t.setName (rs.getString("name"));
                list.add(t);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Ошибка выборки тегов", e);
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
        String sql = "INSERT INTO tags(name) VALUES(?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Не удалось добавить тег", e);
        }
    }

    public void addTag(String name) {
        String sql = "INSERT INTO tags(name) VALUES(?)";
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Ошибка добавления тега", e);
        }
    }




}
