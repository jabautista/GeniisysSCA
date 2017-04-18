package com.geniisys.csv.dao.impl;

import java.io.IOException;
import java.io.StringWriter;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import au.com.bytecode.opencsv.CSVWriter;

import com.geniisys.csv.ConnectorCloser;
import com.geniisys.csv.dao.CSVParserDAO;
import com.geniisys.csv.dao.DatabaseManagerDAO;
import com.geniisys.csv.entity.DBParam;
import com.geniisys.csv.entity.MainParam;

public class CSVParserDAOImpl implements CSVParserDAO {
	private DatabaseManagerDAO manager = DatabaseManagerDAOImpl.getDatabaseManager();
	private ConnectorCloser connectorCloser = new ConnectorCloser();

	public StringWriter getCSV(DBParam dbParam, MainParam mainParam, Connection connection) throws IOException, Exception {
		Connection connection_orig = null;
		ResultSet resultSet = null;
		PreparedStatement preparedStatement = null;
		CallableStatement callableStatement = null;
		StringWriter stringWriter = new StringWriter();
		CSVWriter csvWriter = new CSVWriter(stringWriter);
		try {
			//connection_orig = manager.getConnection(dbParam);
			if (mainParam.isPS()) {
				//preparedStatement = connection_orig.prepareStatement(mainParam.getStatement());
				preparedStatement = connection.prepareStatement(mainParam.getStatement());
				resultSet = preparedStatement.executeQuery();
				System.out.println("true");
			} else {
				//callableStatement = connection_orig.prepareCall(mainParam.getStatement());
				callableStatement = connection.prepareCall(mainParam.getStatement());
				resultSet = callableStatement.executeQuery();
				System.out.println("false");
			}
			csvWriter.writeAll(resultSet, true);
			
			//System.out.println(sw);
		} catch (SQLException e) {
			e.printStackTrace();
			stringWriter.write("\nThe system found error in the script. Kindly check the checking script or contact the administrator for assistance.");
		} catch (NullPointerException e) {
			e.printStackTrace();
			stringWriter.write("\nThe system found error in the script. Kindly check the checking script or contact the administrator for assistance.");
		} catch (Exception e){
			e.printStackTrace();
			stringWriter.write("\nThe system found error in the script. Kindly check the checking script or contact the administrator for assistance.");
		} finally {
			connectorCloser.closeRSPSConn(resultSet, preparedStatement, callableStatement, connection_orig); // closes the database
		}
		return stringWriter;
	}

}
