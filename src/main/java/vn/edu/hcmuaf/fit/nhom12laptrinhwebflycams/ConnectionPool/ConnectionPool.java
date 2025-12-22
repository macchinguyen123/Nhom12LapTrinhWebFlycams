package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.ConnectionPool;


import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.util.DBProperties;
import org.jdbi.v3.core.Jdbi;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * ConnectionPool cho đồ án SkyDrone
 * Quản lý pool connection để tái sử dụng, tránh tạo connection mới liên tục.
 */
public class ConnectionPool {
    private final int poolSize = Integer.parseInt(DBProperties.initialPoolSize);
    private final int maxSize = Integer.parseInt(DBProperties.maxConnections);
    private final AtomicInteger using = new AtomicInteger(0);
    private final ArrayBlockingQueue<Connection> pool;
    private static ConnectionPool connectionPool = null;

    private ConnectionPool() {
        pool = new ArrayBlockingQueue<>(maxSize);
        for (int i = 0; i < poolSize; i++) {
            pool.add(createConnection());
        }
    }

    private static Connection createConnection() {
        String url = "jdbc:mysql://" + DBProperties.host + ":" + DBProperties.port + "/" + DBProperties.dbName;
        return new Connection(Jdbi.create(url, DBProperties.username, DBProperties.password).open());
    }

    public synchronized static Connection getConnection() {
        if (connectionPool == null) {
            connectionPool = new ConnectionPool();
        }
        try {
            if (connectionPool.pool.isEmpty() && connectionPool.using.get() < connectionPool.maxSize) {
                connectionPool.using.incrementAndGet();
                return createConnection();
            }
            Connection con = connectionPool.pool.take();
            connectionPool.using.incrementAndGet();
            return con;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            return null;
        }
    }

    public static void releaseConnection(Connection connection) {
        connectionPool.using.decrementAndGet();
        if (connection != null) {
            connectionPool.pool.offer(connection);
        }
    }

    @Override
    public synchronized String toString() {
        return "Max=" + maxSize +
                " | Available=" + pool.size() +
                " | Busy=" + using.get();
    }

    public static ConnectionPool getInstance() {
        if (connectionPool == null) {
            connectionPool = new ConnectionPool();
        }
        return connectionPool;
    }
}

