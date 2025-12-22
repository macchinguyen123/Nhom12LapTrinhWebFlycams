package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.ConnectionPool;


import org.jdbi.v3.core.Handle;

/**
 * Functional interface cho callback khi thao tác với JDBI Handle
 * Dùng trong SkyDrone để viết query/update gọn bằng lambda.
 */
@FunctionalInterface
public interface HandleCallback<T> {
    T execute(Handle handle) throws Exception;
}

