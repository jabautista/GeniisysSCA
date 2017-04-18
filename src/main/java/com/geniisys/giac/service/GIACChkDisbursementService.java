/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.giac.service
	File Name: GIACChkDisbursementService.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Jun 19, 2012
	Description: 
*/


package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.giac.entity.GIACChkDisbursement;

public interface GIACChkDisbursementService {
	GIACChkDisbursement getGiacs016GiacDisb(Integer gaccTranId) throws SQLException;
	
	GIACChkDisbursement getGiacs002ChkDisbursement(Map<String, Object> params) throws SQLException;
	String saveCheckDisbursement(HttpServletRequest request, String userId) throws SQLException, JSONException, Exception;
	Map<String, Object> spoilCheck(Map<String, Object> params) throws SQLException, Exception;
	Integer getCheckCount(Integer gaccTranId) throws SQLException;
	String validateCheckNo(Map<String, Object> params) throws SQLException, Exception;
	String validateBankCd(Map<String, Object> params) throws SQLException, Exception;
	List<String> getDBItemNoList(Map<String, Object> params) throws SQLException;
	Map<String, Object> giacs052NewFormInstance(HttpServletRequest request) throws SQLException;
	Map<String, Object> getGiacs052DefaultCheck(HttpServletRequest request) throws SQLException;
	Map<String, Object> giacs052ProcessAfterPrinting(HttpServletRequest request, String userId) throws SQLException;
	void giacs052UpdateGiac(HttpServletRequest request, String userId) throws SQLException;
	void giacs052SpoilCheck(HttpServletRequest request, String userId) throws SQLException;
	void giacs052RestoreCheck(HttpServletRequest request, String userId) throws SQLException;
	void giacs052CheckDupOr(HttpServletRequest request) throws SQLException;
	Map<String, Object> setCmDmPrintBtn(HttpServletRequest request, String userId) throws SQLException, Exception;
	List<Map<String, Object>> getCmDmTranIdMemoStat(HttpServletRequest request) throws SQLException, Exception; /*ADDED by MarkS 5.24.2016 SR-5484*/
	Map<String, Object> generateCheck(HttpServletRequest request) throws SQLException;
	JSONObject getCheckBatchList(HttpServletRequest request) throws SQLException, JSONException;
	void validateSpoilCheck(HttpServletRequest request) throws SQLException;
	void spoilCheckGIACS054(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Integer getCheckSeqNo(HttpServletRequest request) throws SQLException;
	void validateCheckSeqNo(HttpServletRequest request) throws SQLException;
	void processPrintedChecks(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void updatePrintedChecks(HttpServletRequest request, String userId) throws SQLException, JSONException;
	String checkDVPrintColumn(HttpServletRequest request) throws SQLException;
	JSONArray getCheckBatchListByParam(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject generateCheckNo(HttpServletRequest request) throws SQLException, JSONException;
}
