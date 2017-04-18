package com.geniisys.giuts.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gipi.entity.GIPIInstallment;

public interface GIUTSChangeInPaymentTermService {
	//GIUTSChangeInPaymentTerm getGIUTS022InvoiceInfo(Integer policyId) throws SQLException;
	JSONObject getGIUTS022InvoiceInfo(HttpServletRequest request) throws SQLException, JSONException, ParseException;
	JSONObject checkIfPolicyExists(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject showInstallmentDetails (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	public Map<String, Object> updatePaymentTerm(HttpServletRequest request, GIISUser USER) throws SQLException, ParseException, JSONException;
	String updateDueDate(HttpServletRequest request, String USER) throws JSONException, SQLException, ParseException;
	List<GIPIInstallment> getInstallmentChange(String issCd, Integer premSeqNo) throws SQLException;
	JSONObject showTaxAllocation (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	String validateFullyPaid (HttpServletRequest request)throws JSONException, SQLException, ParseException;
	JSONObject validateInceptExpiry(HttpServletRequest request) throws SQLException, ParseException;
	String updateDueDateInvoice(HttpServletRequest request) throws JSONException, SQLException, ParseException;
	String checkIfCanChange (HttpServletRequest request) throws JSONException, SQLException, ParseException;
	String updateWorkflowSwitch (HttpServletRequest request, GIISUser USER) throws SQLException,ParseException; 
	public Map<String, Object> updateAllocation(HttpServletRequest request, String USER) throws JSONException, SQLException, ParseException;
	public Map<String, Object> updateTaxAllocation(HttpServletRequest request, String USER) throws JSONException, SQLException, ParseException;
	Map<String, Object> getDueDate (HttpServletRequest request)throws JSONException, SQLException, ParseException; //carlo SR 5928 02-14-2017
}
