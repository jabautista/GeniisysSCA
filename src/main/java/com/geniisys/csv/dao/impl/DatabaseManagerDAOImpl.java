package com.geniisys.csv.dao.impl;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Map;

import javax.sql.DataSource;

import com.geniisys.csv.dao.DatabaseManagerDAO;
import com.geniisys.csv.entity.DBParam;
import com.mchange.v2.c3p0.DataSources;

public class DatabaseManagerDAOImpl implements DatabaseManagerDAO{
	private String driverName = "oracle.jdbc.driver.OracleDriver";
//	private String password = "cpi";
//	private String userName = "cpi";
//	private String url = "jdbc:oracle:thin:@192.10.10.103:1521:cpi";
	
	@SuppressWarnings("rawtypes")
	private Map properties;
	private DataSource pooledDataSource;

	private final static DatabaseManagerDAO INSTANCE = new DatabaseManagerDAOImpl();
	
	public static DatabaseManagerDAO getDatabaseManager(){
		return INSTANCE;
	}
	
//	private C3p0DBManager(){
//		try{
//			Class.forName(driverName);
//			DataSource unpooledDatasource = DataSources.unpooledDataSource(url, userName, password);
//			pooledDataSource = DataSources.pooledDataSource(unpooledDatasource, properties);
//		}catch(ClassNotFoundException e){
//			e.printStackTrace();
//		}catch(SQLException e){
//			e.printStackTrace();
//		}
//	}	
	
	public Connection getConnection(DBParam dbParam) throws SQLException {
		String url = "jdbc:oracle:thin:@" + dbParam.getServer() + ":1521:" + dbParam.getDatabase();
		try{
			Class.forName(driverName);
			DataSource unpooledDatasource = DataSources.unpooledDataSource(url, dbParam.getUserName(), dbParam.getPassword());
			pooledDataSource = DataSources.pooledDataSource(unpooledDatasource, properties);
		}catch(ClassNotFoundException e){
			e.printStackTrace();
		}catch(SQLException e){
			e.printStackTrace();
		}
		return pooledDataSource.getConnection();
	}
}
