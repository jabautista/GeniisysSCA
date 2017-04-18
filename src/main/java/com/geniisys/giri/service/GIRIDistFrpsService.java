package com.geniisys.giri.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.springframework.context.ApplicationContext;

public interface GIRIDistFrpsService {
	
	HashMap<String, Object> getGIRIFrpsList (HashMap<String, Object>params) throws SQLException, JSONException;
	void getDistFrpsWDistFrpsV(HttpServletRequest request, ApplicationContext APPLICATION_CONTEXT, String userId) throws SQLException, JSONException;
	HashMap<String, Object> getWFrperilParams(HashMap<String, Object> params) throws SQLException, JSONException;
	Map<String, Object> updateDistFrpsGiuts004(Map<String, Object> params) throws SQLException;
	Map<String, Object> getDistFrpsWDistFrpsV2(Map<String, Object> params) throws SQLException;
}
