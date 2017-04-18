package com.geniisys.csv.dao;

import java.io.IOException;
import java.io.StringWriter;
import java.sql.Connection;

import com.geniisys.csv.entity.DBParam;
import com.geniisys.csv.entity.MainParam;

public interface CSVParserDAO {

	public StringWriter getCSV(DBParam dbParam, MainParam mainParam, Connection connection) throws IOException, Exception;

}

