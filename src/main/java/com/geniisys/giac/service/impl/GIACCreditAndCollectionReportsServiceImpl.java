package com.geniisys.giac.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.giac.dao.GIACCreditAndCollectionReportsDAO;
import com.geniisys.giac.entity.GIACSoaRepExt;
import com.geniisys.giac.entity.GIACSoaRepExtParam;
import com.geniisys.giac.service.GIACCreditAndCollectionReportsService;

public class GIACCreditAndCollectionReportsServiceImpl implements GIACCreditAndCollectionReportsService{
	
	private GIACCreditAndCollectionReportsDAO giacCreditAndCollectionReportsDAO;

	public GIACCreditAndCollectionReportsDAO getGiacCreditAndCollectionReportsDAO() {
		return giacCreditAndCollectionReportsDAO;
	}

	public void setGiacCreditAndCollectionReportsDAO(
			GIACCreditAndCollectionReportsDAO giacCreditAndCollectionReportsDAO) {
		this.giacCreditAndCollectionReportsDAO = giacCreditAndCollectionReportsDAO;
	}
	
	
	@Override
	public GIACSoaRepExtParam getDefualtSOAParams(String userId) throws SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		
		return this.getGiacCreditAndCollectionReportsDAO().getDefualtSOAParams(params);
	}

	@Override
	public GIACSoaRepExtParam getExtractDate(Map<String, Object> params) throws SQLException, Exception {
		return this.getGiacCreditAndCollectionReportsDAO().getExtractDate(params);
	}

	@Override
	public Map<String, Object> getSOARepDtls(HttpServletRequest request, String userId) throws SQLException, Exception {
		GIACSoaRepExtParam soaParams = createSoaParams(request);
		Map<String, Object> params = new HashMap<String, Object>();
		params.putAll(FormInputUtil.formMapFromEntity(soaParams));
		params.put("appUser", userId);
		params.put("userId", userId);
		params.put("rowCounter", null);
		params.put("message", "");
		
		return this.getGiacCreditAndCollectionReportsDAO().getSOARepDtls(params);
	}
	
	private GIACSoaRepExtParam createSoaParams(HttpServletRequest request) throws ParseException{
		GIACSoaRepExtParam params = new GIACSoaRepExtParam();
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		
		params.setIncSpecialPol(request.getParameter("specialPol") != null ? request.getParameter("specialPol") : "");
		params.setBranchCd(request.getParameter("branchCd") != null ? request.getParameter("branchCd") : "");
		params.setIntmNo((request.getParameter("intmNo") != null && !request.getParameter("intmNo").equals(""))? Integer.parseInt(request.getParameter("intmNo")) : null);
		params.setIntmType(request.getParameter("intmType") != null ? request.getParameter("intmType") : "");
		params.setAssdNo((request.getParameter("assdNo") != null && !request.getParameter("assdNo").equals(""))? Integer.parseInt(request.getParameter("assdNo")) : null);
		params.setReportDate(request.getParameter("reportDate") != null ? request.getParameter("reportDate") : "");
		params.setBookTag(request.getParameter("bookTag") != null ? request.getParameter("bookTag") : "");
		params.setBookDateFr((request.getParameter("bookDateFr") != null && !request.getParameter("bookDateFr").equals(""))? sdf.parse(request.getParameter("bookDateFr")) : null);
		params.setBookDateTo((request.getParameter("bookDateTo") != null && !request.getParameter("bookDateTo").equals("")) ? sdf.parse(request.getParameter("bookDateTo")) : null);
		
		params.setIncepTag(request.getParameter("incepTag") != null ? request.getParameter("incepTag") : "");
		params.setIncepDateFr((request.getParameter("incepDateFr") != null && !request.getParameter("incepDateFr").equals("")) ? sdf.parse(request.getParameter("incepDateFr")) : null);
		params.setIncepDateTo((request.getParameter("incepDateTo") != null && !request.getParameter("incepDateTo").equals("")) ? sdf.parse(request.getParameter("incepDateTo")) : null);
		
		params.setIssueTag(request.getParameter("issueTag") != null ? request.getParameter("issueTag") : "");
		params.setIssueDateFr((request.getParameter("issueDateFr") != null && !request.getParameter("issueDateFr").equals("")) ? sdf.parse(request.getParameter("issueDateFr")) : null);
		params.setIssueDateTo((request.getParameter("issueDateTo") != null && !request.getParameter("issueDateTo").equals("")) ? sdf.parse(request.getParameter("issueDateTo")) : null);
		
		params.setAsOfDate((request.getParameter("dateAsOf") != null && !request.getParameter("dateAsOf").equals("")) ? sdf.parse(request.getParameter("dateAsOf")) : null);
		params.setCutOffDate((request.getParameter("cutOffDate") != null && !request.getParameter("cutOffDate").equals("")) ? sdf.parse(request.getParameter("cutOffDate")) : null);
		
		params.setIncludePDC((request.getParameter("includePDC") != null && !request.getParameter("includePDC").equals("")) ? request.getParameter("includePDC") : "");
		params.setExtractAgingDays((request.getParameter("extractDays") != null && !request.getParameter("extractDays").equals("")) ? Integer.parseInt(request.getParameter("extractDays")) : null);
		params.setBranchParam(request.getParameter("branchParam") != null ? request.getParameter("branchParam") : "");
		params.setOutstandingBalance((request.getParameter("outstandingBal") != null && !request.getParameter("outstandingBal").equals("")) ? new BigDecimal(request.getParameter("outstandingBal")) : null);
		params.setPaytDate(request.getParameter("paytDate") != null ? request.getParameter("paytDate") : "");
		return params;		
	}

	@Override
	public String breakdownTaxPayments(HttpServletRequest request, String userId) throws SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("cutOffDate", request.getParameter("cutOffDate") == null ? null : new SimpleDateFormat("MM-dd-yyyy").parse(request.getParameter("cutOffDate")));
		params.put("paytDate", request.getParameter("paytDate"));
		params.put("message", "");
		
		return this.getGiacCreditAndCollectionReportsDAO().breakdownTaxPayments(params);
	}

	@Override
	public GIACSoaRepExtParam setDefaultDates(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("reportDate", request.getParameter("reportDate").equals(null) ? "" : request.getParameter("reportDate"));
		
		return this.getGiacCreditAndCollectionReportsDAO().setDefaultDates(params);
	}

	@Override
	public String getSOARemarks() throws SQLException {
		return this.getGiacCreditAndCollectionReportsDAO().getSOARemarks();
	}

	@Override
	//public String saveCollectionLetterParams(HttpServletRequest request, String userId) throws SQLException, JSONException, Exception {
	public List<GIACSoaRepExt> saveCollectionLetterParams(HttpServletRequest request, String userId) throws SQLException, JSONException, Exception {
		JSONObject objParameters = new JSONObject(request.getParameter("parameters"));
		
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), userId, GIACSoaRepExt.class));
		
		List<GIACSoaRepExt> lettersToPrintList = this.getGiacCreditAndCollectionReportsDAO().saveCollectionLetterParams(allParams);
		return lettersToPrintList;
		
		//return this.getGiacCreditAndCollectionReportsDAO().saveCollectionLetterParams(allParams);		
	}

	@Override
	public List<GIACSoaRepExt> selectAllRecords(Map<String, Object> params) throws SQLException {
		return this.getGiacCreditAndCollectionReportsDAO().selectAllRecords(params);
	}

	@Override
	public String processIntmOrAssd(Map<String, Object> params) throws SQLException {
		return this.getGiacCreditAndCollectionReportsDAO().processIntmOrAssd(params);
	}

	@Override
	public List<GIACSoaRepExt> fetchParameters(HttpServletRequest request, String userId) throws SQLException, JSONException {
		JSONObject objParameters = new JSONObject(request.getParameter("parameters"));
		
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), userId, GIACSoaRepExt.class));
		
		List<GIACSoaRepExt> lettersToReprintList = this.getGiacCreditAndCollectionReportsDAO().fetchParameters(allParams);
		return lettersToReprintList;	}

	@Override
	public String checkUserDate(String userId) throws SQLException {
		return this.getGiacCreditAndCollectionReportsDAO().checkUserDate(userId);
	}

	//added by kenneth L. for aging of collections 07.02.2013
	@Override
	public String extractAgingOfCollections(String userId) throws SQLException {
		return this.getGiacCreditAndCollectionReportsDAO().extractAgingOfCollections(userId);
	}

	//added by kenneth L. for aging of collections 07.02.2013
	@Override
	public String inserToAgingExt(HttpServletRequest request, GIISUser USER)
			throws SQLException, ParseException {
		String message = "";
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", USER.getUserId());
		param.put("effDate", request.getParameter("effDate"));
		param.put("dueDate", request.getParameter("dueDate"));
		param.put("branchCd", request.getParameter("branchCd"));
		param.put("fromDate", df.parse(request.getParameter("fromDate")));
		param.put("toDate", df.parse(request.getParameter("toDate")));
		message = this.getGiacCreditAndCollectionReportsDAO().inserToAgingExt(param);
		System.out.println(message);
		return message;
	}

	@Override
	public String giacs329ValidateDateParams(HttpServletRequest request,
			GIISUser USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("userId", USER.getUserId());
		return giacCreditAndCollectionReportsDAO.giacs329ValidateDateParams(params);
	}

	@Override
	public Map<String, Object> extractGIACS329(HttpServletRequest request,
			GIISUser uSER) throws SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("intmType", request.getParameter("intmType")); //marco - 08.05.2014
		params.put("intmNo", request.getParameter("intmNo"));	  //
		params.put("userId", uSER.getUserId());
		params.put("exists", null);	
		return getGiacCreditAndCollectionReportsDAO().extractGIACS329(params);
	}

	@Override
	public void checkExistingReport(String reportId) throws SQLException, Exception {
		this.getGiacCreditAndCollectionReportsDAO().checkExistingReport(reportId);
	}

	@Override
	//public List<GIACSoaRepExt> processIntmOrAssd2(Map<String, Object> params) throws SQLException, Exception {
	public String processIntmOrAssd2(Map<String, Object> params) throws SQLException, Exception {
		return this.getGiacCreditAndCollectionReportsDAO().processIntmOrAssd2(params);
	}

	@Override
	public String giacs480ValidateDateParams(HttpServletRequest request,
			GIISUser USER) throws SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("userId", USER.getUserId());
		return giacCreditAndCollectionReportsDAO.giacs480ValidateDateParams(params);
	}

	@Override
	public Map<String, Object> extractGIACS480(HttpServletRequest request,
			GIISUser uSER) throws SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("companyCd", request.getParameter("companyCd"));
		params.put("employeeCd", request.getParameter("employeeCd"));
		params.put("userId", uSER.getUserId());
		params.put("exists", null);	
		return getGiacCreditAndCollectionReportsDAO().extractGIACS480(params);
	}

	@Override
	public String whenNewFormInstanceGIACS329(GIISUser USER)
			throws SQLException, Exception {
		JSONObject result = new JSONObject(this.getGiacCreditAndCollectionReportsDAO().whenNewFormInstanceGIACS329(USER));
		return result.toString();
	}

	@Override
	public Map<String, Object> getLastExtractParam(String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		return getGiacCreditAndCollectionReportsDAO().getLastExtractParam(params);
	}

	@Override
	public String whenNewFormInstanceGIACS480(GIISUser USER)
			throws SQLException, Exception {
		JSONObject result = new JSONObject(this.getGiacCreditAndCollectionReportsDAO().whenNewFormInstanceGIACS480(USER));
		return result.toString();
	}
	
	public String checkUserChildRecords(HttpServletRequest request, GIISUser USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("pdcExt", request.getParameter("pdcExt"));
		params.put("userId", USER.getUserId());
		return giacCreditAndCollectionReportsDAO.checkUserChildRecords(params);
	}
	
	@SuppressWarnings("unchecked")
	public String prepareFilterIntmAssd(HttpServletRequest request) throws SQLException, JSONException{
		JSONObject filterByJson = new JSONObject(request.getParameter("objFilter"));
		Iterator<String> iter = filterByJson.keys();
		String cond = "";
		
		while(iter.hasNext()){
			String key = iter.next().toString();
			if (key.equals("assdNo")){
				cond = " AND assd_no = " + filterByJson.get(key) + " ";
			}else if (key.equals("assdName")){
				cond = " AND UPPER(assd_name) LIKE UPPER('" + filterByJson.get(key) + "') ";
			}else if (key.equals("intmNo")){
				cond = " AND intm_no = " + filterByJson.get(key) + " ";
			}else if (key.equals("intmName")){
				cond = " AND UPPER(intm_name) LIKE UPPER('" + filterByJson.get(key) + "') ";
			}else if (key.equals("balanceAmtDue")){
				cond = " AND balance_amt_due = " + filterByJson.get(key) + " ";
			}			
		}
		
		return cond;
	}
	
	public Integer addToCollection(Map<String, Object> params) throws SQLException{
		Integer index = null;
		Integer strLen = 0;
		String longParam = params.get("longParam").toString();
		Integer longParamLen = longParam.length();
		
		Map<String, Object> par = new HashMap<String, Object>();
		
		while(strLen < longParamLen){
			String str = "";
			
			if (strLen == 0){
				par.put("isNewItem", "Y");
			}else{
				par.put("isNewItem", "N");
			}
			
			if (longParamLen <= 4000){
				strLen = longParamLen;
				str = longParam;
			}else{
				Integer charLeft = longParamLen - strLen;
				str = (charLeft < 4000) ? longParam.substring(strLen, longParamLen) : longParam.substring(strLen, strLen + 3999);
				strLen += 4000;				
			}
			
			par.put("index", index);
			par.put("str", str);
			System.out.println(strLen + ": " + str);
			index = this.getGiacCreditAndCollectionReportsDAO().addToCollection(par);
			System.out.println("index: " + index);
		}
		
		return index;
	}
	
	public String getCollElement(Integer index) throws SQLException{
		return this.giacCreditAndCollectionReportsDAO.getCollElement(index);
	}
	
	public void deleteCollElement(Integer index) throws SQLException{
		this.giacCreditAndCollectionReportsDAO.deleteCollElement(index);
	}
}
