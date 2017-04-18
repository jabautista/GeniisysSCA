package com.geniisys.common.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISInspector;
import com.geniisys.framework.util.PaginatedList;

public interface GIISInspectorService {

	PaginatedList getInspectorListing(Map<String, Object> params) throws SQLException;

	JSONObject showGiiss169(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGiiss169(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;

	List<GIISInspector> getInspNameList() throws SQLException;
	
}
