package com.geniisys.giac.dao;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIACDisbursementUtilitiesDAO {
	
	Map<String, Object> validateRequestNo(Map<String, Object> params) throws SQLException;
	Map<String, Object> getBillInformationDtls(Map<String, Object> params) throws SQLException;
	Map<String, Object> giacs408ValidateBillNo(Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> getGiacs408PerilList(Map<String, Object> params) throws SQLException;
	Map<String, Object> copyPaymentRequest(Map<String, Object> params) throws SQLException;
	Map<String, Object> copyPaymentRequest2(Map<String, Object> params) throws SQLException;
	String giacs045ValidateDocumentCd(Map<String, Object> params) throws SQLException;
	String giacs045ValidateBranchCdFrom(Map<String, Object> params) throws SQLException;
	String giacs045ValidateLineCd(Map<String, Object> params) throws SQLException;
	String giacs045ValidateDocYear(Map<String, Object> params) throws SQLException;
	String giacs045ValidateDocMm(Map<String, Object> params) throws SQLException;
	String giacs045ValidateBranchCdTo(Map<String, Object> params) throws SQLException;
	Map<String, Object> giacs408ChkBillNoOnSelect(Map<String, Object> params) throws SQLException;
	void populateInvoiceCommPeril(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateInvCommShare(Map<String, Object> params) throws SQLException;
	BigDecimal recomputeCommissionRt(Map<String, Object> params) throws SQLException;
	BigDecimal recomputeWtaxRate(Integer intmNo) throws SQLException;
	Map<String, Object> validatePerilCommRt(Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> getObjInsertUpdateInvperl(Map<String, Object> params) throws SQLException;
	void cancelInvoiceCommission(Map<String, Object> params) throws SQLException;
	String saveInvoiceCommission(Map<String, Object> params) throws SQLException, ParseException;
	String checkInvoicePayt(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkRecord(Map<String, Object> params) throws SQLException;
	String keyDelRecGIACS408(Map<String, Object> params) throws SQLException;
	String postInvoiceCommission(Map<String, Object> params) throws SQLException, JSONException;
	Map<String, Object> showBancAssurance(Integer policyId) throws SQLException;
	Map<String, Object> checkBancAssurance(Map<String, Object> params) throws SQLException;
	String applyBancAssurance(Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> recomputeCommRateGiacs408(Map<String, Object> params) throws SQLException;
	JSONObject getAdjustedPremAmt(Map<String, Object> params) throws SQLException, JSONException;
	List<Map<String, Object>> getGIACS408InvoiceCommList(Map<String, Object> params) throws SQLException;
}
