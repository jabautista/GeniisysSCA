package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISLine;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.giac.entity.GIACPaytReqDocs;
import com.geniisys.giac.entity.GIACPaytRequests;

public interface GIACPaytRequestsService {

	JSONObject getGiacPaytRequests(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;	//modified from void to JSONObject; shan 08.29.2013 for GIACS070
	void saveDisbursmentRequest(HttpServletRequest request , String userID) throws SQLException, JSONException;
	String getClosedTag(Map<String, Object> params)  throws SQLException;
	Map<String, Object> getFundBranchDesc(Map<String, Object>params) throws SQLException;
	void valAmtBeforeClosing(Map<String, Object> params) throws SQLException;
	Map<String, Object> populateChkTags(Map<String, Object>params) throws SQLException;
	void closeRequest(HttpServletRequest request , String userID) throws SQLException, JSONException;
	void cancelPaymentRequest(Map<String, Object>params) throws SQLException;
	
	List<GIISLine> getPaymentLinesList(Map<String, Object> params) throws SQLException;
	List<GIACPaytRequests> getPaymentDocYear(Map<String, Object> params) throws SQLException;
	List<GIACPaytRequests> getPaymentDocMm(Map<String, Object> params) throws SQLException;
	GIACPaytRequests validateDocSeqNo(Map<String, Object> params) throws SQLException;
	void validatePaytLineCd(Map<String, Object> params) throws SQLException;
	void validatePaytDocYear(Map<String, Object> params) throws SQLException;
	void validatePaytDocMm(Map<String, Object> params) throws SQLException;
	JSONObject getGIACS016PaytReqOtherDetails(HttpServletRequest request) throws SQLException;
	List<GIACPaytReqDocs> getGIACPaytReqDocsList(Map<String, Object>params) throws SQLException;
	void extractCommFund(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkCommFundSlip(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void processAfterPrinting(Map<String, Object> params) throws SQLException; //added by reymon 06182013
	
}
