package com.example.miniblognoframework.dao;

import com.example.miniblognoframework.model.User;
import com.example.miniblognoframework.utils.DBUtil;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;

public class UserDAO {

    /**
     * Создаёт нового пользователя в БД, хешируя пароль через BCrypt.
     */
    public void addUser(User user) {
        String sql = "INSERT INTO users (username, email, password, role) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            String hashed = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, hashed);
            stmt.setString(4, user.getRole());

            int affected = stmt.executeUpdate();
            if (affected == 0) {
                throw new SQLException("Creating user failed, no rows affected.");
            }
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    user.setId(generatedKeys.getInt(1));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error adding user", e);
        }
    }

    /**
     * Ищет в БД пользователя по имени.
     * @return объект User или null, если не найден.
     */
    public User getUserByUsername(String username) {
        String sql = "SELECT id, username, email, password, role FROM users WHERE username = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password")); // здесь хранится хеш
                    user.setRole(rs.getString("role"));
                    return user;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching user by username", e);
        }
        return null;
    }

    /**
     * Аутентифицирует пользователя: ищет его по имени, затем проверяет пароль через BCrypt.
     * @return объект User, если пароль совпал, иначе null.
     */
    public User authenticateUser(String username, String plainPassword) {
        User user = getUserByUsername(username);
        if (user != null && BCrypt.checkpw(plainPassword, user.getPassword())) {
            return user;
        }
        return null;
    }
}
