package com.geniisys.giac.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.common.entity.GIISUser;

public interface GIACAmlaCoveredTransactionService {
	String getAmlaBranch(HttpServletRequest request, GIISUser USER) throws SQLException, IOException;
	List<Map<String, Object>> getAmlaRecords(HttpServletRequest request, GIISUser USER) throws SQLException;
	Map<String, Object> insertAmlaRecord(HttpServletRequest request, GIISUser USER) throws SQLException;
	String deleteAmlaRecord(GIISUser USER) throws SQLException;
}
