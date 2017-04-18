package com.geniisys.giis.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISDefaultOneRiskService {
	JSONObject showGiiss065(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddDefaultDistRec(HttpServletRequest request) throws SQLException;
	void valDelDefaultDistRec(HttpServletRequest request) throws SQLException;
	void saveGiiss065(HttpServletRequest request, String userId) throws SQLException, JSONException;
	
	JSONObject queryGiisDefaultDistGroup(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valExistingDistPerilRecord(HttpServletRequest request) throws SQLException;
	void valAddDefaultDistGroupRec(HttpServletRequest request) throws SQLException;
	JSONObject queryGiisDefaultDistDtl(HttpServletRequest request, String userId) throws SQLException, JSONException;
	String validateSaveExist(HttpServletRequest request) throws SQLException;
	JSONObject showGiiss065AllRec(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject queryAllGiisDefaultDistGroup(HttpServletRequest request,String userId) throws SQLException, JSONException;
	JSONObject queryGiisDefaultDistGroup2(HttpServletRequest request, String userId) throws SQLException, JSONException; //Added by Jerome SR 5552
	Integer getMaxSequenceNo(Integer defaultNo) throws SQLException;
}
