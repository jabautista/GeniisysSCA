package com.geniisys.common.service;
import javax.servlet.http.HttpServletRequest;
import java.sql.SQLException;
import java.util.Map;
import org.json.JSONException;
import java.text.ParseException;


import org.json.JSONObject;


public interface GIISLossCtgryService {
	Map<String, Object> getLossDtls(Map<String, Object> params) throws SQLException;
	
	//perNatureOfLoss
	JSONObject fetchCorrespondingNatureOfLossBasedOnLineCd(HttpServletRequest request) throws SQLException, JSONException, ParseException;
	
	// shan 10.23.2013
	JSONObject showGicls105(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGicls105(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
}
