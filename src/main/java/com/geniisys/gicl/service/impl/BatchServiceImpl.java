/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.service.impl
	File Name: BatchServiceImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Dec 20, 2011
	Description: 
*/


package com.geniisys.gicl.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringEscapeUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.giac.entity.GIACBatchDV;
import com.geniisys.gicl.dao.BatchDAO;
import com.geniisys.gicl.entity.GICLBatchCsr;
import com.geniisys.gicl.service.BatchService;

public class BatchServiceImpl implements BatchService{
	private BatchDAO batchDAO;

	/**
	 * @param batchDAO the batchDAO to set
	 */
	public void setBatchDAO(BatchDAO batchDAO) {
		this.batchDAO = batchDAO;
	}

	/**
	 * @return the batchDAO
	 */
	public BatchDAO getBatchDAO() {
		return batchDAO;
	}

	@Override
	public String generateAe(HttpServletRequest request, GIISUser user)
			throws SQLException, JSONException {
		Map<String, Object>params = new HashMap<String, Object>();
		
		JSONObject objParameters = new JSONObject(request.getParameter("strParameters"));
		String issCd = objParameters.get("issCd").toString();
		
		System.out.println(objParameters);
		params.put("objParameters", objParameters);
		params.put("newBatchDV", prepareNewBatchDV((JSONObject) objParameters.get("objNewBatchDV")));
		params.put("objectSelectedAdviceRows", JSONUtil.prepareMapListFromJSON(new JSONArray(objParameters.getString("objectSelectedAdviceRows"))));
		params.put("issCd", issCd);
		//params.put("paramBranchCd", objParameters.get("paramBranchCd").toString());
		params.put("userId", user.getUserId());
		return getBatchDAO().generateAE(params);
	}

	@Override
	public String approveBatchCsr(JSONObject objParams, GIISUser USER)
			throws SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("batchCsr", JSONUtil.prepareObjectFromJSON(new JSONObject(objParams.getString("batchCsr")), USER.getUserId(), GICLBatchCsr.class));
		params.put("userId", USER.getUserId());
		return this.getBatchDAO().approveBatchCsr(params);
	}
	
	private GIACBatchDV prepareNewBatchDV(JSONObject object)throws JSONException{
		GIACBatchDV newBatch = new GIACBatchDV();
		newBatch.setPayeeClassCd((String) object.get("payeeClassCd"));
		newBatch.setPayeeCd(object.getInt("payeeCd"));
		System.out.println(object.getString("particulars"));
		System.out.println(object.getString("particulars").equals(""));
		System.out.println(object.isNull("particulars"));
		newBatch.setParticulars(object.isNull("particulars") ? "" : StringEscapeUtils.unescapeHtml(object.getString("particulars")));
		newBatch.setTotalPaidAmt(new BigDecimal((object.getString("totalPaidAmt").equals("") ? "0" : object.getString("totalPaidAmt"))));
		newBatch.setTotalFcurrAmt(new BigDecimal((object.getString("totalFcurrAmt").equals("") ? "0" : object.getString("totalFcurrAmt"))));
		newBatch.setCurrencyCd(object.getInt("currencyCd"));
		newBatch.setConvertRate(new BigDecimal(object.getString("convertRate")));
		newBatch.setPayeeRemarks(object.isNull("payeeRemarks") ? "" : StringEscapeUtils.unescapeHtml(object.getString("payeeRemarks")));
		newBatch.setDspPayee(object.isNull("payee") ? "" : StringEscapeUtils.unescapeHtml(object.getString("payee")));
		return newBatch;
		
	}

	@Override
	public String postRecovery(JSONObject objParams, GIISUser USER)
			throws SQLException, Exception {
		System.out.println("POST recovery");
		Map<String, Object> postParams = new HashMap<String, Object>();
		postParams.put("varFundCd", objParams.getString("varFundCd"));
		postParams.put("varBranchCd", objParams.getString("varBranchCd"));
		postParams.put("issCd", objParams.getString("varBranchCd"));
		postParams.put("recoveryAcctId", objParams.isNull("recoveryAcctId") ? null : objParams.getInt("recoveryAcctId"));
		postParams.put("recAcctYear", objParams.isNull("recAcctYear") ? null : objParams.getInt("recAcctYear"));
		postParams.put("recAcctSeqNo", objParams.isNull("recAcctSeqNo") ? null : objParams.getInt("recAcctSeqNo"));
		postParams.put("recAcctFlag", objParams.getString("recAcctFlag"));
		postParams.put("recoveryAmt", objParams.isNull("recoveryAmt") ? null : new BigDecimal(objParams.getString("recoveryAmt")));
		postParams.put("userId", USER.getUserId());
		System.out.println("test post params: "+postParams);
		
		return this.getBatchDAO().postRecovery(postParams);
	}

}
