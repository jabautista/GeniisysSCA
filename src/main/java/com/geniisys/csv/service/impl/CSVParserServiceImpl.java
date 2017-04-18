package com.geniisys.csv.service.impl;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.Connection;

import com.geniisys.csv.dao.CSVParserDAO;
import com.geniisys.csv.dao.impl.CSVParserDAOImpl;
import com.geniisys.csv.entity.DBParam;
import com.geniisys.csv.entity.MainParam;
import com.geniisys.csv.service.CSVParserService;

public class CSVParserServiceImpl implements CSVParserService {

	@Override
	public String parseCSV(MainParam mainParam, DBParam dbParam, Connection connection) throws IOException, Exception {
		String fileName = mainParam.getFileName();
		CSVParserDAO csvParser = new CSVParserDAOImpl();
		StringWriter stringWriter = csvParser.getCSV(dbParam, mainParam, connection);
		File file = new File(fileName);
		PrintWriter printWriter = new PrintWriter(new FileWriter(file));
		printWriter.println(stringWriter);
		printWriter.close();
		
		return stringWriter.toString();
	}

}
