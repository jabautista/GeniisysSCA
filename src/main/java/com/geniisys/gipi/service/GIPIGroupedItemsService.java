package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.gipi.entity.GIPIGroupedItems;

public interface GIPIGroupedItemsService {
	List<GIPIGroupedItems> getGIPIGroupedItemsForEndt(Map<String, Object> params) throws SQLException;
	String checkIfGroupItemIsZeroOutOrNegated(Map<String, Object> params) throws SQLException, JSONException;
	String checkIfPrincipalEnrollee(Map<String, Object> params) throws SQLException;
	
	HashMap<String, Object> getCasualtyGroupedItems(HashMap<String, Object> params) throws SQLException;
	
	JSONObject getAccidentGroupedItems(HttpServletRequest request) throws SQLException, JSONException;
	
	JSONObject showGipis212(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject showGipis212GroupedItemDtl(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject getCoverageDtls(HttpServletRequest request) throws SQLException, JSONException;
}
