package com.geniisys.common.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISBlockService {
	Map<String, Object> getDistrictLovGICLS010(Map<String, Object> params) throws SQLException;
	Map<String, Object> getBlockLovGICLS010(Map<String, Object> params) throws SQLException; 	
	JSONObject getGiiss007Province(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject getGiiss007City(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject getGiiss007District(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject getGiiss007Block(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject getGiiss007RisksDetails	(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject getGiiss007AllRisksDetails(HttpServletRequest request) throws SQLException, JSONException;
	
	void valDeleteRecRisk(HttpServletRequest request) throws SQLException;
	void valAddRecRisk(HttpServletRequest request) throws SQLException;
	void saveRiskDetails(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRecBlock(HttpServletRequest request) throws SQLException;
	void valDeleteRecBlock(HttpServletRequest request) throws SQLException;
	void saveGiiss007(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteRecProvince(HttpServletRequest request) throws SQLException;
	void valDeleteRecCity(HttpServletRequest request) throws SQLException;
	void valDeleteRecDistrict(HttpServletRequest request) throws SQLException;
	void valAddRecDistrict(HttpServletRequest request) throws SQLException;
}
