package com.geniisys.giuts.service.impl;

import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.entity.GIPIInstallment;
import com.geniisys.giuts.dao.GIUTSChangeInPaymentTermDAO;
import com.geniisys.giuts.entity.GIUTSChangeInPaymentTerm;
import com.geniisys.giuts.service.GIUTSChangeInPaymentTermService;
import com.seer.framework.util.StringFormatter;

public class GIUTSChangeInPaymentTermServiceImpl implements GIUTSChangeInPaymentTermService {

	private GIUTSChangeInPaymentTermDAO giutsChangeInPaymentTermDAO;

	public GIUTSChangeInPaymentTermDAO getGiutsChangeInPaymentTermDAO() {
		return giutsChangeInPaymentTermDAO;
	}

	public void setGiutsChangeInPaymentTermDAO(GIUTSChangeInPaymentTermDAO giutsChangeInPaymentTermDAO) {
		this.giutsChangeInPaymentTermDAO = giutsChangeInPaymentTermDAO;

	}

	/*@Override
	public GIUTSChangeInPaymentTerm getGIUTS022InvoiceInfo(Integer policyId) throws SQLException {
		return getGiutsChangeInPaymentTermDAO().getGIUTS022InvoiceInfo(policyId);
	}*/

	@Override
	public JSONObject getGIUTS022InvoiceInfo(HttpServletRequest request)throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "showChangeInPaymentTerm");
		params.put("policyId", request.getParameter("policyId"));
		Map<String, Object> invoiceTable = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonInvoice = new JSONObject(invoiceTable);
		request.setAttribute("jsonInvoice", jsonInvoice);
		return jsonInvoice;
	}
	
	@Override
	public JSONObject showInstallmentDetails(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getInstallmentDetails");
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		params.put("itemGrp", request.getParameter("itemGrp"));
		params.put("pageSize", 40);
		Map<String, Object> installmentTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonInstallment = new JSONObject(installmentTableGrid);
		request.setAttribute("jsonInstallment", jsonInstallment);
		return jsonInstallment;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> updatePaymentTerm(HttpServletRequest request, GIISUser USER) throws SQLException, ParseException {
		DateFormat df = new SimpleDateFormat("MM-dd-yyy");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		params.put("userId", USER.getUserId());
		params.put("itemGrp", request.getParameter("itemGrp"));
		params.put("policyId", request.getParameter("policyId"));
		params.put("dueDate", df.parse(request.getParameter("dueDate")));
		params.put("paytTermsDesc", request.getParameter("paytTermsDesc"));
		params.put("premAmt", request.getParameter("premAmt"));
		params.put("otherCharges", request.getParameter("otherCharges"));
		params.put("notarialFee", request.getParameter("notarialFee"));
		params.put("taxAmt", request.getParameter("taxAmt"));
		params.put("commitChanges", request.getParameter("commitChanges"));
		params =  this.giutsChangeInPaymentTermDAO.updatePaymentTerm(params);
		List<GIPIInstallment> instList =  (List<GIPIInstallment>) StringFormatter.escapeHTMLInList(params.get("newItems"));
		params.put("newItems", new JSONArray(instList));
		return params;
	}


	@Override
	public List<GIPIInstallment> getInstallmentChange(String issCd, Integer premSeqNo) throws SQLException {
		List<GIPIInstallment> gipiInstallment = new ArrayList<GIPIInstallment>();
		gipiInstallment = this.getGiutsChangeInPaymentTermDAO().getInstallmentChange(issCd, premSeqNo);
		return gipiInstallment;
	}
	
	@Override
	public JSONObject showTaxAllocation(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getTaxAllocation");
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		params.put("itemGrp", request.getParameter("itemGrp"));
		Map<String, Object> taxAllocationTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonTaxAllocation = new JSONObject(taxAllocationTableGrid);
		request.setAttribute("jsonTaxAllocation", jsonTaxAllocation);
		return jsonTaxAllocation;
	}

	@Override
	public String updateDueDate(HttpServletRequest request, String USER) throws JSONException, SQLException, ParseException {
		JSONObject objParameters = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), USER, GIPIInstallment.class));
		
		return this.getGiutsChangeInPaymentTermDAO().updateDueDate(allParams);
	}

	@Override
	public String validateFullyPaid(HttpServletRequest request) throws JSONException, SQLException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		return this.getGiutsChangeInPaymentTermDAO().validateFullyPaid(params);
	}

	@Override
	public JSONObject validateInceptExpiry(HttpServletRequest request) throws SQLException, ParseException {
		DateFormat df = new SimpleDateFormat("MM-dd-yyy");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("invDueDate", df.parse(request.getParameter("invDueDate")));
		
		Map<String, Object> result = this.getGiutsChangeInPaymentTermDAO().validateInceptExpiry(params);
		JSONObject resultJSON = new JSONObject(result);
		System.out.println(params);
		return resultJSON;
	}

	@Override
	public String updateDueDateInvoice(HttpServletRequest request) throws JSONException, SQLException, ParseException {
		DateFormat df = new SimpleDateFormat("MM-dd-yyy");
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("dueDate", df.parse(request.getParameter("dueDate")));
		allParams.put("policyId", request.getParameter("policyId"));
		
		return this.getGiutsChangeInPaymentTermDAO().updateDueDateInvoice(allParams);
	}

	@Override
	public String checkIfCanChange(HttpServletRequest request) throws JSONException, SQLException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("policyId", request.getParameter("policyId"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		return this.getGiutsChangeInPaymentTermDAO().checkIfCanChange(params);
	}

	@Override
	public String updateWorkflowSwitch(HttpServletRequest request, GIISUser USER)throws SQLException, ParseException {
		Map<String, Object> allParams = new HashMap<String, Object>();
		String modId = "GIACS211";
		String eventDesc = "CHANGE PAYMENT MODE";
		allParams.put("eventDesc", eventDesc);
		allParams.put("moduleId",  modId);
		allParams.put("userId", USER.getUserId());
		
		return this.getGiutsChangeInPaymentTermDAO().updateWorkflowSwitch(allParams);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object>  updateTaxAllocation(HttpServletRequest request, String USER) throws JSONException, SQLException, ParseException {
		JSONObject objParameters = new JSONObject(request.getParameter("parameters"));
		DateFormat df = new SimpleDateFormat("MM-dd-yyy");
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), USER, GIUTSChangeInPaymentTerm.class));
		allParams.put("issCd", request.getParameter("issCd"));
		allParams.put("premSeqNo", request.getParameter("premSeqNo"));
		allParams.put("policyId", request.getParameter("policyId"));
		allParams.put("paytTermsDesc", request.getParameter("paytTermsDesc"));
		allParams.put("taxAmt", request.getParameter("taxAmt"));
		List<GIPIInstallment> instList =  (List<GIPIInstallment>) allParams.get("newItems");
		allParams.put("newItems", new JSONArray(instList));
		allParams.put("userId", USER);
		allParams.put("itemGrp", request.getParameter("itemGrp"));
		allParams.put("dueDate", df.parse(request.getParameter("dueDate")));
		allParams.put("premAmt", request.getParameter("premAmt"));
		allParams.put("otherCharges", request.getParameter("otherCharges"));
		allParams.put("notarialFee", request.getParameter("notarialFee"));
		
		return this.getGiutsChangeInPaymentTermDAO().updateTaxAllocation(allParams);
	}

	@Override
	public Map<String, Object> updateAllocation(HttpServletRequest request, String USER) throws JSONException, SQLException, ParseException {
		JSONObject objParameters = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), USER, GIUTSChangeInPaymentTerm.class));
		return this.getGiutsChangeInPaymentTermDAO().updateAllocation(params);
	}

	@Override
	public JSONObject checkIfPolicyExists(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "showGIUTS022PolicyLOV");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("endtIssCd", request.getParameter("endtIssCd"));
		params.put("endtYy", request.getParameter("endtYy"));
		params.put("endtSeqNo", request.getParameter("endtSeqNo"));	
		params.put("userId", USER.getUserId());
		Map<String, Object> checkIfPolicyExists = TableGridUtil.getTableGrid(request, params);
		JSONObject policyExists = new JSONObject(checkIfPolicyExists);
		return policyExists;
	}
	
	@Override
	public Map<String, Object> getDueDate(HttpServletRequest request) throws JSONException, SQLException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
		params.put("paytTerm", request.getParameter("paytTerm"));
		params.put("premSeqNo", Integer.parseInt(request.getParameter("premSeqNo")));
		return this.getGiutsChangeInPaymentTermDAO().getDueDate(params);
	}
	

}
