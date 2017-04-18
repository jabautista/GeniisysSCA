package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIACUpdateCheckNumberDAO {
	
	public void validateCheckPrefSuf(Map<String, Object> params) throws SQLException;
	public Map<String, Object> validateCheckNo(Map<String, Object> params) throws SQLException;
	public String updateCheckNumber(Map<String, Object> params) throws SQLException; 
	
}
