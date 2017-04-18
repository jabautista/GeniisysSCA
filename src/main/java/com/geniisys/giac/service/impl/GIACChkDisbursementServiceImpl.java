/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.giac.service.impl
	File Name: GIACChkDisbursementServiceImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Jun 19, 2012
	Description: 
*/


package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACChkDisbursementDAO;
import com.geniisys.giac.entity.GIACChkDisbursement;
import com.geniisys.giac.service.GIACChkDisbursementService;
import com.seer.framework.util.StringFormatter;

public class GIACChkDisbursementServiceImpl implements GIACChkDisbursementService{
	
	private GIACChkDisbursementDAO giacChkDisbursementDAO;
	
	@Override
	public GIACChkDisbursement getGiacs016GiacDisb(Integer gaccTranId)
			throws SQLException {
		return getGiacChkDisbursementDAO().getGiacs016ChkDisbursement(gaccTranId);
	}

	/**
	 * @return the giacChkDisbursementDAO
	 */
	public GIACChkDisbursementDAO getGiacChkDisbursementDAO() {
		return giacChkDisbursementDAO;
	}

	/**
	 * @param giacChkDisbursementDAO the giacChkDisbursementDAO to set
	 */
	public void setGiacChkDisbursementDAO(
			GIACChkDisbursementDAO giacChkDisbursementDAO) {
		this.giacChkDisbursementDAO = giacChkDisbursementDAO;
	}

	@Override
	public GIACChkDisbursement getGiacs002ChkDisbursement(Map<String, Object> params) throws SQLException {
		return this.getGiacChkDisbursementDAO().getGiacs002ChkDisbursement(params);
	}

	@Override
	public String saveCheckDisbursement(HttpServletRequest request, String userId) throws SQLException, JSONException, Exception {
		JSONObject objParameters = new JSONObject(request.getParameter("parameters"));
		
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), userId, GIACChkDisbursement.class));
		allParams.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")), userId, GIACChkDisbursement.class));
		
		allParams.put("gibrGfunFundCd", request.getParameter("fundCd"));
		allParams.put("gibrBranchCd", request.getParameter("branchCd"));
		allParams.put("moduleId", request.getParameter("moduleId"));
		allParams.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
		allParams.put("dvTag", request.getParameter("dvTag"));
		allParams.put("checkDVPrint", request.getParameter("checkDVPrint"));//added by steven 09.18.2014
		allParams.put("gidvPrintTag", request.getParameter("gidvPrintTag"));//added by robert 01.26.2015
		System.out.println("allPArams in service: "+allParams);
		return this.getGiacChkDisbursementDAO().saveCheckDisbursement(allParams);
	}

	@Override
	public Map<String, Object> spoilCheck(Map<String, Object> params) throws SQLException, Exception {
		return this.getGiacChkDisbursementDAO().spoilCheck(params);
	}

	@Override
	public Integer getCheckCount(Integer gaccTranId) throws SQLException {
		return this.getGiacChkDisbursementDAO().getCheckCount(gaccTranId);
	}

	@Override
	public String validateCheckNo(Map<String, Object> params) throws SQLException, Exception {
		System.out.println("service!");
		return this.getGiacChkDisbursementDAO().validateCheckNo(params);		
	}

	@Override
	public String validateBankCd(Map<String, Object> params) throws SQLException, Exception {
		return this.getGiacChkDisbursementDAO().validateBankCd(params);
	}

	@Override
	public List<String> getDBItemNoList(Map<String, Object> params) throws SQLException {
		return this.getGiacChkDisbursementDAO().getDBItemNoList(params);
	}

	@Override
	public Map<String, Object> giacs052NewFormInstance(
			HttpServletRequest request) throws SQLException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("tranId", Integer.parseInt(request.getParameter("tranId")));
		
		this.getGiacChkDisbursementDAO().giacs052NewFormInstance(param);
		
		return StringFormatter.escapeHTMLInMap(param);
	}

	@Override
	public Map<String, Object> getGiacs052DefaultCheck(
			HttpServletRequest request) throws SQLException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("printPrsd", request.getParameter("printPrsd"));
		param.put("disbMode", request.getParameter("disbMode"));
		param.put("bankCd", request.getParameter("bankCd"));
		param.put("bankSname", request.getParameter("bankSname"));
		param.put("bankAcctCd", request.getParameter("bankAcctCd"));
		param.put("printCheck", request.getParameter("printCheck"));
		param.put("branchCd", request.getParameter("branchCd"));
		param.put("fundCd", request.getParameter("fundCd"));
		
		this.getGiacChkDisbursementDAO().getGiacs052DefaultCheck(param);
		
		return param;
	}

	@Override
	public Map<String, Object> giacs052ProcessAfterPrinting(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("tranId", Integer.parseInt(request.getParameter("tranId")));
		param.put("itemNo", (request.getParameter("itemNo")  != null && !request.getParameter("itemNo").isEmpty() ? Integer.parseInt(request.getParameter("itemNo")) : null));
		param.put("fundCd", request.getParameter("fundCd"));
		param.put("branchCd", request.getParameter("branchCd"));
		param.put("disbMode", request.getParameter("disbMode"));
		param.put("bankCd", request.getParameter("bankCd"));
		param.put("bankAcctCd", request.getParameter("bankAcctCd"));
		param.put("userId", userId);
		param.put("checkDvPrint", request.getParameter("checkDvPrint"));
		param.put("printDv", request.getParameter("printDv"));
		param.put("printCheck", request.getParameter("printCheck"));
		param.put("checkDate", request.getParameter("checkDate"));
		param.put("dvFlag", request.getParameter("dvFlag"));
		param.put("checkCnt", request.getParameter("checkCnt"));
		param.put("prtDv", request.getParameter("prtDv"));
		param.put("prtChk", request.getParameter("prtChk"));
		param.put("chkPrefix", request.getParameter("chkPrefix"));
		param.put("checkNo", request.getParameter("checkNo"));
		param.put("documentCd", request.getParameter("documentCd"));
		this.getGiacChkDisbursementDAO().giacs052ProcessAfterPrinting(param);
		
		return param;
	}

	@Override
	public void giacs052UpdateGiac(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tranId", Integer.parseInt(request.getParameter("tranId")));
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		
		this.getGiacChkDisbursementDAO().giacs052UpdateGiac(params);
	}

	@Override
	public void giacs052SpoilCheck(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tranId", Integer.parseInt(request.getParameter("tranId")));
		params.put("itemNo", (request.getParameter("itemNo")  != null && !request.getParameter("itemNo").isEmpty() ? Integer.parseInt(request.getParameter("itemNo")) : null));
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("userId", userId);
		params.put("checkDvPrint", request.getParameter("checkDvPrint"));
		params.put("checkCnt", request.getParameter("checkCnt"));
		
		this.getGiacChkDisbursementDAO().giacs052SpoilCheck(params);	
	}

	@Override
	public void giacs052RestoreCheck(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tranId", Integer.parseInt(request.getParameter("tranId")));
		params.put("itemNo", (request.getParameter("itemNo")  != null && !request.getParameter("itemNo").isEmpty() ? Integer.parseInt(request.getParameter("itemNo")) : null));
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("bankCd", request.getParameter("bankCd"));
		params.put("bankAcctCd", request.getParameter("bankAcctCd"));
		params.put("userId", userId);
		params.put("checkDvPrint", request.getParameter("checkDvPrint"));
		params.put("checkDate", request.getParameter("checkDate"));
		params.put("checkCnt", request.getParameter("checkCnt"));
		params.put("chkPrefix", request.getParameter("chkPrefix"));
		params.put("checkNo", request.getParameter("checkNo"));
		
		this.getGiacChkDisbursementDAO().giacs052RestoreCheck(params);
	}
	
	@Override
	public void giacs052CheckDupOr(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("bankCd", request.getParameter("bankCd"));
		params.put("bankAcctCd", request.getParameter("bankAcctCd"));
		params.put("chkPrefix", request.getParameter("chkPrefix"));
		params.put("checkNo", request.getParameter("checkNo"));
		
		this.getGiacChkDisbursementDAO().giacs052CheckDupOr(params);
	}

	@Override
	public Map<String, Object> setCmDmPrintBtn(HttpServletRequest request,
			String userId) throws SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tranId", (request.getParameter("tranId")  != null && !request.getParameter("tranId").isEmpty() ? Integer.parseInt(request.getParameter("tranId")) : null));
		return this.getGiacChkDisbursementDAO().setCmDmPrintBtn(params);
	}
	/*added by MarkS 5.24.2016 SR-5484 */
	@Override
	public List<Map<String, Object>> getCmDmTranIdMemoStat(HttpServletRequest request) throws SQLException, Exception 
	{
		return this.getGiacChkDisbursementDAO().getCmDmTranIdMemoStat((request.getParameter("tranId")  != null && !request.getParameter("tranId").isEmpty() ? Integer.parseInt(request.getParameter("tranId")) : null));
	}
	/*END  SR-5484 */
	@Override
	public Map<String, Object> generateCheck(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("bankSName", request.getParameter("bankSName"));
		params.put("bankCd", request.getParameter("bankCd"));
		params.put("bankAcctCd", request.getParameter("bankAcctCd"));
		return this.getGiacChkDisbursementDAO().generateCheck(params);
	}

	@Override
	public JSONObject getCheckBatchList(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getCheckBatchList");
		params.put("bankCd", request.getParameter("bankCd"));
		params.put("bankAcctCd", request.getParameter("bankAcctCd"));
		params.put("checking", request.getParameter("checking"));
		params.put("checkTag", request.getParameter("checkTag"));
		params.put("tranIdGroup", request.getParameter("tranIdGroup"));	
		params.put("branchCd", request.getParameter("branchCd"));	
		String genCheckNo = request.getParameter("genCheckNo");
		
		if (genCheckNo != null && genCheckNo.equals("Y")){
			params.put("inTranIdItemNo", request.getParameter("inTranIdItemNo"));
		}
		
		Map<String, Object> checkBatchTG = TableGridUtil.getTableGrid(request, params);	
		return new JSONObject(checkBatchTG);
	}

	@Override
	public void validateSpoilCheck(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "validateSpoilCheck");
		params.put("gaccTranId", request.getParameter("gaccTranId"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("checkPrefSuf", request.getParameter("checkPrefSuf"));
		params.put("checkNo", request.getParameter("checkNo"));
		this.getGiacChkDisbursementDAO().validateSpoilCheck(params);
	}

	@SuppressWarnings("rawtypes")
	@Override
	public void spoilCheckGIACS054(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		
		Map<String, Object> row = JSONUtil.prepareMapFromJSON(new JSONObject(request.getParameter("row")));
		Iterator iterator = row.entrySet().iterator();
		while (iterator.hasNext()) {
			Map.Entry mapEntry = (Map.Entry) iterator.next();
			if(mapEntry.getValue() == null || mapEntry.getValue().toString().equals("") || mapEntry.getValue().toString().equals("null")){
				row.put(mapEntry.getKey().toString(), "");
			}
		}
		
		params.put("ACTION", "spoilCheckGIACS054");
		params.put("row", row);
		params.put("userId", userId);
		params.put("checkDvPrint", request.getParameter("checkDvPrint"));
		this.getGiacChkDisbursementDAO().spoilCheckGIACS054(params);
	}

	@Override
	public Integer getCheckSeqNo(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getCheckSeqNo");
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("bankCd", request.getParameter("bankCd"));
		params.put("bankAcctCd", request.getParameter("bankAcctCd"));
		params.put("chkPrefix", request.getParameter("chkPrefix"));
		return this.getGiacChkDisbursementDAO().getCheckSeqNo(params);
	}

	@Override
	public void processPrintedChecks(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		JSONObject paramsObj = new JSONObject(request.getParameter("parameters"));
		params.put("rows", JSONUtil.prepareMapListFromJSON(new JSONArray(paramsObj.getString("rows"))));
		params.put("userId", userId);
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("bankCd", request.getParameter("bankCd"));
		params.put("bankAcctCd", request.getParameter("bankAcctCd"));
		params.put("checkPref", request.getParameter("checkPref"));
		params.put("checkDvPrint", request.getParameter("checkDvPrint"));
		this.getGiacChkDisbursementDAO().processPrintedChecks(params);
	}

	@Override
	public void updatePrintedChecks(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("rows", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("parameters"))));
		params.put("lastCheckNo", request.getParameter("lastCheckNo"));
		params.put("checkPref", request.getParameter("checkPref"));
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("bankCd", request.getParameter("bankCd"));
		params.put("bankAcctCd", request.getParameter("bankAcctCd"));
		params.put("userId", userId);
		params.put("checkDvPrint", request.getParameter("checkDvPrint"));
		this.getGiacChkDisbursementDAO().updatePrintedChecks(params);
	}

	@Override
	public void validateCheckSeqNo(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("bankCd", request.getParameter("bankCd"));
		params.put("bankAcctCd", request.getParameter("bankAcctCd"));
		params.put("checkPref", request.getParameter("chkPrefix"));
		params.put("checkSeqNo", request.getParameter("checkSeqNo"));
		params.put("branchCd", request.getParameter("branchCd"));
		this.getGiacChkDisbursementDAO().validateCheckSeqNo(params);
	}

	@Override
	public String checkDVPrintColumn(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("fundCd", request.getParameter("fundCd"));
		System.out.println("Parameters: "+params);
		return this.getGiacChkDisbursementDAO().checkDVPrintColumn(params);
	}

	@SuppressWarnings("unchecked")
	public JSONArray getCheckBatchListByParam(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("bankCd", request.getParameter("bankCd"));
		params.put("bankAcctCd", request.getParameter("bankAcctCd"));
		params.put("checking", request.getParameter("checking"));
		params.put("checkTag", request.getParameter("checkTag"));
		params.put("tranIdGroup", request.getParameter("tranIdGroup"));
		params.put("branchCd", request.getParameter("branchCd"));
		
		JSONObject filterByJson = new JSONObject(request.getParameter("filterBy"));
		Iterator<String> iter = filterByJson.keys();
		
		while(iter.hasNext()){
			String key = iter.next().toString();
			params.put(key, filterByJson.get(key));
		}

		params.put("inTranIdItemNo", request.getParameter("inTranIdItemNo"));
		
		System.out.println("PARAMS: == " + params.toString());
		List<Map<String, Object>> checkBatchTG = (List<Map<String, Object>>) StringFormatter.escapeHTMLInList(this.getGiacChkDisbursementDAO().getCheckBatchListByParam(params));		
		
		return new JSONArray(checkBatchTG);
	}
	
	public JSONObject generateCheckNo(HttpServletRequest request) throws SQLException, JSONException{
		JSONArray rows = this.getCheckBatchListByParam(request);
		
		Integer checkSeqNo = Integer.parseInt(request.getParameter("checkSeqNo")); 
		String checkPrefSuf = request.getParameter("checkPrefSuf");
		String checkDate = request.getParameter("checkDate");
		Integer maxCheckNo = checkSeqNo;
		System.out.println("maxCheckNo: " +maxCheckNo);
		for(int i=0; i<rows.length(); i++){
			if (rows.getJSONObject(i).get("checkNo").equals(null)){
				rows.getJSONObject(i).put("checkDate", checkDate);
				rows.getJSONObject(i).put("checkPrefSuf", checkPrefSuf);
				rows.getJSONObject(i).put("checkNo", checkSeqNo);
				rows.getJSONObject(i).put("checkNumber", checkPrefSuf + "-" + checkSeqNo);
				maxCheckNo = checkSeqNo;
				checkSeqNo = checkSeqNo + 1;
			}
		}
		System.out.println("===== "+rows.length());
		
		Map<String, Object> res = new HashMap<String, Object>();
		res.put("rows", rows);
		res.put("maxCheckNo", maxCheckNo);
		
		return new JSONObject(res);
	}
}
