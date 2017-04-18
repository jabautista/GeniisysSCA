package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONException;
import org.json.JSONObject;

public interface GIISVessClassDAO {
	JSONObject showVesselClassification(HttpServletRequest request, Map<String, Object> params) throws SQLException, JSONException;
	Map<String, Object> validateGIISS047VesselClass (Map<String, Object> params) throws SQLException;
	Map<String, Object> saveVessClass(Map<String, Object> params) throws SQLException;
	void valDelRec(Integer vessClassCd) throws SQLException;
}
