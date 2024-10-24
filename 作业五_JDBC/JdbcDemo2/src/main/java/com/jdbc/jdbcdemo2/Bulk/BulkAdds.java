package com.jdbc.jdbcdemo2.Bulk;

import java.sql.*;

public class BulkAdds {
    private static final String URL = "jdbc:mysql://localhost:3306/jdbc_demo?serverTimezone=GMT&characterEncoding=UTF-8";
    private static final String USER = "root";
    private static final String PASSWORD = "123456";
    private static final String SQL = "INSERT INTO teacher (id,name, course, birthday) VALUES (?,?, ?, ?)";

    public static void main(String[] args) {
        try(Connection conn = DriverManager.getConnection(URL,USER,PASSWORD);){
            conn.setAutoCommit(false);
            try(PreparedStatement ps = conn.prepareStatement(SQL)){
                //设置参数
                for (int i = 1; i <= 500; i++) {
                    //模拟数据：名字用“teacher”+i,课程用“course”+i
                    int id = i;
                    String name = "teacher" + i;
                    String course = "course" + i;
                    String birthday = "2023-01-01";
                    //设置PreparedStatement参数
                    ps.setInt(1,id);
                    ps.setString(2,name);
                    ps.setString(3,course);
                    ps.setDate(4, Date.valueOf(birthday));
                    //添加到批处理
                    ps.addBatch();
                    //每执行100条执行一次批处理并提交
                    if (i % 100 == 0) {
                        ps.executeBatch();
                        conn.commit();
                    }
                }
                //插入剩余记录，不满100的批次
                ps.executeBatch();
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
