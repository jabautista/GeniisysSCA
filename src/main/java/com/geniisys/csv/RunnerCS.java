package com.geniisys.csv;

import java.io.IOException;
import java.sql.Connection;

import com.geniisys.csv.entity.DBParam;
import com.geniisys.csv.entity.MainParam;
import com.geniisys.csv.service.CSVParserService;
import com.geniisys.csv.service.impl.CSVParserServiceImpl;

public class RunnerCS {

	public static String main(String server, String database, String userName, String password, String fileName, String statement, Connection connection) throws IOException, Exception {
		MainParam mainParam = new MainParam();
		DBParam dbParam = new DBParam();
		
		dbParam.setServer(server);
		dbParam.setDatabase(database);
		dbParam.setUserName(userName);
		dbParam.setPassword(password);
		
		mainParam.setFileName(fileName);
		mainParam.setStatement(statement);
		mainParam.setPS(false);
				
		CSVParserService parser = new CSVParserServiceImpl();
		//parser.parseCSV(mainParam, dbParam);
		return parser.parseCSV(mainParam, dbParam, connection);
	}
	
}
