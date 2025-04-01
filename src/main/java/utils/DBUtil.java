package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    private static final String URL = "jdbc:mysql://localhost:3306/miniblog?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root"; // замени, если у тебя другой логин
    private static final String PASSWORD = "Krem1978_";

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}