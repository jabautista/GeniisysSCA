package com.geniisys.csv.dao;

import java.sql.Connection;
import java.sql.SQLException;

import com.geniisys.csv.entity.DBParam;

public interface DatabaseManagerDAO {

	public Connection getConnection(DBParam dbParam) throws SQLException;

}
