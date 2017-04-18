/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	rencela
 * Create Date	:	Jan 26, 2012
 ***************************************************/
package com.geniisys.gicl.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.DateUtil;
import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.gicl.dao.GICLClaimReserveDAO;
import com.geniisys.gicl.entity.GICLClaimReserve;
import com.geniisys.gicl.service.GICLClaimReserveService;
import com.seer.framework.util.StringFormatter;

public class GICLClaimReserveServiceImpl implements GICLClaimReserveService{

	private GICLClaimReserveDAO giclClaimReserveDAO;
	private Logger log = Logger.getLogger(GICLClaimReserveServiceImpl.class);
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClaimReserveService#getClaimReserveInitValues(java.lang.Integer)
	 */
	@Override
	public Map<String, Object> getClaimReserveInitValues(HttpServletRequest request)
			throws SQLException {
		Integer claimId = Integer.parseInt(request.getParameter("claimId"));
		Integer itemNo = Integer.parseInt(request.getParameter("itemNo"));
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", claimId);
		params.put("itemNo", itemNo);
		
		return this.giclClaimReserveDAO.getClaimReserveInitValues(params);
	}
	
	public void setGiclClaimReserveDAO(GICLClaimReserveDAO giclClaimReserveDAO) {
		this.giclClaimReserveDAO = giclClaimReserveDAO;
	}
	
	public GICLClaimReserveDAO getGiclClaimReserveDAO() {
		return giclClaimReserveDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClaimReserveService#getClaimReserve(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public GICLClaimReserve getClaimReserve(HttpServletRequest request)
			throws SQLException {
		Integer claimId = Integer.parseInt(request.getParameter("claimId"));
		Integer itemNo = Integer.parseInt(request.getParameter("itemNo"));
		Integer perilCd = Integer.parseInt(request.getParameter("perilCd"));
		return this.giclClaimReserveDAO.getClaimReserve(claimId, itemNo, perilCd);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClaimReserveService#getPreValidationParams(javax.servlet.http.HttpServletRequest)
	 */
	@Override
	public JSONObject getPreValidationParams(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", request.getParameter("claimId"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("perilCd", request.getParameter("perilCd"));
		params.put("groupedItemNo", request.getParameter("groupedItemNo"));
		
		this.giclClaimReserveDAO.getPreValidationParams(params);
		return new JSONObject(params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClaimReserveService#updateStatus(javax.servlet.http.HttpServletRequest, java.lang.String)
	 */
	@Override
	public void updateStatus(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("claimId", request.getParameter("claimId"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("perilCd", request.getParameter("perilCd"));
		params.put("groupedItemNo", request.getParameter("groupedItemNo"));
		params.put("closeFlag", request.getParameter("closeFlag"));
		params.put("closeFlag2", request.getParameter("closeFlag2"));
		params.put("updateXol", request.getParameter("updateXol"));
		params.put("distributionDate", request.getParameter("distributionDate"));
		params.put("lossReserve", request.getParameter("lossReserve"));
		params.put("expenseReserve", request.getParameter("expenseReserve"));
		this.giclClaimReserveDAO.updateStatus(params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClaimReserveService#getAvailmentTotals(java.util.Map)
	 */
	@Override
	public Map<String, Object> getAvailmentTotals(Map<String, Object> params)
			throws SQLException {
		return this.giclClaimReserveDAO.getAvailmentTotals(params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClaimReserveService#checkUWDist(javax.servlet.http.HttpServletRequest)
	 */
	@Override
	public String checkUWDist(HttpServletRequest request) throws SQLException,
			JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("polIssCd", request.getParameter("polIssCd"));
		params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
		FormInputUtil.prepareDateParam("expiryDate", params, request);
		FormInputUtil.prepareDateParam("polEffDate", params, request);
		FormInputUtil.prepareDateParam("dspLossDate", params, request);
		params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
		params.put("perilCd", Integer.parseInt(request.getParameter("perilCd")));
		
		Map<String, Object> newMap = this.getGiclClaimReserveDAO().checkUWDist(params);
		System.out.println("Test - "+newMap.get("message"));
		return (String) newMap.get("message");
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClaimReserveService#redistributeReserve(javax.servlet.http.HttpServletRequest, java.lang.String)
	 */
	@Override
	public String redistributeReserve(HttpServletRequest request, String userId)
			throws SQLException, ParseException {
		System.out.println("redistribute Reserve...");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("claimId", Integer.parseInt(request.getParameter("claimId")));
		params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
		params.put("perilCd", Integer.parseInt(request.getParameter("perilCd")));
		params.put("groupedItemNo",  Integer.parseInt(request.getParameter("groupedItemNo")));
		//FormInputUtil.prepareDateParam("distributionDate", params, request);
		FormInputUtil.prepareDateParam("distDate", params, request); //SR 22277 Aliza replaced by code below
		params.put("lossReserve", new BigDecimal(request.getParameter("lossReserve")));
		params.put("expenseReserve", new BigDecimal(request.getParameter("expenseReserve")));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("lossesPaid", request.getParameter("lossesPaid").equals("") ? null : new BigDecimal(request.getParameter("lossesPaid")));
		params.put("expensesPaid", request.getParameter("expensesPaid").equals("") ? null : new BigDecimal(request.getParameter("expensesPaid")));
		
		String result = this.getGiclClaimReserveDAO().redistributeReserve(params);
		return result;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClaimReserveService#checkLossRsrv(javax.servlet.http.HttpServletRequest, java.lang.String)
	 */
	@Override
	public String checkLossRsrv(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", Integer.parseInt(request.getParameter("claimId")));
		params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
		params.put("perilCd", Integer.parseInt(request.getParameter("perilCd")));
		params.put("groupedItemNo",  Integer.parseInt(request.getParameter("groupedItemNo")));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("lossReserve", new BigDecimal(request.getParameter("lossReserve")));
		params.put("expenseReserve", new BigDecimal(request.getParameter("expenseReserve")));
		params.put("convertRate", new BigDecimal(request.getParameter("convertRate")));

		params = this.getGiclClaimReserveDAO().checkLossRsrv(params);
		System.out.println("checkLossRsrv check: "+params);
		return new JSONObject(params).toString();
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClaimReserveService#gicls024OverrideExpense(javax.servlet.http.HttpServletRequest)
	 */
	@Override
	public String gicls024OverrideExpense(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("user", request.getParameter("user"));
		params.put("lossReserve", new BigDecimal(request.getParameter("lossReserve")));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("issCd", request.getParameter("issCd"));
		return this.getGiclClaimReserveDAO().gicls024OverrideExpense(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClaimReserveService#createOverrideRequest(java.util.Map)
	 */
	@Override
	public void createOverrideRequest(Map<String, Object> params)
			throws SQLException {
		this.getGiclClaimReserveDAO().createOverrideRequest(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClaimReserveService#saveClaimReserve(javax.servlet.http.HttpServletRequest, java.lang.String)
	 */
	@Override
	public String saveClaimReserve(HttpServletRequest request, String userId)
			throws SQLException {
		log.info("save claim reserve");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("claimId", Integer.parseInt(request.getParameter("claimId")));
		params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
		params.put("perilCd", Integer.parseInt(request.getParameter("perilCd")));
		params.put("groupedItemNo", Integer.parseInt(request.getParameter("groupedItemNo")));
		params.put("distDate", (DateUtil.toDate(request.getParameter("distDate")) == null)? new Date(): DateUtil.toDate(request.getParameter("distDate")));		
		try {
			FormInputUtil.prepareDateParam("distDate", params, request);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("lossReserve", new BigDecimal(Double.parseDouble(request.getParameter("lossReserve"))));
		params.put("expenseReserve", new BigDecimal(Double.parseDouble(request.getParameter("expenseReserve"))));
		params.put("lossesPaid", request.getParameter("lossesPaid").equals("") ? null : new BigDecimal(request.getParameter("lossesPaid")));
		params.put("expensesPaid", request.getParameter("expensesPaid").equals("") ? null : new BigDecimal(request.getParameter("expensesPaid")));
		params.put("histSeqNo", Integer.parseInt(request.getParameter("histSeqNo")));
		params.put("vRedistSw", request.getParameter("vRedistSw"));
		params.put("remarks", StringFormatter.unescapeHTML2(request.getParameter("remarks").replace("&#124;", "|"))); //lara 11-07-2013
		params.put("bookingMonth", request.getParameter("bookingMonth"));
		params.put("bookingYear", request.getParameter("bookingYear"));
		params.put("currencyCd", request.getParameter("currencyCd")); // added by marco - 02.06.2013
		params.put("convertRate", request.getParameter("convertRate")); // added by aliza - 08.26.2016
		System.out.println("saveClaimReserve check by aliza: "+params);		
		return this.giclClaimReserveDAO.saveClaimReserve(params);
	}
	
	@Override
	public String gicls024ChckLossRsrv(HttpServletRequest request, String userId)
			throws SQLException, JSONException, ParseException {

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", Integer.parseInt(request.getParameter("claimId")));
		params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
		params.put("perilCd", Integer.parseInt(request.getParameter("perilCd")));
		params.put("groupedItemNo", Integer.parseInt(request.getParameter("groupedItemNo")));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("userId", userId);
		params.put("lossReserve", new BigDecimal(Double.parseDouble(request.getParameter("lossReserve"))));
		params.put("expenseReserve", new BigDecimal(Double.parseDouble(request.getParameter("expenseReserve"))));
		params.put("convertRate", new BigDecimal(Double.parseDouble(request.getParameter("convertRate"))));
		
		Map<String, Object> newMap = this.getGiclClaimReserveDAO().gicls024ChckLossRsrv(params);
		System.out.println("Test - "+newMap.get("message"));
		return (String) newMap.get("message");
	}

	@Override
	public String chckBkngDteExist(Integer claimId) throws SQLException {
		return this.giclClaimReserveDAO.chckBkngDteExist(claimId);
	}

	@Override
	public String gicls024OverrideCount(Integer claimId) throws SQLException {
		return this.giclClaimReserveDAO.gicls024OverrideCount(claimId);
	}

	@Override
	public Map<String, Object> validateExistingDistGICLS024(
			HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", request.getParameter("claimId"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("polIssCd"));
		params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
		return this.giclClaimReserveDAO.validateExistingDistGICLS024(params);
	}

	@Override
	public String redistributeReserveGICLS038(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("USER", USER);
		params.put("userId", USER.getUserId());
		params.put("dateToday", request.getParameter("dateToday"));
		params.put("rows", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("rows"))));
		JSONObject result = new JSONObject(this.giclClaimReserveDAO.redistributeReserveGICLS038((HashMap<String, Object>) params));
		return result.toString();
	}

	@Override
	public String redistributeLossExpenseGICLS038(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("USER", USER);
		params.put("userId", USER.getUserId());
		params.put("dateToday", request.getParameter("dateToday"));
		params.put("rows", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("rows"))));
		JSONObject result = new JSONObject(this.giclClaimReserveDAO.redistributeLossExpenseGICLS038((HashMap<String, Object>) params));
		return result.toString();
	}

	@Override
	public void createOverrideBasicInfo(Map<String, Object> params) throws SQLException {
		this.getGiclClaimReserveDAO().createOverrideBasicInfo(params);
	}	
}