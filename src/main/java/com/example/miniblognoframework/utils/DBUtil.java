package com.example.miniblognoframework.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    private static final String URL = "jdbc:mysql://localhost:3306/miniblog?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root"; // замени на свой логин
    private static final String PASSWORD = "Krem1978_"; // замени на свой пароль

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // явная загрузка драйвера
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC Driver not found.", e);
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
