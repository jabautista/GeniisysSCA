package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIACFileSourceDAO {
	String saveFileSource(Map<String, Object> allParams) throws SQLException;
}
