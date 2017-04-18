package com.geniisys.common.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

public interface GIISDistShareMaintService {
	
	String saveDistShare(String strParams, Map<String, Object> params) throws JSONException, SQLException;
	String valDeleteDistShare(Map<String, Object> params) throws JSONException, SQLException;
	Map<String, Object> valAddDistShare(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateUpdateDistShare(Map<String, Object> params) throws SQLException;
	
	//added by john dolon 12.13.2013
	Object showProportionalTreatyInfo(HttpServletRequest request) throws SQLException;
	void giiss031UpdateTreaty(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, Exception;
	Map<String, Object> validateAcctTrtyType(HttpServletRequest request) throws SQLException;
	Map<String, Object> validateProfComm(HttpServletRequest request) throws SQLException;
	JSONObject showGiiss031(HttpServletRequest request, String userId, Map<String, Object> params) throws SQLException, JSONException;
	Object showNonProportionalTreatyInfo(HttpServletRequest request) throws SQLException;
	JSONObject showNonProTrtyInfo(HttpServletRequest request, String userId, Map<String, Object> params) throws SQLException, JSONException;
	void saveGiiss031(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void validateGiiss031TrtyName(HttpServletRequest request) throws SQLException;
	void validateGiiss031OldTrtySeq(HttpServletRequest request) throws SQLException;
	JSONObject showGiiss031AllRec(HttpServletRequest request, String userId, Map<String, Object> params) throws SQLException, JSONException;
	void valDeleteParentRec(HttpServletRequest request) throws SQLException;
}
