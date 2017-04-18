package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

public interface GIPIGenerateStatisticalReportsService {

	Map<String, Object> getLineCds() throws SQLException;
	JSONObject getRecCntStatTab(HttpServletRequest request, String userId) throws SQLException;
	String extractRecordsMotorStat(HttpServletRequest request, String userId) throws SQLException;
	String chkExistingRecordMotorStat(HttpServletRequest request, String userId) throws SQLException;
	String extractFireStat(HttpServletRequest request, String userId) throws SQLException;
	JSONObject getFireTariffDtl(HttpServletRequest request, GIISUser user, String ACTION) throws SQLException, JSONException;
	JSONObject computeFireTariffTotals(HttpServletRequest request, String userId) throws SQLException;
	String getTrtyTypeCd(String commitAccumDistShare) throws SQLException;
	JSONObject computeFireZoneMasterTotals(HttpServletRequest request, String userId) throws SQLException;
	JSONObject computeFireZoneDetailTotals(HttpServletRequest request, String userId) throws SQLException;
	String getTrtyName(String commitAccumDistShare) throws SQLException;
	JSONObject getFireCommAccumDtl(HttpServletRequest request, GIISUser user, String ACTION) throws SQLException, JSONException;
	JSONObject computeFireCATotals(HttpServletRequest request, String userId) throws SQLException;
	Integer countFireStatExt(HttpServletRequest request) throws SQLException;
	JSONObject getRiskProfileMaster(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject getRiskProfileDetail(HttpServletRequest request, String userId) throws SQLException, JSONException;
	String chkRiskExtRecords(HttpServletRequest request, String userId) throws SQLException;
	Integer getTreatyCount(HttpServletRequest request, String userId) throws SQLException;
	String extractRiskProfile(HttpServletRequest request, String userId) throws SQLException;
	String saveRiskProfile(HttpServletRequest request, String userId) throws SQLException, JSONException, ParseException;
	String checkFireStat(HttpServletRequest request, String userId) throws SQLException;
	String valBeforeSave(HttpServletRequest request, String userId) throws SQLException;	//Gzelle 03262015
	String valAddUpdRec(HttpServletRequest request, String userId) throws SQLException;	//Gzelle 04072015
	Map<String, Object> validateBeforeExtract(HttpServletRequest request,String userId) throws SQLException; //edgar 04/27/2015 FULL WEB SR 4322
}
