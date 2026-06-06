package com.smartstudy.util;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public class DBConnection {

    private static final String LOCAL_URL =
            "jdbc:mysql://localhost:3306/smartstudy_ai?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";

    private static final String LOCAL_USER = "root";
    private static final String LOCAL_PASSWORD = "";

    private static final String AZURE_DATABASE_NAME = "smartstudy_ai";

    public static Connection getConnection() throws SQLException {
        loadDriver();

        String azureConnectionString = getAzureConnectionString();

        if (azureConnectionString != null && !azureConnectionString.trim().isEmpty()) {
            return getAzureConnection(azureConnectionString);
        }

        System.out.println("DEBUG DB: MYSQLCONNSTR_localdb not found.");
        System.out.println("DEBUG DB: Using LOCAL database.");
        System.out.println("DEBUG DB URL: " + LOCAL_URL);

        return DriverManager.getConnection(LOCAL_URL, LOCAL_USER, LOCAL_PASSWORD);
    }

    private static String getAzureConnectionString() {
       
        String fromEnv = System.getenv("MYSQLCONNSTR_localdb");

        if (fromEnv != null && !fromEnv.trim().isEmpty()) {
            System.out.println("DEBUG DB: Found MYSQLCONNSTR_localdb from environment variable.");
            return fromEnv.trim();
        }

        String windowsPath = "D:\\home\\data\\mysql\\MYSQLCONNSTR_localdb.txt";

        try {
            Path path = Path.of(windowsPath);

            if (Files.exists(path)) {
                String content = Files.readString(path).trim();
                System.out.println("DEBUG DB: Found MYSQLCONNSTR_localdb from file: " + windowsPath);
                return content;
            }
        } catch (IOException e) {
            System.out.println("DEBUG DB: Could not read Azure MySQL file from Windows path.");
            e.printStackTrace();
        }

        String linuxPath = "/home/data/mysql/MYSQLCONNSTR_localdb.txt";

        try {
            Path path = Path.of(linuxPath);

            if (Files.exists(path)) {
                String content = Files.readString(path).trim();
                System.out.println("DEBUG DB: Found MYSQLCONNSTR_localdb from file: " + linuxPath);
                return content;
            }
        } catch (IOException e) {
            System.out.println("DEBUG DB: Could not read Azure MySQL file from Linux path.");
            e.printStackTrace();
        }

        return null;
    }

    private static Connection getAzureConnection(String connectionString) throws SQLException {
        Map<String, String> values = parseConnectionString(connectionString);

        String dataSource = values.get("Data Source");
        String user = values.get("User Id");
        String password = values.get("Password");

        if (dataSource == null || dataSource.trim().isEmpty()) {
            throw new SQLException("Azure MySQL connection error: Data Source is missing.");
        }

        if (user == null || user.trim().isEmpty()) {
            throw new SQLException("Azure MySQL connection error: User Id is missing.");
        }

        if (password == null) {
            password = "";
        }

        String jdbcUrl =
                "jdbc:mysql://" + dataSource + "/" + AZURE_DATABASE_NAME +
                        "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";

        System.out.println("DEBUG DB: Using AZURE MySQL In App.");
        System.out.println("DEBUG DB URL: " + jdbcUrl);
        System.out.println("DEBUG DB USER: " + user);

        return DriverManager.getConnection(jdbcUrl, user, password);
    }

    private static Map<String, String> parseConnectionString(String connectionString) {
        Map<String, String> map = new HashMap<>();

        String[] parts = connectionString.split(";");

        for (String part : parts) {
            if (part == null || part.trim().isEmpty()) {
                continue;
            }

            int index = part.indexOf("=");

            if (index > 0) {
                String key = part.substring(0, index).trim();
                String value = part.substring(index + 1).trim();
                map.put(key, value);
            }
        }

        return map;
    }

    private static void loadDriver() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException(
                    "MySQL JDBC Driver not found. Check mysql-connector-j dependency or WEB-INF/lib.",
                    e
            );
        }
    }
}