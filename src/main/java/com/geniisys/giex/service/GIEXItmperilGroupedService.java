package com.geniisys.giex.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

public interface GIEXItmperilGroupedService {
	
	Map<String, Object> deletePerilGrpGIEXS007(Map<String, Object> params) throws SQLException;
	Map<String, Object> createPerilGrpGIEXS007(Map<String, Object> params) throws SQLException;
	void saveGIEXItmperilGrouped(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> updateWitemGrpGIEXS007(Map<String, Object> params) throws SQLException;
	public void deleteOldPErilGrp(Map<String, Object> params) throws SQLException;
	
}
