package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public class DBConnection {

    private static String url;
    private static String user;
    private static String pass;

    static {
        try {
            Properties props = new Properties();
            InputStream is = DBConnection.class
                    .getClassLoader()
                    .getResourceAsStream("DB.properties");

            if (is == null) {
                throw new RuntimeException("Không tìm thấy file DB.properties");
            }

            props.load(is);

            String host = props.getProperty("db.host");
            String port = props.getProperty("db.port");
            String name = props.getProperty("db.name");
            user = props.getProperty("db.user");
            pass = props.getProperty("db.password");

            url = "jdbc:mysql://" + host + ":" + port + "/" + name +
                    "?useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=UTC";

            Class.forName("com.mysql.cj.jdbc.Driver");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() {
        try {
            return DriverManager.getConnection(url, user, pass);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
