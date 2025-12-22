package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.ConnectionPool;

import org.jdbi.v3.core.Handle;
import java.sql.SQLException;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.ConnectionPool.HandleCallback;


/**
 * Connection wrapper cho JDBI Handle
 * Dùng trong đồ án SkyDrone để quản lý việc sử dụng connection và transaction.
 */
public class Connection {
    private final Handle handle;

    public Connection(Handle handle) {
        this.handle = handle;
    }

    public <T> T withHandle(HandleCallback<T> callback) {
        try {
            return callback.execute(handle);
        } catch (Exception e) {
            e.printStackTrace(); // log đầy đủ lỗi
            return null;
        } finally {
            ConnectionPool.releaseConnection(this); // sửa lại tên cho đúng
        }
    }

    public <T> T inTransaction(HandleCallback<T> callback) {
        try {
            handle.getConnection().setAutoCommit(false);
            T result = callback.execute(handle);
            handle.getConnection().commit();
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            try {
                handle.getConnection().rollback();
            } catch (SQLException ex) {
                throw new RuntimeException("Rollback failed", ex);
            }
            return null;
        } finally {
            try {
                handle.getConnection().setAutoCommit(true);
            } catch (SQLException ex) {
                throw new RuntimeException("Reset autoCommit failed", ex);
            }
            ConnectionPool.releaseConnection(this);
        }
    }
}

