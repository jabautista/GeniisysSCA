package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

public interface GIACReinsuranceReportsService {
	
	//GIACS171 
	JSONObject getDates (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	String extractToTable (HttpServletRequest request, GIISUser USER) throws SQLException;	
	String giacs181ValidateBeforeExtract(HttpServletRequest request) throws SQLException;
	
	String giacs182ValidateDateParams(HttpServletRequest request, GIISUser USER) throws SQLException;

	Map<String, Object> giacs181ExtractToTable(HttpServletRequest request, GIISUser USER) throws SQLException, Exception;
	Map<String, Object> extractGIACS182(HttpServletRequest request, GIISUser USER) throws SQLException, Exception;

	String giacs183ValidateBeforeExtract(HttpServletRequest request) throws SQLException;
	void showPremDueFromFaculRiAsOf(HttpServletRequest request, GIISUser USER) throws SQLException;
	Map<String, Object> giacs183ExtractToTable(HttpServletRequest request, GIISUser USER) throws SQLException, Exception;
	
	 //GIACS296
	JSONObject extractGIACS296(HttpServletRequest request, String userId) throws SQLException;
	// SR-3876, 3879 : shan 08.27.2015
	Map<String, Object> getExtractDateGIACS296(String userId) throws SQLException;
	Integer getExtractCountGIACS296(String userId) throws SQLException;
	
	//GIACS279
	Map<String, Object> getGIACS279InitialValues(String userId) throws SQLException;
	Map<String, Object> giacs279ExtractTable(HttpServletRequest request, String userId) throws SQLException;
	Map<String, Object> checkGIACS279Dates(String btn, String userId) throws SQLException;
	 
	 //GIACS136
	 String validateIfExisting(HttpServletRequest request, GIISUser USER) throws SQLException;
	 String validateBeforeInsert(HttpServletRequest request, GIISUser USER) throws SQLException;
	 void deletePrevExtractedRecords(HttpServletRequest request, GIISUser USER) throws SQLException;
	 String extractRecordsToTable(HttpServletRequest request, GIISUser USER) throws SQLException;
	 JSONObject getPrevParams (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	 
	 //GIACS274
	 Map<String, Object> checkGiacs274PrevExt(String userId) throws SQLException;
	 String validateGiacs274BranchCd(String branchCd) throws SQLException;
	 JSONObject extractGiacs274(HttpServletRequest request, String userId) throws SQLException;
	 
	 //GIACS121
	 Map<String, Object> getLastExtractSOAFaculRi(String userId) throws SQLException;
	 String extractSOAFaculRi(HttpServletRequest request, GIISUser USER) throws SQLException;
	 
	 //GIACS276
	 JSONObject extractGiacs276(HttpServletRequest request, String userId) throws SQLException;
	 Map<String, Object> getGiacs276InitialValues(HttpServletRequest request, String userId) throws SQLException;	/*Gzelle 09222015 SR18792*/ 
	 Map<String, Object> valExtractPrint(HttpServletRequest request, String userId) throws SQLException;	/*Gzelle 09232015 SR18792*/
	 
	 //GIACS220
	 JSONObject getDistShareList(HttpServletRequest request, String userId) throws SQLException, JSONException;
	 JSONObject getTreatyPanelList(HttpServletRequest request, String userId) throws SQLException, JSONException;
	 Map<String, Object> checkForPrevExtract(HttpServletRequest request, String userId) throws SQLException;
	 Map<String, Object> deleteAndExtract(HttpServletRequest request, String userId) throws SQLException;
	 String computeTaggedRecords(HttpServletRequest request, String userId) throws SQLException, JSONException;
	 String postTaggedRecords(HttpServletRequest request, String userId) throws SQLException, JSONException, Exception;
	 JSONObject checkBeforeView(HttpServletRequest request, String userId) throws SQLException, JSONException;
	 JSONObject getTreatyQuarterSummary(HttpServletRequest request, String userId) throws SQLException, JSONException;
	 JSONObject getTreatyCashAcct(HttpServletRequest request) throws SQLException, JSONException;
	 JSONObject getSummaryBreakdownList(HttpServletRequest request) throws SQLException, JSONException;
	 JSONObject getReportListByPage(HttpServletRequest request) throws SQLException, JSONException;
	 String saveTreatyStatement(HttpServletRequest request) throws SQLException;
	 String saveTreatyCashAcct(HttpServletRequest request) throws SQLException;
	 
	 Map<String, Object> getGIACS182Variables(String userId) throws SQLException;
}
