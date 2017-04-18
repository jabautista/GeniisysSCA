package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GICLClmItemDAO {

	void updGiclClmItem(Map<String, Object> params) throws SQLException;
	
	void addPersonnel(Map<String, Object> params)throws SQLException;
	
	void deletePersonnel(Map<String, Object> params) throws SQLException;
}
