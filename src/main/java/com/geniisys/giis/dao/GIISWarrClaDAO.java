package com.geniisys.giis.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISLine;

public interface GIISWarrClaDAO {
	
	List<GIISLine> getGIISLine() throws SQLException;
	String validateDeleteWarrCla(Map<String, Object> params) throws SQLException;
	String validateAddWarrCla(Map<String, Object> params) throws SQLException;
	String saveWarrCla(Map<String, Object> allParams) throws SQLException;

}
