package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface GIISLossCtgryDAO {
	List<Map<String, Object>> getLossDtls(Map<String, Object> params) throws SQLException;

	Map<String, Object> fetchCorrespondingNatureOfLossBasedOnLineCd(Map<String, Object> params) throws SQLException;
	
	// shan 10.23.2013
	void saveGicls105(Map<String, Object> params) throws SQLException;
	void valDeleteRec(Map<String, Object> params) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;
}
