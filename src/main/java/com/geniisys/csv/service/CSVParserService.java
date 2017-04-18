package com.geniisys.csv.service;

import java.io.IOException;
import java.sql.Connection;

import com.geniisys.csv.entity.DBParam;
import com.geniisys.csv.entity.MainParam;

public interface CSVParserService {
	public String parseCSV(MainParam mainParam, DBParam dbParam, Connection connection) throws IOException, Exception;
}
