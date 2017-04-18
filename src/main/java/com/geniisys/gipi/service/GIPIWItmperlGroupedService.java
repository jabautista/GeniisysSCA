package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.gipi.entity.GIPIWItmperlGrouped;

public interface GIPIWItmperlGroupedService {

	List<GIPIWItmperlGrouped> getGipiWItmperlGrouped(Integer parId, Integer itemNo) throws SQLException;
	List<GIPIWItmperlGrouped> getGipiWItmperlGrouped2(Integer parId) throws SQLException;
	String isExist(Integer parId, Integer itemNo) throws SQLException;
	void negateDeleteItemGroup(Map<String, Object> params) throws SQLException, JSONException;
	void untagDeleteItemGroup(Map<String, Object> params) throws SQLException, JSONException;
	String checkIfBackEndt(Map<String, Object> params) throws SQLException, JSONException;
	List<GIPIWItmperlGrouped> prepareGIPIWItmperlGroupedForInsertUpdate(JSONArray setRows) throws JSONException, ParseException;
	List<Map<String, Object>> prepareGIPIWItmperlGroupedForDelete(JSONArray delRows) throws JSONException;
	JSONObject getEndtCoveragePerilAmounts(HttpServletRequest request) throws SQLException;	
	
	void deleteWItmperlGrouped(HttpServletRequest request, String userId) throws SQLException, JSONException;
	HashMap<String, Object> getCoverageVars(Map<String, Object> params) throws SQLException;
	String checkOpenAlliedPeril(HttpServletRequest request) throws SQLException;
	void saveCoverage(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> computeTsi(HttpServletRequest request) throws SQLException;
	Map<String, Object> computePremium(HttpServletRequest request) throws SQLException;
	Map<String, Object> autoComputePremRt(HttpServletRequest request) throws SQLException;
	Map<String, Object> validateAllied(HttpServletRequest request) throws SQLException;
	Map<String, Object> deleteItmPerl(HttpServletRequest request) throws SQLException;

	int checkDuration(String date1, String date2) throws SQLException;
}
