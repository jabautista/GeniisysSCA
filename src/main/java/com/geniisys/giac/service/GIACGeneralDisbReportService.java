package com.geniisys.giac.service;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;


public interface GIACGeneralDisbReportService {

	public String getGIACS273InitialFundCd() throws SQLException;
	public String validateGIACS273DocCd(HttpServletRequest request) throws SQLException;
	
	//GIACS49
	String giacs149WhenNewFormInstance(String vUpdate) throws SQLException;
	Integer countTaggedVouchers(String intmNo) throws SQLException;
	JSONObject showOvrideCommVoucher(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject computeGIACS149Totals(HttpServletRequest request, String userId) throws SQLException;
	String updateCommVoucherAmount(HttpServletRequest request, String userId) throws SQLException;
	JSONArray updateCommVoucherPrintTag(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> getCvPrefGIACS149(Map<String, Object> params) throws SQLException;
	JSONObject checkCvSeqGIACS149(HttpServletRequest request, String userId) throws SQLException;
	String updateVatGIACS149(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject populateCvSeqGIACS149(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONArray getGpcvGIACS149(Integer intmNo) throws SQLException;
	void updateGpcvGIACS149(JSONArray gpcv, HttpServletRequest request, String userId) throws SQLException;
	void delWorkflowRec(HttpServletRequest request, String userId) throws SQLException, JSONException;
	List<Map<String, Object>> prepareGpcvForUpdate(JSONArray rows, String userId) throws SQLException, JSONException;
	void gpcvRestore(HttpServletRequest request, String userId) throws SQLException, JSONException;
	String updateUnprintedVoucher(HttpServletRequest request, String userId) throws SQLException, JSONException;
	String updateDocSeqGIACS149(HttpServletRequest request, String userId) throws SQLException, JSONException;
	
	String getGiacs512CutOffDate(String extractYear) throws SQLException;
	String validateGiacs512BeforeExtract(HttpServletRequest request, String userId) throws SQLException;
	String validateGiacs512BeforePrint(HttpServletRequest request, String userId) throws SQLException;
	Map<String, Object> cpcExtractPremComm(HttpServletRequest request, String userId) throws SQLException;
	Map<String, Object> cpcExtractOsDtl(HttpServletRequest request, String userId) throws SQLException;
	Map<String, Object> cpcExtractLossPaid(HttpServletRequest request, String userId) throws SQLException;
	String getGiacs190SlTypeCd() throws SQLException;
	
	//GIACS158
	JSONObject showBankFiles(HttpServletRequest request) throws SQLException, JSONException;
	String checkViewRecords(HttpServletRequest request) throws SQLException;
	void invalidateBankFile(HttpServletRequest request, GIISUser USER) throws SQLException;
	void processViewRecords(HttpServletRequest request, GIISUser USER) throws SQLException;
	JSONObject showViewRecords(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject showViewRecordsViaBankFile(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject showViewDetailsViaRecords(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject showViewDetailsViaBankFiles(HttpServletRequest request) throws SQLException, JSONException;
	String generateBankFile (HttpServletRequest request, GIISUser USER) throws SQLException;
	Map<String, Object> getDetailsTotal (HttpServletRequest request) throws SQLException, JSONException, ParseException;
	String generateSummaryForBank(HttpServletRequest request) throws SQLException, IOException;
	Map<String, Object> getTotal (HttpServletRequest request) throws SQLException, JSONException, ParseException;
}
