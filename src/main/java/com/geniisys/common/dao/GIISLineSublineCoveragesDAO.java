package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONException;
import org.json.JSONObject;

public interface GIISLineSublineCoveragesDAO {
	JSONObject showPackageLineSublineCoverage(HttpServletRequest request, Map<String, Object> params) throws SQLException, JSONException;
	JSONObject showPackageLineCoverage(HttpServletRequest request, Map<String, Object> params) throws SQLException, JSONException;
	Map<String, Object> saveGiiss096(Map<String, Object> params) throws SQLException;
	void valDeleteRec (Map<String, Object> params) throws SQLException;
	void valAddRec (Map<String, Object> params) throws SQLException;
}