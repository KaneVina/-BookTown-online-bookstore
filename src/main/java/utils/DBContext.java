package utils;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBContext {

    public Connection getConnection() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            String dbURL = "jdbc:sqlserver://localhost:1433;"
                    + "databaseName=BookTown;"
                    + "user=sa;"
                    + "password=123456;"
                    + "encrypt=true;"
                    + "trustServerCertificate=true;";

            return DriverManager.getConnection(dbURL);

        } catch (Exception e) {
            System.out.println("Khong ket noi duoc: " + e.getMessage());
            return null;
        }
    }

    public static void main(String[] args) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();

        System.out.println(conn != null
                ? "Ket noi thanh cong"
                : "That bai");
    }
}