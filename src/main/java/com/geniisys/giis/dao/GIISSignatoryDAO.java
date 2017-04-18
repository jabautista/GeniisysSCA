package com.geniisys.giis.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISSignatoryDAO {
	Map<String, Object> validateSignatoryReport(Map<String, Object> params) throws SQLException;
	public void saveGIISSignatory(Map<String, Object> params) throws SQLException;
	public void updateFilename(Map<String, Object> params) throws SQLException;
	String getGIISS116UsedSignatories(Map<String, Object> params) throws SQLException;
}
