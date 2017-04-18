package com.geniisys.giac.service;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

public interface GIACDisbursementUtilitiesService {
	
	void validateRequestNo(HttpServletRequest request) throws SQLException;
	void copyPaymentRequest(HttpServletRequest request, GIISUser USER) throws SQLException;
	void giacs045ValidateDocumentCd(HttpServletRequest request) throws SQLException;
	void giacs045ValidateBranchCdFrom(HttpServletRequest request) throws SQLException;
	void giacs045ValidateLineCd(HttpServletRequest request) throws SQLException;
	void giacs045ValidateDocYear(HttpServletRequest request) throws SQLException;
	void giacs045ValidateDocMm(HttpServletRequest request) throws SQLException;
	void giacs045ValidateBranchCdTo(HttpServletRequest request, GIISUser USER) throws SQLException;
	Map<String, Object> getBillInformationDtls(HttpServletRequest request, String userId) throws SQLException;

	JSONObject showInvoiceCommInfoListing(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	JSONObject showPerilInfoListing(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	JSONArray getGiacs408PerilList(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	void giacs408ValidateBillNo(HttpServletRequest request, String userId) throws SQLException;
	void giacs408ChkBillNoOnSelect(HttpServletRequest request) throws SQLException;
	void populateInvoiceCommPeril(HttpServletRequest request , GIISUser USER) throws SQLException;
	void validateInvCommShare(HttpServletRequest request) throws SQLException;
	void validatePerilCommRt(HttpServletRequest request) throws SQLException;
	BigDecimal recomputeCommRt(HttpServletRequest request) throws SQLException;
	BigDecimal recomputeWtaxRate(HttpServletRequest request) throws SQLException;
	JSONObject showInvCommHistoryListing(HttpServletRequest request) throws SQLException, JSONException;
	List<Map<String, Object>> getObjInsertUpdateInvperl(HttpServletRequest request) throws SQLException;
	void cancelInvoiceCommission(HttpServletRequest request) throws SQLException;
	String saveInvoiceCommission(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	String checkInvoicePayt(HttpServletRequest request) throws SQLException;
	Map<String, Object> checkRecord(HttpServletRequest request) throws SQLException;
	String keyDelRecGIACS408(HttpServletRequest request) throws SQLException;
	String postInvoiceCommission(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	JSONObject showBancAssuranceListing(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject showBancAssuranceDtls(HttpServletRequest request, GIISUser uSER) throws SQLException, JSONException;
	JSONObject showBancAssurance(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject showBancAssuranceDtls2(HttpServletRequest request, GIISUser uSER) throws SQLException, JSONException;
	String checkBancAssurance(HttpServletRequest request) throws SQLException;
	String applyBancAssurance(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	List<Map<String, Object>> recomputeCommRateGiacs408(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject recomputeCommRt2(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject getAdjustedPremAmt(HttpServletRequest request, GIISUser user)throws SQLException, JSONException;
	JSONArray getGiacs408InvoiceCommList(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
}
