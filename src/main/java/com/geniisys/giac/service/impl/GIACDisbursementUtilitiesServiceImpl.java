package com.geniisys.giac.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
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
import com.geniisys.giac.dao.GIACDisbursementUtilitiesDAO;
import com.geniisys.giac.service.GIACDisbursementUtilitiesService;
import com.geniisys.giuw.entity.GIUWPolDistPolbasicV;
import com.seer.framework.util.StringFormatter;

public class GIACDisbursementUtilitiesServiceImpl implements GIACDisbursementUtilitiesService {
	
	private GIACDisbursementUtilitiesDAO giacDisbursementUtilitiesDAO;
	
	private GIACDisbursementUtilitiesDAO getGiacDisbursementUtilitiesDAO() {
		return giacDisbursementUtilitiesDAO;
	}
	
	public void setGiacDisbursementUtilitiesDAO(GIACDisbursementUtilitiesDAO giacDisbursementUtilitiesDAO) {
		this.giacDisbursementUtilitiesDAO = giacDisbursementUtilitiesDAO;
	}

	@Override
	public void validateRequestNo(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("documentCdFrom", request.getParameter("documentCdFrom"));
		params.put("branchCdFrom", request.getParameter("branchCdFrom"));
		params.put("lineCdFrom", request.getParameter("lineCdFrom"));
		params.put("docYearFrom", request.getParameter("docYearFrom"));
		params.put("docMmFrom", request.getParameter("docMmFrom"));
		params.put("docSeqNoFrom", request.getParameter("docSeqNoFrom"));
		System.out.println("::: PARAMS IN validateRequestNo ServiceImpl :::");
		System.out.println(params);
		request.setAttribute("object", new JSONObject(this.giacDisbursementUtilitiesDAO.validateRequestNo(params)));
	}

	@Override
	public Map<String, Object> getBillInformationDtls(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		params.put("policyId", request.getParameter("policyId"));
		params.put("userId", userId);
		return this.giacDisbursementUtilitiesDAO.getBillInformationDtls(params);
	}

	@Override
	public JSONObject showInvoiceCommInfoListing(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIACS408InvoiceCommInfoList");				
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		params.put("posted", request.getParameter("posted"));
		params.put("nbtShowAll", request.getParameter("nbtShowAll"));
		System.out.println("getGIACS408InvoiceCommInfoList params " + params.toString());
		Map<String, Object> invCommInfoTableGrid = TableGridUtil.getTableGrid(request, params);
		System.out.println(invCommInfoTableGrid.toString());
		JSONObject jsonInvCommInfoList = new JSONObject(invCommInfoTableGrid);
		return jsonInvCommInfoList;
	}
	
	@Override
	public JSONObject showPerilInfoListing(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIACS408PerilInfoList");				
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("commRecId", request.getParameter("commRecId"));
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("lineCd", request.getParameter("lineCd"));
		
		Map<String, Object> perilInfoTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonPerilInfoList = new JSONObject(perilInfoTableGrid);
		return jsonPerilInfoList;
	}
	
	@SuppressWarnings("unchecked")
	public JSONArray getGiacs408PerilList(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("commRecId", request.getParameter("commRecId"));
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("lineCd", request.getParameter("lineCd"));
		
		List<Map<String, Object>> list = (List<Map<String, Object>>) StringFormatter.escapeHTMLInList(giacDisbursementUtilitiesDAO.getGiacs408PerilList(params));
		System.out.println("list total: "+list.size());
		JSONArray arr = new JSONArray(list);
		System.out.println("array length: "+ arr.length());
		return arr;
	}

	@Override
	public void giacs408ValidateBillNo(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		params.put("userId", userId);
		request.setAttribute("object", new JSONObject(this.giacDisbursementUtilitiesDAO.giacs408ValidateBillNo(params)));
	}

	@Override
	public void copyPaymentRequest(HttpServletRequest request, GIISUser USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		String includeAcctgEntries = request.getParameter("includeAcctgEntries");
		params.put("documentCdFrom", request.getParameter("documentCdFrom"));
		params.put("branchCdFrom", request.getParameter("branchCdFrom"));
		params.put("lineCdFrom", request.getParameter("lineCdFrom"));
		params.put("docYearFrom", request.getParameter("docYearFrom"));
		params.put("docMmFrom", request.getParameter("docMmFrom"));
		params.put("docSeqNoFrom", request.getParameter("docSeqNoFrom"));
		params.put("documentCdTo", request.getParameter("documentCdTo"));
		params.put("branchCdTo", request.getParameter("branchCdTo"));
		params.put("lineCdTo", request.getParameter("lineCdTo"));
		params.put("docYearTo", request.getParameter("docYearTo"));
		params.put("docMmTo", request.getParameter("docMmTo"));
		params.put("refIdFrom", request.getParameter("refIdFrom"));
		params.put("fundCdFrom", request.getParameter("fundCdFrom"));
		params.put("tranDateFrom", request.getParameter("tranDateFrom"));
		params.put("userId", USER.getUserId());
		params.put("tranIdFrom", request.getParameter("tranIdFrom"));
		
		if(includeAcctgEntries.equals("N")){
			request.setAttribute("object", new JSONObject(this.giacDisbursementUtilitiesDAO.copyPaymentRequest(params)));
		} else if(includeAcctgEntries.equals("Y")) {
			request.setAttribute("object", new JSONObject(this.giacDisbursementUtilitiesDAO.copyPaymentRequest2(params)));
		}
		
		
	}

	@Override
	public void giacs045ValidateDocumentCd(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("documentCd", request.getParameter("documentCd"));
		request.setAttribute("object", this.giacDisbursementUtilitiesDAO.giacs045ValidateDocumentCd(params));
	}

	@Override
	public void giacs045ValidateBranchCdFrom(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("documentCd", request.getParameter("documentCd"));
		params.put("branchCdFrom", request.getParameter("branchCdFrom"));
		request.setAttribute("object", this.giacDisbursementUtilitiesDAO.giacs045ValidateBranchCdFrom(params));
	}

	@Override
	public void giacs045ValidateLineCd(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("documentCd", request.getParameter("documentCd"));
		params.put("branchCdFrom", request.getParameter("branchCdFrom"));
		params.put("lineCd", request.getParameter("lineCd"));
		request.setAttribute("object", this.giacDisbursementUtilitiesDAO.giacs045ValidateLineCd(params));
	}

	@Override
	public void giacs045ValidateDocYear(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("documentCd", request.getParameter("documentCd"));
		params.put("branchCdFrom", request.getParameter("branchCdFrom"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("docYear", request.getParameter("docYear"));
		request.setAttribute("object", this.giacDisbursementUtilitiesDAO.giacs045ValidateDocYear(params));
	}

	@Override
	public void giacs045ValidateDocMm(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("documentCd", request.getParameter("documentCd"));
		params.put("branchCdFrom", request.getParameter("branchCdFrom"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("docYear", request.getParameter("docYear"));
		params.put("docMm", request.getParameter("docMm"));
		request.setAttribute("object", this.giacDisbursementUtilitiesDAO.giacs045ValidateDocMm(params));
	}

	@Override
	public void giacs045ValidateBranchCdTo(HttpServletRequest request, GIISUser USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("branchCdTo", request.getParameter("branchCdTo"));
		request.setAttribute("object", this.giacDisbursementUtilitiesDAO.giacs045ValidateBranchCdTo(params));
	}

	@Override
	public void giacs408ChkBillNoOnSelect(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", Integer.parseInt(request.getParameter("premSeqNo")));
		params.put("polFlag", null);
		params.put("premAmt", null);
		params.put("commAmt", null);
		params.put("exist", null);
		request.setAttribute("object", new JSONObject(this.giacDisbursementUtilitiesDAO.giacs408ChkBillNoOnSelect(params)));
	}
	
	public void populateInvoiceCommPeril(HttpServletRequest request, GIISUser USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", Integer.parseInt(request.getParameter("premSeqNo")));
		params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("userId", USER.getUserId());
		this.giacDisbursementUtilitiesDAO.populateInvoiceCommPeril(params);
	}

	@Override
	public void validateInvCommShare(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("commRecId", request.getParameter("commRecId") == null || request.getParameter("commRecId") == "" ? null : Integer.parseInt(request.getParameter("commRecId")));
		params.put("intmNo", request.getParameter("intmNo") == null || request.getParameter("intmNo") == "" ? null : Integer.parseInt(request.getParameter("intmNo")));
		params.put("premSeqNo", request.getParameter("premSeqNo") == null || request.getParameter("premSeqNo") == "" ? null : Integer.parseInt(request.getParameter("premSeqNo")));
		params.put("issCd", request.getParameter("issCd"));
		params.put("notIn", new BigDecimal(request.getParameter("currentTotalShare")));
		params.put("currentTotalShare", new BigDecimal(request.getParameter("sharePercentage")));
		params.put("message", null);
		request.setAttribute("object", new JSONObject(this.giacDisbursementUtilitiesDAO.validateInvCommShare(params)));
	}
	
	public void validatePerilCommRt(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("commRecId", Integer.parseInt(request.getParameter("commRecId")));
		params.put("intmNo", Integer.parseInt(request.getParameter("intmNo")));
		params.put("commPerilId", Integer.parseInt(request.getParameter("commPerilId")));
		params.put("commPaid", request.getParameter("commPaid"));
		params.put("commissionRt", new BigDecimal(request.getParameter("commissionRt")));
		params.put("message", null);
		params.put("lineCd", request.getParameter("lineCd"));  //Deo [03.07.2017]: add start (SR-5944)
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("perilCd", Integer.parseInt(request.getParameter("perilCd")));  //Deo [03.07.2017]: add ends (SR-5944)
		
		this.giacDisbursementUtilitiesDAO.validatePerilCommRt(params);
		
		BigDecimal commRt = (BigDecimal) params.get("commissionRt");
		params.put("commissionRt", commRt.toPlainString());
		
		request.setAttribute("object", new JSONObject(params));
	}
	
	@Override
	public JSONObject showInvCommHistoryListing(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIACS408InvCommHistoryList");				
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", Integer.parseInt(request.getParameter("premSeqNo")));
		
		Map<String, Object> invCommHistTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonInvCommHistList = new JSONObject(invCommHistTableGrid);
		return jsonInvCommHistList;
	}

	@Override
	public List<Map<String, Object>> getObjInsertUpdateInvperl(
			HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("recordStatus", request.getParameter("recordStatus"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", Integer.parseInt(request.getParameter("premSeqNo")));
		params.put("premAmt", new BigDecimal(request.getParameter("premAmt")));
		params.put("premiumAmt", new BigDecimal(request.getParameter("premiumAmt")));
		params.put("intmNo", Integer.parseInt(request.getParameter("intmNo")));
		params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
		return giacDisbursementUtilitiesDAO.getObjInsertUpdateInvperl(params);
	}

	@Override
	public BigDecimal recomputeCommRt(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", Integer.parseInt(request.getParameter("premSeqNo")));
		params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
		params.put("intmNo", request.getParameter("intmNo") == null || request.getParameter("intmNo") == "" ? null : Integer.parseInt(request.getParameter("intmNo")));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("perilCd", Integer.parseInt(request.getParameter("perilCd")));
		return this.giacDisbursementUtilitiesDAO.recomputeCommissionRt(params);
	}
	
	@Override
	public BigDecimal recomputeWtaxRate(HttpServletRequest request) throws SQLException {
		Integer intmNo = Integer.parseInt(request.getParameter("intmNo"));
		return this.giacDisbursementUtilitiesDAO.recomputeWtaxRate(intmNo);
	}

	@Override
	public void cancelInvoiceCommission(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("commRecId", Integer.parseInt(request.getParameter("commRecId")));
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		this.giacDisbursementUtilitiesDAO.cancelInvoiceCommission(params);
	}

	@Override
	public String saveInvoiceCommission(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		JSONObject objParams = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("USER", USER);
		params.put("userId", USER.getUserId());
		params.put("setPerilInfo", JSONUtil.prepareMapListFromJSON(new JSONArray(objParams.getString("setPerilInfo"))));
		params.put("setInvComm", JSONUtil.prepareMapListFromJSON(new JSONArray(objParams.getString("setInvComm"))));
		params.put("delInvComm", JSONUtil.prepareMapListFromJSON(new JSONArray(objParams.getString("delInvComm"))));
		params.put("issCd", objParams.getString("issCd"));
		params.put("premSeqNo", objParams.getString("premSeqNo"));
		params.put("fundCd", objParams.getString("fundCd"));
		params.put("branchCd", objParams.getString("branchCd"));
		return StringFormatter.escapeHTML(this.giacDisbursementUtilitiesDAO.saveInvoiceCommission(params));
	}

	@Override
	public String checkInvoicePayt(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", Integer.parseInt(request.getParameter("premSeqNo")));
		params.put("intmNo", Integer.parseInt(request.getParameter("intmNo")));
		params.put("message", null);
		return (String) giacDisbursementUtilitiesDAO.checkInvoicePayt(params);
	}

	@Override
	public Map<String, Object> checkRecord(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", Integer.parseInt(request.getParameter("premSeqNo")));
		params.put("allowCOI", null);
		params.put("vRecord", null);
		return (Map<String, Object>) giacDisbursementUtilitiesDAO.checkRecord(params);
	}

	@Override
	public String keyDelRecGIACS408(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", Integer.parseInt(request.getParameter("premSeqNo")));
		params.put("intmNo", Integer.parseInt(request.getParameter("intmNo")));
		params.put("message", null);
		return (String) giacDisbursementUtilitiesDAO.keyDelRecGIACS408(params);
	}

	@Override
	public String postInvoiceCommission(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", Integer.parseInt(request.getParameter("premSeqNo")));
		params.put("commRecId", (request.getParameter("commRecId") == null || request.getParameter("commRecId") == "") ? null : Integer.parseInt(request.getParameter("commRecId")));
		params.put("intmNo", request.getParameter("intmNo")); //added by steven 10.15.2014
		params.put("userId", USER.getUserId());
		return (String) giacDisbursementUtilitiesDAO.postInvoiceCommission(params);
	}

	@Override
	public JSONObject showBancAssuranceListing(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getgiacs408BancTypeList");				
		params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
		
		Map<String, Object> bancAssuranceTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonBancAssuranceList = new JSONObject(bancAssuranceTableGrid);
		return jsonBancAssuranceList;
	}

	@Override
	public JSONObject showBancAssuranceDtls(HttpServletRequest request, GIISUser uSER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getgiacs408BancTypeDtlsList");
		params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
		params.put("vModBtyp", request.getParameter("vModBtyp"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", Integer.parseInt(request.getParameter("premSeqNo")));
		
		Map<String, Object> bancAssuranceDtlsTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonBancAssuranceDtlsList = new JSONObject(bancAssuranceDtlsTableGrid);
		return jsonBancAssuranceDtlsList;
	}

	@Override
	public JSONObject showBancAssurance(HttpServletRequest request) throws SQLException {
		Integer policyId = Integer.parseInt(request.getParameter("policyId"));
		Map<String, Object> params = getGiacDisbursementUtilitiesDAO().showBancAssurance(policyId);
		JSONObject json = new JSONObject(params);
		return json;
	}
	
	@Override
	public JSONObject showBancAssuranceDtls2(HttpServletRequest request, GIISUser uSER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getgiacs408BancTypeDtls2List");
		params.put("vModBtyp", request.getParameter("vModBtyp"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", Integer.parseInt(request.getParameter("premSeqNo")));
		params.put("bancTypeCd", Integer.parseInt(request.getParameter("bancTypeCd")));
		
		Map<String, Object> bancAssuranceDtlsTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonBancAssuranceDtlsList = new JSONObject(bancAssuranceDtlsTableGrid);
		return jsonBancAssuranceDtlsList;
	}

	@Override
	public String checkBancAssurance(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", Integer.parseInt(request.getParameter("premSeqNo")));
		params.put("intmNo", Integer.parseInt(request.getParameter("intmNo")));
		params.put("vModBtyp", request.getParameter("vModBtyp"));
		params.put("commRecId", Integer.parseInt(request.getParameter("commRecId")));
		params.put("intmType", request.getParameter("intmType"));
		params.put("bancTypeCd", request.getParameter("bancTypeCd"));

		JSONObject result = new JSONObject(this.getGiacDisbursementUtilitiesDAO().checkBancAssurance(params));
		return result.toString();
	}

	@Override
	public String applyBancAssurance(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		JSONObject objParams = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("setBancAssurance", JSONUtil.prepareMapListFromJSON(new JSONArray(objParams.getString("setBancAssurance"))));
		params.put("vModBtyp", objParams.getString("vModBtyp"));
		params.put("b140PremAmt", objParams.getString("b140PremAmt"));
		params.put("b140NbtLineCd", objParams.getString("b140NbtLineCd"));
		params.put("b140IssCd", objParams.getString("b140IssCd"));
		params.put("b140PremSeqNo", objParams.getString("b140PremSeqNo"));
		params.put("bancaNbtBancTypeCd", objParams.getString("bancaNbtBancTypeCd"));
		params.put("fundCd", objParams.getString("fundCd"));
		params.put("branchCd", objParams.getString("branchCd"));
		params.put("b140PolicyId", objParams.getString("b140PolicyId"));
		
		return this.getGiacDisbursementUtilitiesDAO().applyBancAssurance(params);
	}
	
	@Override
	public List<Map<String, Object>> recomputeCommRateGiacs408(HttpServletRequest request) throws SQLException, JSONException{
		JSONObject objParams = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setReCommRt", JSONUtil.prepareMapListFromJSON(new JSONArray(objParams.getString("setReCommRt"))));
		params.put("lineCd", objParams.getString("lineCd"));
		params.put("sublineCd", objParams.getString("sublineCd"));
		params.put("b140IssCd", objParams.getString("b140IssCd"));
		params.put("b140PremSeqNo", objParams.getString("b140PremSeqNo"));
		params.put("b140PolicyId", objParams.getString("b140PolicyId"));
		params.put("wTaxRate", objParams.getString("wTaxRate"));
		
		return getGiacDisbursementUtilitiesDAO().recomputeCommRateGiacs408(params);
	}

	@Override
	public JSONObject recomputeCommRt2(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getRecomputeCommRateList");
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("commRecId", request.getParameter("commRecId"));
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		
		Map<String, Object> recomputeCommRateTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject recomputeCommRateList = new JSONObject(recomputeCommRateTableGrid);
		return recomputeCommRateList;
	}

	@Override
	public JSONObject getAdjustedPremAmt(HttpServletRequest request,
			GIISUser user) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("sharePercentage", new BigDecimal(request.getParameter("sharePercentage")));
		params.put("policyId", request.getParameter("policyId"));
		params.put("premAmt", new BigDecimal(request.getParameter("premAmt")));
		return getGiacDisbursementUtilitiesDAO().getAdjustedPremAmt(params);
	}
	
	@SuppressWarnings("unchecked")
	public JSONArray getGiacs408InvoiceCommList(HttpServletRequest request,	GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		params.put("posted", request.getParameter("posted"));
		params.put("nbtShowAll", request.getParameter("nbtShowAll"));
		System.out.println("==getGiacs408InvoiceCommList PARAMS: " + params.toString());
		
		List<Map<String, Object>> list = (List<Map<String, Object>>) StringFormatter.escapeHTMLInList(giacDisbursementUtilitiesDAO.getGIACS408InvoiceCommList(params));
		System.out.println("list total: "+list.size());
		JSONArray arr = new JSONArray(list);
		System.out.println("array length: "+ arr.length());
		return arr;
	}
}
