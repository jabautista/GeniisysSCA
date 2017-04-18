package com.geniisys.giuts.dao;

import java.sql.SQLException;
import java.util.Map;


public interface BatchPostingDAO {
	
	Map<String, Object> getParListByParameter(Map<String, Object> params) throws SQLException;
	void deleteLog(Map<String, Object> param) throws SQLException;
	String checkIfBackEndt (Map<String, Object> param) throws SQLException;
	String batchPost (Map<String, Object> param) throws SQLException;
}
