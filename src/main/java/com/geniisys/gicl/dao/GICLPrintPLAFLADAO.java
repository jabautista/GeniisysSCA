package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GICLPrintPLAFLADAO {

	Map<String, Object> queryCountLossAdvice(Map<String, Object> params) throws SQLException;
	String tagPlaAsPrinted(Map<String, Object> allParams) throws SQLException, Exception;
	String tagFlaAsPrinted(Map<String, Object> allParams) throws SQLException, Exception;
}
