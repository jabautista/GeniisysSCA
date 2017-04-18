package com.geniisys.giac.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACCommissionVoucherDAO;
import com.geniisys.giac.service.GIACCommissionVoucherService;
import com.seer.framework.util.StringFormatter;

public class GIACCommissionVoucherServiceImpl implements GIACCommissionVoucherService{

private GIACCommissionVoucherDAO giacCommissionVoucherDAO;
	
	@SuppressWarnings("unused")
	private GIACCommissionVoucherDAO giacCommissionVoucherDAO(){
		return giacCommissionVoucherDAO;
	}
	
	public void setGiacCommissionVoucherDAO (GIACCommissionVoucherDAO giacCommissionVoucherDAO) {
		this.giacCommissionVoucherDAO = giacCommissionVoucherDAO;
	}

	@Override
	public JSONObject populateCommVoucherTableGrid(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIACS155CommVoucherTableGrid");
		params.put("userId", USER.getUserId());
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		
		Map<String, Object> TG = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonCommVoucher = new JSONObject(TG);
		return jsonCommVoucher;
	}

	@Override
	public JSONObject getGIACS155CommInvoiceDetails(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIACS155CommInvoiceDetails");
		params.put("userId", USER.getUserId());
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		params.put("policyId", request.getParameter("policyId"));
		
		Map<String, Object> map = giacCommissionVoucherDAO.getGIACS155CommInvoiceDetails(params);
		
		JSONObject jsonCommInvoice = new JSONObject();
		
		if(map != null)
			jsonCommInvoice = new JSONObject(StringFormatter.escapeHTMLInMap(map));
		else
			jsonCommInvoice = new JSONObject("{nullCheck: 'Y'}");
		
		return jsonCommInvoice;
	}

	@Override
	public JSONObject populateCommInvoiceTableGrid(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIACS155CommInvoiceTableGrid");
		params.put("userId", USER.getUserId());
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		
		Map<String, Object> TG = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonCommInvoiceTG = new JSONObject(TG);
		return jsonCommInvoiceTG;
	}

	@Override
	public JSONObject getGIACS155CommPayables(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIACS155CommPayables");
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		params.put("policyId", request.getParameter("policyId"));
		
		Map<String, Object> map = giacCommissionVoucherDAO.getGIACS155CommPayables(params);
		
		JSONObject jsonCommPayables = new JSONObject();
		
		if(map != null)
			jsonCommPayables = new JSONObject(StringFormatter.escapeHTMLInMap(map));
		else
			jsonCommPayables = new JSONObject("{nullCheck: 'Y'}");
		
		return jsonCommPayables;
	}

	@Override
	public JSONObject getGIACS155CommPayments(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIACS155CommPayments");
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		
		Map<String, Object> TG = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonCommPayments = new JSONObject(TG);
		return jsonCommPayments;
	}

	@Override
	public JSONObject updateGIACS155CommVoucherExt(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("rows", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("parameters"))));
		params.put("userId", USER.getUserId());
		params.put("intmNo", Integer.parseInt(request.getParameter("intmNo")));
		params.put("fundCd", request.getParameter("fundCd"));
		JSONObject json = new JSONObject(giacCommissionVoucherDAO.updateGIACS155CommVoucherExt(params));
		return json;
	}

	@Override
	public String getGIACS155GrpIssCd(String userId, String repId)
			throws SQLException {
		return giacCommissionVoucherDAO.getGIACS155GrpIssCd(userId, repId);
	}

	@Override
	public void GIACS155SaveCVNo(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("rows", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("parameters"))));
		params.put("userId", USER.getUserId());
		params.put("intmNo", Integer.parseInt(request.getParameter("intmNo")));
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("cvPref", request.getParameter("cvPref"));
		params.put("cvNo", Integer.parseInt(request.getParameter("cvNo")));
		params.put("cvDate", request.getParameter("cvDate"));
		giacCommissionVoucherDAO.GIACS155SaveCVNo(params);
	}

	@Override
	public void GIACS155RemoveIncludeTag(GIISUser USER) throws SQLException {
		giacCommissionVoucherDAO.GIACS155RemoveIncludeTag(USER.getUserId());
	}

	@Override
	public void populateBatchCV(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("cvPref", request.getParameter("cvPref"));
		params.put("cvNo", request.getParameter("cvNo"));
		giacCommissionVoucherDAO.populateBatchCV(params);
	}

	@Override
	public JSONObject getBatchCV(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getBatchCV");
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("cvPref", request.getParameter("cvPref"));
		params.put("cvNo", request.getParameter("cvNo"));
		
		if("Y".equals(request.getParameter("popTempTable"))){
			this.populateBatchCV(request);
		}
		
		if(!("1".equals(request.getParameter("refresh")))){
			this.clearTempTable();
		}
		
		Map<String, Object> batchCVTG = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(batchCVTG);
	}

	@Override
	public Map<String, Object> getCVSeqNo(HttpServletRequest request,
			String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("userId", userId);
		return giacCommissionVoucherDAO.getCVSeqNo(params);
	}

	@Override
	public JSONObject getCvDetails(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getCvDetails");
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("cvPref", request.getParameter("cvPref"));
		params.put("cvNo", request.getParameter("cvNo"));
		
		Map<String, Object> cvDetailsTG = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(cvDetailsTG);
	}

	@Override
	public void clearTempTable() throws SQLException {
		this.giacCommissionVoucherDAO.clearTempTable();
	}

	@Override
	public void saveGenerateFlag(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		JSONObject paramsObj = new JSONObject(request.getParameter("parameters"));
		params.put("setRows", JSONUtil.prepareMapListFromJSON(new JSONArray(paramsObj.getString("setRows"))));
		this.giacCommissionVoucherDAO.saveGenerateFlag(params);
	}

	@Override
	public void generateCVNo(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("cvPref", request.getParameter("cvPref"));
		params.put("cvNo", request.getParameter("cvNo"));
		this.giacCommissionVoucherDAO.generateCVNo(params);
	}

	@Override
	public List<Map<String, Object>> getBatchReports() throws SQLException {
		return this.giacCommissionVoucherDAO.getBatchReports();
	}

	@Override
	public void tagAll(HttpServletRequest request) throws SQLException,
			JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("actualComm", request.getParameter("actualComm"));
		params.put("commPayable", request.getParameter("commPayable"));
		params.put("commPaid", request.getParameter("commPaid"));
		params.put("netDue", request.getParameter("netDue"));
		this.giacCommissionVoucherDAO.tagAll(params);
	}

	@Override
	public void untagAll() throws SQLException {
		this.giacCommissionVoucherDAO.untagAll();
	}

	@Override
	public Map<String, Object> updateTags(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		JSONObject paramsObj = new JSONObject(request.getParameter("parameters"));
		params.put("setRows", JSONUtil.prepareMapListFromJSON(new JSONArray(paramsObj.getString("setRows"))));
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("userId", userId);
		return giacCommissionVoucherDAO.updateTags(params);
	}

	@Override
	public String checkPolicyStatus(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("cvPref", request.getParameter("cvPref"));
		params.put("cvNo", request.getParameter("cvNo"));
		return giacCommissionVoucherDAO.checkPolicyStatus(params);
	}
	
	// start AFP SR-18481 : shan 05.21.2015
	public JSONObject getCommDueList(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIACS251CommDueList");
		params.put("bankFileNo", request.getParameter("bankFileNo"));
		params.put("intmList", request.getParameter("intmList"));
		
		Map<String, Object> commDueTG = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(commDueTG);
	}
	
	public JSONObject getGIACS251Fund() throws SQLException, JSONException{
		JSONArray fundList = new JSONArray(this.giacCommissionVoucherDAO.getGIACS251FundList());
		JSONObject fundDetails = fundList.getJSONObject(fundList.length()-1);
		
		return fundDetails;
	}
	
	@SuppressWarnings("unchecked")
	public BigDecimal getCommDueTotal(HttpServletRequest request) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("bankFileNo", request.getParameter("bankFileNo"));
		
		JSONObject filterByJson = new JSONObject(request.getParameter("params"));
		Iterator<String> iter = filterByJson.keys();
		
		while(iter.hasNext()){
			String key = iter.next().toString();
			params.put(key, filterByJson.get(key));
		}

		
		System.out.println("PARAMS: == " + params.toString());
		return this.giacCommissionVoucherDAO.getCommDueTotal(params);
	}
	
	@SuppressWarnings("unchecked")
	public JSONArray getCommDueListByParam(HttpServletRequest request) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("bankFileNo", request.getParameter("bankFileNo"));
		
		JSONObject filterByJson = new JSONObject(request.getParameter("params"));
		Iterator<String> iter = filterByJson.keys();
		
		while(iter.hasNext()){
			String key = iter.next().toString();
			params.put(key, filterByJson.get(key));
		}

		
		System.out.println("PARAMS: == " + params.toString());
		List<Map<String, Object>> commDueTG = (List<Map<String, Object>>) StringFormatter.escapeHTMLInList(this.giacCommissionVoucherDAO.getCommDueListByParam(params));		
		
		return new JSONArray(commDueTG);
	}
	
	public JSONObject generateCVNoCommDue(HttpServletRequest request) throws SQLException, JSONException{
		/*JSONArray rows = new JSONArray(request.getParameter("commDueList"));
		Integer cvNo = Integer.parseInt(request.getParameter("cvNo")); 
		String cvPref = request.getParameter("cvPref");
		Integer maxCvNo = cvNo;
		System.out.println("maxCvNo: " +maxCvNo);
		
		for(int i=0; i<rows.length(); i++){
			if (rows.getJSONObject(i).get("cvNo").equals(null)){
				rows.getJSONObject(i).put("cvPref", cvPref);
				rows.getJSONObject(i).put("cvNo", cvNo);
				maxCvNo = cvNo;
				cvNo = cvNo + 1;
			}
		}
		System.out.println("===== "+rows.length());
		
		Map<String, Object> res = new HashMap<String, Object>();
		res.put("rows", rows);
		res.put("maxCvNo", maxCvNo);
		
		return new JSONObject(res);*/
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("bankFileNo", request.getParameter("bankFileNo"));
		params.put("cvPref", request.getParameter("cvPref"));
		params.put("cvNo", request.getParameter("cvNo"));
		params.put("setRows", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("commDueList"))));
		
		params = this.giacCommissionVoucherDAO.generateCVNoCommDue(params);
		
		JSONObject list = this.getCommDueList(request);
		JSONObject res = new JSONObject();
		res.put("list", list);
		res.put("maxCVNo", params.get("maxCVNo"));
		
		return res;
	}
	
	public void updateCommDueCVToNull(HttpServletRequest request) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("rows", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("commDueList"))));
		
		this.giacCommissionVoucherDAO.updateCommDueCVToNull(params);
	}
	
	@SuppressWarnings("unchecked")
	public JSONObject getCommDueDtlTotals(HttpServletRequest request) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("intmNo", request.getParameter("intmNo"));
		
		JSONObject filterByJson = new JSONObject(request.getParameter("filter"));
		Iterator<String> iter = filterByJson.keys();
		
		while(iter.hasNext()){
			String key = iter.next().toString();
			params.put(key, filterByJson.get(key));
		}

		
		System.out.println("PARAMS: == " + params.toString());
		
		return new JSONObject(this.giacCommissionVoucherDAO.getCommDueDtlTotals(params));
	}
	
	public Map<String, Object> updateCommDueTags(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("parameters"))));
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("userId", userId);
		params.put("toRevert", request.getParameter("toRevert"));
		return giacCommissionVoucherDAO.updateCommDueTags(params);
	}
	
	public Integer getNullCommDueCount(HttpServletRequest request) throws SQLException{
		String bankFileNo = request.getParameter("bankFileNo");
		return this.giacCommissionVoucherDAO.getNullCommDueCount(bankFileNo);
	}
	// end AFP SR-18481 : shan 05.21.2015

	// bonok :: 1.16.2017 :: RSIC SR 23713
	@Override
	public JSONObject getTotalForPrintedCV(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<>();
		
		params.put("userId", userId);
		params.put("cvPref", request.getParameter("cvPref"));
		params.put("cvNo", request.getParameter("cvNo"));
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		
		return new JSONObject(this.giacCommissionVoucherDAO.getTotalForPrintedCV(params));
	}
}
