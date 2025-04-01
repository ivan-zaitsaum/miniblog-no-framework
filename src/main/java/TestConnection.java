import utils.DBUtil;

import java.sql.Connection;

public class TestConnection {
    public static void main(String[] args) {
        try (Connection conn = DBUtil.getConnection()) {
            System.out.println("Успешное подключение к базе данных!");
        } catch (Exception e) {
            System.out.println("Ошибка подключения:");
            e.printStackTrace();
        }
    }
}
