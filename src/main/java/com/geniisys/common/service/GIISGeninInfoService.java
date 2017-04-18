package com.geniisys.common.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISGeninInfo;
import com.geniisys.framework.util.PaginatedList;

public interface GIISGeninInfoService {

	PaginatedList getInitInfoList(HashMap<String, Object> params, Integer pageNo) throws SQLException;
	PaginatedList getGenInfoList(HashMap<String, Object> params, Integer pageNo) throws SQLException;
	
	// shan 12.11.2013
	JSONObject showGiiss180(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGiiss180(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	String allowUpdate(String geninInfoCd) throws SQLException;
	List<GIISGeninInfo> prepareGeninInfoForInsert(JSONArray rows, String userId) throws SQLException, JSONException;
}
