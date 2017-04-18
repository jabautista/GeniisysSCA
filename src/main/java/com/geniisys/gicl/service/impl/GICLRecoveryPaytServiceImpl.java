package com.geniisys.gicl.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.service.GIACAccTransService;
import com.geniisys.gicl.dao.GICLRecoveryPaytDAO;
import com.geniisys.gicl.entity.GICLRecoveryPayt;
import com.geniisys.gicl.service.GICLRecoveryPaytService;
import com.geniisys.gipi.service.GIPIWCommInvoiceService;
import com.seer.framework.util.StringFormatter;

public class GICLRecoveryPaytServiceImpl implements GICLRecoveryPaytService{

	private GICLRecoveryPaytDAO giclRecoveryPaytDAO;
	
	public GICLRecoveryPaytDAO getGiclRecoveryPaytDAO() {
		return giclRecoveryPaytDAO;
	}

	public void setGiclRecoveryPaytDAO(GICLRecoveryPaytDAO giclRecoveryPaytDAO) {
		this.giclRecoveryPaytDAO = giclRecoveryPaytDAO;
	}

	@Override
	public void gicl055NewFormInstance(HttpServletRequest request, GIISUser USER, ApplicationContext appContext)
			throws SQLException, JSONException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		Integer recoveryAcctId = request.getParameter("recoveryAcctId").equals("") || request.getParameter("recoveryAcctId").equals("null") ? 
				null : Integer.parseInt(request.getParameter("recoveryAcctId"));
		params.put("recoveryAcctId", recoveryAcctId);
		params.put("claimId", request.getParameter("claimId").equals("") || request.getParameter("claimId").equals("null") ? 
				null : request.getParameter("claimId"));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", USER.getUserId()); //benjo 08.27.2015 UCPBGEN-SR-19654
		params.put("ACTION", "getRecoveryAcct");
		System.out.println("params: "+params);
		List<Map<String, Object>> accts = new ArrayList<Map<String,Object>>();
		
		accts = this.getGiclRecoveryPaytDAO().getRecoveryAccts(params);
		System.out.println("Rec Accts Retrieved - "+accts.size());
		request.setAttribute("recAccts", new JSONArray(accts));
		
		if(accts.size() > 0) {
			System.out.println("Retrieved recovery acct: "+accts.get(0));
			this.getRecoveryPaytListing(request, accts.get(0), USER.getUserId());
		} else {
			this.getRecoveryPaytListing(request, null, USER.getUserId());
		}
		
		GIPIWCommInvoiceService inv = (GIPIWCommInvoiceService) appContext.getBean("gipiWCommInvoiceService");
		request.setAttribute("vFundCd", inv.getAccountingParameter("FUND_CD"));
		request.setAttribute("vIssCd", inv.getAccountingParameter("BRANCH_CD"));
	}

	@Override
	public void getRecoveryPaytListing(HttpServletRequest request, Map<String, Object> recAcct, String userId)
			throws SQLException, JSONException { //edited lara 1-13-2014
		Map<String, Object> params = new HashMap<String, Object>();
		String recAcctId = request.getParameter("recoveryAcctId").equals("") || request.getParameter("recoveryAcctId").equals("null") ?
			null : request.getParameter("recoveryAcctId");
		String claimId = request.getParameter("claimId").equals("") || request.getParameter("claimId").equals("null") ?
			null : request.getParameter("claimId");
		String action = "".equals(request.getParameter("refreshAction")) ? "getRecoveryPaytTG" : request.getParameter("refreshAction");
		String grid = "";
		Map<String, Object> recPayts = new HashMap<String, Object>();
		Boolean createEnabled = request.getParameter("createEnabled").equals("true") ? true : false;
		
		if(createEnabled) {
			if(recAcct != null) {
				BigDecimal recAcctId2 = (BigDecimal) recAcct.get("recoveryAcctId");
				if(recAcctId == null) recAcctId = recAcctId2.toString();
			}
			if(recAcctId != null /*|| claimId != null*/) { //benjo 08.27.2015 removed claimId
				action = "getRecoveryPaytWithAcctTG";
			} 
			params.put("claimId", claimId);
			params.put("recoveryAcctId", recAcctId);
			params.put("moduleId", request.getParameter("moduleId"));
			//getRecoveryPaytWithAcctTG
			//params.put("ACTION", recAcctId == null ? "getRecoveryPaytTG" : "getRecoveryPaytWithAcctTG");
			params.put("ACTION", action);
			params.put("userId", userId);
			// params.put("page", request.getParameter("page"));
			// params.put("sortColumn", request.getParameter("sortColumn"));
			// params.put("ascDescFlg", request.getParameter("ascDescFlg"));
			// params.put("filter2", "".equals(request.getParameter("objFilter")) || "{}".equals(request.getParameter("objFilter")) ? null : request.getParameter("objFilter"));
			System.out.println("getRecoveryPaytListing: "+params+" - "+request.getParameter("page"));
			recPayts = TableGridUtil.getTableGrid(request, params);
			grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(recPayts)).toString();
		} else {
			grid = new JSONObject().toString();
		}
		request.setAttribute("recPaytGrid", grid);
		request.setAttribute("object", grid);
	}

	
	@Override
	public void getGiclDistributions(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		System.out.println("@GICLRecoveryPaytService getGiclDistributions");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGICLRecoveryDSTGListing");
		params.put("userId", userId);
		params.put("recoveryId", request.getParameter("recoveryId"));
		params.put("recoveryPaytId", request.getParameter("recoveryPaytId"));
		params.put("pageSize", (StringUtils.isEmpty(request.getParameter("pageSize")) ? 5 :Integer.parseInt(request.getParameter("pageSize"))));
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		
		request.setAttribute("recoveryDSTableGrid", grid);
		request.setAttribute("object", grid);
	}

	@Override
	public void getGiclRiDistributions(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		System.out.println("@GICLRecoveryPaytService getGiclRiDistributions");
		System.out.println(request.getParameter("recDistNo"));
		System.out.println(request.getParameter("grpSeqNo"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGICLRecoveryRidsTGListing");
		params.put("userId", userId);
		params.put("recoveryId", request.getParameter("recoveryId"));
		params.put("recoveryPaytId", request.getParameter("recoveryPaytId"));
		params.put("recDistNo", request.getParameter("recDistNo")); 	//added by
		params.put("grpSeqNo",request.getParameter("grpSeqNo")); 	    //Halley 01.04.2014
		params.put("pageSize", 5);
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		
		request.setAttribute("recoveryRidsTableGrid", grid);
		request.setAttribute("object", grid);
	}

	@Override
	public Map<String, Object> cancelRecoveryPayt(Map<String, Object> params)
			throws SQLException {
		return this.getGiclRecoveryPaytDAO().cancelRecoveryPayt(params);
	}

	@Override
	public void getRecAcctEntries(HttpServletRequest request, String userId, ApplicationContext appContext) throws SQLException, JSONException { //edited lara 1/16/2014
		GIACAccTransService accTransService = (GIACAccTransService) appContext.getBean("giacAccTransService");
		
		Integer acctTranId = (request.getParameter("acctTranId") == null || request.getParameter("acctTranId").equals("")) ? null : Integer.parseInt(request.getParameter("acctTranId"));
		System.out.println("Show Recovery Acctg Entries...");
		
		Map<String, Object> tranDtl =  accTransService.getRecAcctEntTranDtl(acctTranId);
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		System.out.println("tranDtl:   "+tranDtl);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiclRecAcctEntriesTableGrid");
		params.put("userId", userId);
		String recoveryAcctId = request.getParameter("recoveryAcctId");
		params.put("recoveryAcctId", recoveryAcctId);
		params.put("payorCd", request.getParameter("payorCd"));
		params.put("payorClassCd", request.getParameter("payorClassCd"));
		System.out.println("Show rec AE params: "+params);
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		
		request.setAttribute("recAcctEntriesTableGrid", grid);
		request.setAttribute("object", grid);
		if(!(request.getParameter("refresh").equals("1"))) {
			 if(tranDtl != null){
				request.setAttribute("tranNo", tranDtl.get(("tranNo")));
				request.setAttribute("tranDate", sdf.format((Date) tranDtl.get("tranDate")));
			 }
			request.setAttribute("recoveryAcctId", recoveryAcctId);
			request.setAttribute("payorCd", request.getParameter(request.getParameter("payorCd")));
			request.setAttribute("payorClassCd", request.getParameter("payorClassCd"));
			
			Map<String, Object> amtMap = new HashMap<String, Object>();
			amtMap.put("recoveryAcctId", recoveryAcctId);
			this.getGiclRecoveryPaytDAO().getRecAEAmountSum(amtMap);
			System.out.println("Test amounts - "+amtMap);
			request.setAttribute("amtMap", new JSONObject(amtMap));
		}
	}

	@Override
	public void saveGICLAcctEntries(JSONObject objParams, String userId)
			throws SQLException, JSONException {
		System.out.println("saveGICLAcctEntries[serviceImpl]: "+objParams);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRecAE", this.prepareRecAcctEntries(new JSONArray(objParams.getString("setRecAEObj")), userId));
		params.put("delRecAE",  this.prepareRecAcctEntries(new JSONArray(objParams.getString("delRecAEObj")), userId));
		this.getGiclRecoveryPaytDAO().saveGICLAcctEntries(params);
	}
	
	private List<Map<String, Object>> prepareRecAcctEntries(JSONArray setRows, String userId) throws JSONException {
		List<Map<String, Object>> aeList = new ArrayList<Map<String,Object>>();
		Map<String, Object> ae = null;
		JSONObject obj = null;
		
		for(int i=0, length=setRows.length(); i<length; i++) {
			ae = new HashMap<String, Object>();
			obj = setRows.getJSONObject(i);
			
			ae.put("recoveryAcctId", obj.isNull("recoveryAcctId") ? null : obj.getInt("recoveryAcctId"));
			ae.put("acctEntryId", obj.isNull("acctEntryId") ? null : obj.getInt("acctEntryId"));
			ae.put("glAcctId", obj.isNull("glAcctId") ? null : obj.getInt("glAcctId"));
			ae.put("glAcctCategory", obj.isNull("glAcctCategory") ? null : obj.getInt("glAcctCategory"));
			ae.put("glControlAcct", obj.isNull("glControlAcct") ? null : obj.getInt("glControlAcct"));
			ae.put("glSubAccount1", obj.isNull("glSubAccount1") ? null : obj.getInt("glSubAccount1"));
			ae.put("glSubAccount2", obj.isNull("glSubAccount2") ? null : obj.getInt("glSubAccount2"));
			ae.put("glSubAccount3", obj.isNull("glSubAccount3") ? null : obj.getInt("glSubAccount3"));
			ae.put("glSubAccount4", obj.isNull("glSubAccount4") ? null : obj.getInt("glSubAccount4"));
			ae.put("glSubAccount5", obj.isNull("glSubAccount5") ? null : obj.getInt("glSubAccount5"));
			ae.put("glSubAccount6", obj.isNull("glSubAccount6") ? null : obj.getInt("glSubAccount6"));
			ae.put("glSubAccount7", obj.isNull("glSubAccount7") ? null : obj.getInt("glSubAccount7"));
			ae.put("slCd", obj.isNull("slCd") ? null : obj.getString("slCd"));
			ae.put("debitAmt", obj.isNull("debitAmt") ? null : 
				new BigDecimal(obj.getString("debitAmt")));
			ae.put("creditAmt", obj.isNull("creditAmt") ? null : 
				new BigDecimal(obj.getString("creditAmt")));
			ae.put("generationType", obj.isNull("generationType") ? null : obj.getString("generationType"));
			ae.put("slTypeCd", obj.isNull("slTypeCd") ? null : obj.getString("slTypeCd"));
			ae.put("slSourceCd", obj.isNull("slSourceCd") ? null : obj.getString("slSourceCd"));
			ae.put("userId", userId);
			aeList.add(ae);
			ae = null;
		}
		
		return aeList;
	}

	@Override
	public Map<String, Object> generateRecAcctInfo(Map<String, Object> params)
			throws SQLException {
		return this.getGiclRecoveryPaytDAO().generateRecAcctInfo(params);
	}

	@Override
	public String generateRecovery(JSONObject obj, String userId) throws SQLException,
			JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRecPayts", JSONUtil.prepareObjectListFromJSON(new JSONArray(obj.getString("recPayts")), userId, GICLRecoveryPayt.class));
		Map<String, Object> recAcctMap = JSONUtil.prepareMapFromJSON(new JSONObject(obj.getString("recAcct")));
		recAcctMap.put("userId", userId);
		params.put("setRecAcct", recAcctMap);
		System.out.println("prepared recovery: "+params);
		
		String saveResult = this.getGiclRecoveryPaytDAO().generateRecovery(params);
		String returnMesg = saveResult;
		System.out.println("Save Result: "+saveResult);
		if(saveResult == null || saveResult.equals("")) {
			Map<String, Object> aegParam = new HashMap<String, Object>();
			aegParam.put("userId", recAcctMap.get("userId"));
			aegParam.put("recoveryAcctId", recAcctMap.get("recoveryAcctId"));
			System.out.println("aegParam: "+aegParam);
			returnMesg = this.getGiclRecoveryPaytDAO().aegParameterGICLS055(aegParam);
			System.out.println("after aegParam [service impl]: "+returnMesg);
		} 
		return returnMesg;
	}

	@Override
	public void setRecoveryAcct(JSONObject obj, String userId)
			throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		DateFormat sdf = new SimpleDateFormat("mm-dd-yyyy");
		
		params.put("recoveryAcctId", obj.isNull("recoveryAcctId") ? null : obj.getInt("recoveryAcctId"));
		params.put("issCd", obj.isNull("issCd") ? null : obj.getString("issCd"));
		params.put("recAcctYear", obj.isNull("recAcctYear") ? null : obj.getInt("recAcctYear"));
		params.put("recAcctSeqNo", obj.isNull("recAcctSeqNo") ? null : obj.getInt("recAcctSeqNo"));
		params.put("recoveryAmt", obj.isNull("recoveryAmt") ? null : new BigDecimal(obj.getString("recoveryAmt")));
		params.put("acctTranId", obj.isNull("acctTranId") ? null : obj.getInt("acctTranId"));
		params.put("tranDate", obj.isNull("tranDate") ? null : sdf.parse(obj.getString("tranDate")));
		params.put("recAcctFlag", obj.isNull("recAcctFlag") ? null : obj.getString("recAcctFlag"));
		params.put("userId", userId);
		
		this.getGiclRecoveryPaytDAO().setRecoveryAcct(params);
	}

	@Override
	public String checkRecoveryValidPayt(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", request.getParameter("claimId"));
		params.put("recoveryId", request.getParameter("recoveryId"));
		Debug.print("Test Before: "+params);
		params = this.giclRecoveryPaytDAO.checkRecoveryValidPayt(params);
		Debug.print("Test After: "+params);
		return new JSONObject(params).toString();
	}

	@Override
	public void getGiclRecoveryPaytGrid(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId")); 
		params.put("recoveryId", request.getParameter("recoveryId")); 
		params.put("pageSize", 3);
		params.put("ACTION", "getGiclRecoveryPaytGrid");
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("recoveryDistTG", grid);
		request.setAttribute("object", grid); 
	}

	@Override
	public void getGiclRecoveryRidsGrid(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("recoveryId", request.getParameter("recoveryId")); 
		params.put("recoveryPaytId", request.getParameter("recoveryPaytId")); 
		params.put("recDistNo", request.getParameter("recDistNo"));
		params.put("grpSeqNo", request.getParameter("grpSeqNo"));
		params.put("pageSize", 3);
		params.put("ACTION", "getGiclRecoveryRidsGrid");
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("recoveryRidsTG", grid);
		request.setAttribute("object", grid); 
	}
	
	/* benjo 08.27.2015 UCPBGEN-SR-19654 */
	@Override
	public Map<String, Object> getRecAEAmountSum(Map<String, Object> params)
			throws SQLException {
		return this.getGiclRecoveryPaytDAO().getRecAEAmountSum(params);
	}
}
