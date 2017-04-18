package com.geniisys.framework.util;

import java.sql.Connection;
import java.sql.SQLException;

import org.apache.log4j.Logger;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;

public class ConnectionUtil {

	private static Logger log = Logger.getLogger(ConnectionUtil.class);
	
	public static void releaseConnection(DataSourceTransactionManager dsManager){
		try {				
			if(dsManager != null && !dsManager.getDataSource().getConnection().isClosed()){				
				System.out.println("Closing the connection...");
				dsManager.getDataSource().getConnection().close();
				long heapSpace = Runtime.getRuntime().totalMemory();
				log.info("HEAP: " + heapSpace + " - Report data source connection closed.");
			}
		} catch (SQLException e) {
			ExceptionHandler.logException(e);	
		}
	}
	
	public static void releaseConnection(Connection conn){
		try{
			if(conn != null && !conn.isClosed()){
				System.out.println("Closing the connection...");
				conn.close();
				long heapSpace = Runtime.getRuntime().totalMemory();
				log.info("HEAP: " + heapSpace + " - Report data source connection closed.");
			}
		} catch(SQLException e){
			ExceptionHandler.logException(e);
		}
	}
}
