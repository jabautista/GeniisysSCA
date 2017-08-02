/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	rencela
 * Create Date	:	Nov 9, 2010
 ***************************************************/
package com.geniisys.gicl.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLAdviceDAO;
import com.geniisys.gicl.entity.GICLAdvice;
import com.geniisys.gicl.service.GICLAdviceService;
import com.seer.framework.util.StringFormatter;

public class GICLAdviceServiceImpl implements GICLAdviceService{

	private GICLAdviceDAO giclAdviceDAO;
	private static Logger log = Logger.getLogger(GICLAdviceServiceImpl.class);
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLAdviceService#getGICLAdvice(java.lang.Integer)
	 */
	@Override
	public GICLAdvice getGICLAdvice(Integer adviceId) throws SQLException{
		log.info("");
		return this.getGiclAdviceDAO().getGICLAdvice(adviceId);
	}

	/**
	 * @param giclAdviceDAO the giclAdviceDAO to set
	 */
	public void setGiclAdviceDAO(GICLAdviceDAO giclAdviceDAO) {
		this.giclAdviceDAO = giclAdviceDAO;
	}

	/**
	 * @return the giclAdviceDAO
	 */
	public GICLAdviceDAO getGiclAdviceDAO() {
		return giclAdviceDAO;
	}

	@Override
	public Map<String, Object> getGiacs086AdviseList(
			HttpServletRequest request, GIISUser user) throws SQLException,
			JSONException {
		Map<String, Object>params = new HashMap<String, Object>();
		String isEdit = request.getParameter("isEdit");
		params.put("ACTION", (isEdit.equals("Y") ? "getGiacs086AdviseList" : "getGiacs086AdviseList2"));
		params.put("userId", user.getUserId());
		params.put("batchDvId", request.getParameter("batchDvId"));
		params.put("payeeClassCd", request.getParameter("payeeClassCd"));
		params.put("payeeCd", request.getParameter("payeeCd"));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("claimId", request.getParameter("claimId"));
		params.put("condition", request.getParameter("condition"));
		params.put("pageSize", 5);
		System.out.println(params);
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("isEdit", isEdit);
		request.setAttribute("isSpecial", "Y");
		request.setAttribute("adviceListingTG", grid);
		request.setAttribute("object", grid);
		return params;
	}

	@Override
	public JSONObject showGICLAdvice(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGICLS032AdviceList");
		params.put("claimId", request.getParameter("claimId"));		
		
		Map<String, Object> claimAdvice = TableGridUtil.getTableGrid(request, params);			
		JSONObject jsonClaimAdvice = new JSONObject(claimAdvice);
		
		if(request.getParameter("refresh") == null){		
			request.setAttribute("jsonClaimAdvice", jsonClaimAdvice);
			request.setAttribute("showClaimStat", "Y");
			
			Map<String, Object> lossExpParams = new HashMap<String, Object>();
			lossExpParams.put("ACTION", "getGICLClmLossExpList");
			lossExpParams.put("claimId", request.getParameter("claimId"));
			lossExpParams.put("lineCd", request.getParameter("lineCd"));
			Map<String, Object> clmLossExp = TableGridUtil.getTableGrid(request, lossExpParams);						
			request.setAttribute("jsonClmLossExp", new JSONObject(clmLossExp));
			
			Map<String, Object> variablesMap = new HashMap<String, Object>();			
			variablesMap.put("userId", userId);
			variablesMap.put("lineCd", request.getParameter("lineCd"));
			variablesMap.put("issCd", request.getParameter("issCd"));
			this.getGiclAdviceDAO().gicls032NewFormInstance(variablesMap);
			request.setAttribute("vars", new JSONObject(StringFormatter.escapeHTMLInMap(variablesMap)));
		}
		
		return jsonClaimAdvice;
	}
	
	@Override
	public JSONObject gicls032EnableDisableButtons(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("appUser", userId);
		params.put("claimId", request.getParameter("claimId"));
		params.put("adviceId", request.getParameter("adviceId"));
		this.getGiclAdviceDAO().gicls032EnableDisableButtons(params);		
		return new JSONObject(params);
	}
	
	public void gicls032CancelAdvice(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("claimId", request.getParameter("claimId"));
		params.put("adviceId", request.getParameter("adviceId"));
		params.put("functionCode", request.getParameter("functionCode"));
		
		this.getGiclAdviceDAO().gicls032CancelAdvice(params);		
	}

	@Override
	public String gicls032GenerateAdvice(HttpServletRequest request, String userId)
			throws SQLException, JSONException {		
		Map<String, Object> advice = (Map<String, Object>) JSONUtil.prepareMapFromJSON(new JSONObject(request.getParameter("advice")));
		Map<String, Object> params = new HashMap<String, Object>();
		advice.put("remarks", StringFormatter.unescapeHtmlJava((String) (advice.get("remarks").equals(null)?"":advice.get("remarks")))); //added by christian 04/19/2013
		advice.put("payeeRemarks", StringFormatter.unescapeHtmlJava((String) (advice.get("payeeRemarks").equals(null)?"":advice.get("payeeRemarks")))); //added by christian 04/19/2013
		
		System.out.println(advice.toString());
		params.put("userId", userId);
		params.put("claimId", request.getParameter("claimId"));
		params.put("selectedClmLoss", request.getParameter("selectedClmLoss"));
		params.put("userName", request.getParameter("userName"));
		params.put("password", request.getParameter("password"));
		params.put("ovrRangeUserName", request.getParameter("ovrRangeUserName"));
		
		params.putAll(advice);		
		this.giclAdviceDAO.gicls032GenerateAdvice(params);
		return (String) params.get("message");
	}

	@Override
	public void gicls032GenerateAcc(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", request.getParameter("claimId"));
		params.put("adviceId", request.getParameter("adviceId"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("adviceRate", request.getParameter("adviceRate"));
		params.put("userId", userId);
		params.put("progressBarLength", request.getParameter("progressBarLength"));
		
		this.giclAdviceDAO.gicls032GenerateAcc(params);
		
	}

	@Override
	public void gicls032SaveRemarks(HttpServletRequest request, String userId)
			throws SQLException, JSONException {		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("setRows"))));
		params.put("appUser", userId);		
		this.giclAdviceDAO.gicls032SaveRemarks(params);
	}

	@Override
	public JSONObject gicls032ComputeAmounts(HttpServletRequest request) throws JSONException {
		Integer currencyCd = Integer.parseInt(request.getParameter("currencyCd"));
		Integer localCurrency = Integer.parseInt(request.getParameter("localCurrency"));
		Integer adviceCurrency = Integer.parseInt(request.getParameter("adviceCurrency"));
		BigDecimal convertRate = new BigDecimal(request.getParameter("convertRate"));
		
		JSONArray selectedRows = new JSONArray(request.getParameter("rows"));
		
		BigDecimal netAmt = new BigDecimal(0);
		BigDecimal paidAmt = new BigDecimal(0);
		BigDecimal adviseAmt = new BigDecimal(0);
		BigDecimal netFcurrAmt = new BigDecimal(0);
		BigDecimal paidFcurrAmt = new BigDecimal(0);
		BigDecimal advFcurrAmt = new BigDecimal(0);
		
		if(currencyCd.equals(localCurrency)){
			for(int i=0; i<selectedRows.length(); i++){			
				netAmt = netAmt.add(new BigDecimal(selectedRows.getJSONObject(i).isNull("netAmt") ? "0" : selectedRows.getJSONObject(i).getString("netAmt")));
				paidAmt = paidAmt.add(new BigDecimal(selectedRows.getJSONObject(i).isNull("paidAmt") ? "0" : selectedRows.getJSONObject(i).getString("paidAmt")));
				adviseAmt = adviseAmt.add(new BigDecimal(selectedRows.getJSONObject(i).isNull("adviseAmt") ? "0" : selectedRows.getJSONObject(i).getString("adviseAmt")));							
			}
			netFcurrAmt = netAmt.divide(convertRate, RoundingMode.HALF_UP);
			paidFcurrAmt = paidAmt.divide(convertRate, RoundingMode.HALF_UP);
			advFcurrAmt = adviseAmt.divide(convertRate, RoundingMode.HALF_UP);
		} else {
			if(!currencyCd.equals(adviceCurrency)){
				for(int i=0; i<selectedRows.length(); i++){			
					netFcurrAmt = netFcurrAmt.add(new BigDecimal(selectedRows.getJSONObject(i).isNull("netAmt") ? "0" : selectedRows.getJSONObject(i).getString("netAmt")));
					paidFcurrAmt = paidFcurrAmt.add(new BigDecimal(selectedRows.getJSONObject(i).isNull("paidAmt") ? "0" : selectedRows.getJSONObject(i).getString("paidAmt")));
					advFcurrAmt = advFcurrAmt.add(new BigDecimal(selectedRows.getJSONObject(i).isNull("adviseAmt") ? "0" : selectedRows.getJSONObject(i).getString("adviseAmt")));							
				}
				netAmt = netFcurrAmt.multiply(convertRate);
				paidAmt = paidFcurrAmt.multiply(convertRate);
				adviseAmt = advFcurrAmt.multiply(convertRate);
			} else {
				for(int i=0; i<selectedRows.length(); i++){			
					netAmt = netAmt.add(new BigDecimal(selectedRows.getJSONObject(i).isNull("netAmt") ? "0" : selectedRows.getJSONObject(i).getString("netAmt")));
					paidAmt = paidAmt.add(new BigDecimal(selectedRows.getJSONObject(i).isNull("paidAmt") ? "0" : selectedRows.getJSONObject(i).getString("paidAmt")));
					adviseAmt = adviseAmt.add(new BigDecimal(selectedRows.getJSONObject(i).isNull("adviseAmt") ? "0" : selectedRows.getJSONObject(i).getString("adviseAmt")));							
				}
				netFcurrAmt = netAmt.multiply(convertRate);
				paidFcurrAmt = paidAmt.multiply(convertRate);
				advFcurrAmt = adviseAmt.multiply(convertRate);
			}
		}
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("netAmt", netAmt);
		result.put("paidAmt", paidAmt);
		result.put("adviseAmt", adviseAmt);
		result.put("netFcurrAmt", netFcurrAmt);
		result.put("paidFcurrAmt", paidFcurrAmt);
		result.put("advFcurrAmt", advFcurrAmt);
		
		return new JSONObject(result);
	}
	
	public Integer gicls032CheckRequestExists(HttpServletRequest request) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", request.getParameter("claimId"));
		params.put("adviceId", request.getParameter("adviceId"));
		params.put("functionCode", request.getParameter("functionCode"));
		
		return this.giclAdviceDAO.gicls032CheckRequestExist(params);
	}

	@Override
	public void gicls032CreateOverrideRequest(HttpServletRequest request,
			String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("claimId", request.getParameter("claimId"));
		params.put("adviceId", request.getParameter("adviceId"));
		params.put("remarks", request.getParameter("remarks"));
		params.put("functionCode", request.getParameter("functionCode"));
		
		this.giclAdviceDAO.gicls032CreateOverrideRequest(params);
	}

	@Override
	public void gicls032ApproveCsr(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("claimId", request.getParameter("claimId"));
		params.put("adviceId", request.getParameter("adviceId"));
		params.put("acUserName", request.getParameter("acUserName"));
		params.put("rpUserName", request.getParameter("rpUserName"));
		params.put("overrideSw", request.getParameter("overrideSw"));
		params.put("colValue", request.getParameter("claimId"));
		params.put("moduleId", "GICLS032");
		this.giclAdviceDAO.gicls032ApproveCsr(params);
	}

	@Override
	public String checkGeneratedFla(Map<String, Object> params)
			throws SQLException {
		return this.getGiclAdviceDAO().checkGeneratedFla(params);
	}

	@Override
	public void gicls032CheckTsi(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", request.getParameter("claimId"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("perilCd", request.getParameter("perilCd"));
		params.put("selectedClmLoss", request.getParameter("selectedClmLoss"));
		
		this.giclAdviceDAO.gicls032CheckTsi(params);
	}

	@Override
	public JSONObject gicls032WhenCurrencyChanged(HttpServletRequest request)
			throws JSONException {
		Integer currencyCd = Integer.parseInt(request.getParameter("currencyCd"));
		Integer localCurrency = Integer.parseInt(request.getParameter("localCurrency"));
		BigDecimal convertRate = new BigDecimal(request.getParameter("adviceRate"));
		
		BigDecimal netAmt = new BigDecimal(request.getParameter("netAmt").replaceAll(",", ""));
		BigDecimal paidAmt = new BigDecimal(request.getParameter("paidAmt").replaceAll(",", ""));
		BigDecimal adviseAmt = new BigDecimal(request.getParameter("adviseAmt").replaceAll(",", ""));
		BigDecimal netFcurrAmt = new BigDecimal(request.getParameter("netFcurrAmt").replaceAll(",", ""));
		BigDecimal paidFcurrAmt = new BigDecimal(request.getParameter("paidFcurrAmt").replaceAll(",", ""));
		BigDecimal advFcurrAmt = new BigDecimal(request.getParameter("advFcurrAmt").replaceAll(",", ""));
		
		if(currencyCd.equals(localCurrency)){
			netFcurrAmt = netAmt;
			paidFcurrAmt = paidAmt;
			advFcurrAmt = adviseAmt;

			netAmt = netFcurrAmt.multiply(convertRate);
			paidAmt = paidFcurrAmt.multiply(convertRate);
			adviseAmt = advFcurrAmt.multiply(convertRate);
		} else {
			netFcurrAmt = netAmt;
			paidFcurrAmt = paidAmt;
			advFcurrAmt = adviseAmt;
			
			netAmt = netFcurrAmt.divide(convertRate, RoundingMode.HALF_UP);
			paidAmt = paidFcurrAmt.divide(convertRate, RoundingMode.HALF_UP);
			adviseAmt = advFcurrAmt.divide(convertRate, RoundingMode.HALF_UP);
		}
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("netAmt", netAmt);
		result.put("paidAmt", paidAmt);
		result.put("adviseAmt", adviseAmt);
		result.put("netFcurrAmt", netFcurrAmt);
		result.put("paidFcurrAmt", paidFcurrAmt);
		result.put("advFcurrAmt", advFcurrAmt);
		
		return new JSONObject(result);
	}

	@Override
	public Map<String, Object> getGICLS260Advice(
			Map<String, Object> params) throws SQLException {
		return StringFormatter.escapeHTMLInMap(this.getGiclAdviceDAO().getGICLS260Advice(params));
	}
	
	@Override
	public void gicls032TestFunction(HttpServletRequest request,
			String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("claimId", request.getParameter("claimId"));
		params.put("adviceId", request.getParameter("adviceId"));
		
		this.giclAdviceDAO.gicls032CreateOverrideRequest(params);
	}
}
