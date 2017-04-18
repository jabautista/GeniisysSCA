package com.geniisys.gicl.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.gicl.dao.GICLLossExpDtlDAO;
import com.geniisys.gicl.entity.GICLLossExpDtl;
import com.geniisys.gicl.service.GICLLossExpDtlService;

public class GICLLossExpDtlServiceImpl implements GICLLossExpDtlService{
	
	private GICLLossExpDtlDAO giclLossExpDtlDAO;
	
	public void setGiclLossExpDtlDAO(GICLLossExpDtlDAO giclLossExpDtlDAO) {
		this.giclLossExpDtlDAO = giclLossExpDtlDAO;
	}

	public GICLLossExpDtlDAO getGiclLossExpDtlDAO() {
		return giclLossExpDtlDAO;
	}

	@Override
	public String validateLossExpDtlDelete(Map<String, Object> params)
			throws SQLException {
		return this.getGiclLossExpDtlDAO().validateLossExpDtlDelete(params);
	}
	
	@Override
	public String validateLossExpDtlAdd(Map<String, Object> params)
			throws SQLException {
		return this.getGiclLossExpDtlDAO().validateLossExpDtlAdd(params);
	}

	@Override
	public String validateLossExpDtlUpdate(Map<String, Object> params)
			throws SQLException {
		return this.getGiclLossExpDtlDAO().validateLossExpDtlUpdate(params);
	}

	@Override
	public String computeDepreciation(HttpServletRequest request, GIISUser USER)
			throws SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("claimSublineCd", request.getParameter("claimSublineCd"));
		params.put("claimId", request.getParameter("claimId"));
		params.put("clmLossId", request.getParameter("clmLossId"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("lossExpType", request.getParameter("lossExpType"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("deductibleSw", request.getParameter("dedSw"));
		
		return this.getGiclLossExpDtlDAO().computeDepreciation(params);
	}

	@Override
	public String checkExistLossDtlAllWTax(Map<String, Object> params)
			throws SQLException {
		return this.getGiclLossExpDtlDAO().checkExistLossDtlAllWTax(params);
	}

	@Override
	public String clearLossExpenseDeductibles(HttpServletRequest request,
			GIISUser USER) throws SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", request.getParameter("claimId"));
		params.put("clmLossId", request.getParameter("clmLossId"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("payeeType", request.getParameter("payeeType"));
		params.put("userId", USER.getUserId());
		return this.getGiclLossExpDtlDAO().clearLossExpenseDeductibles(params);
	}

	@Override
	public Map<String, Object> validateSelectedLEDeductible(
			HttpServletRequest request, GIISUser USER) throws SQLException,
			Exception {
		DateFormat date = new SimpleDateFormat("MM-dd-yyyy");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId"));
		params.put("lossExpCd", request.getParameter("lossExpCd"));
		params.put("dtlAmt", request.getParameter("dtlAmt") == null || "".equals(request.getParameter("dtlAmt")) ? null :new BigDecimal(request.getParameter("dtlAmt")));
		params.put("dedBaseAmt", request.getParameter("dedBaseAmt") == null || "".equals(request.getParameter("dedBaseAmt")) ? null :new BigDecimal(request.getParameter("dedBaseAmt")));
		params.put("noOfUnits", request.getParameter("noOfUnits"));
		params.put("nbtDeductType", request.getParameter("nbtDeductType"));
		params.put("dedRate", request.getParameter("dedRate") == null || "".equals(request.getParameter("dedRate")) ? null :new BigDecimal(request.getParameter("dedRate")));
		params.put("nbtMinAmt", request.getParameter("nbtMinAmt") == null || "".equals(request.getParameter("nbtMinAmt")) ? null :new BigDecimal(request.getParameter("nbtMinAmt")));
		params.put("nbtMaxAmt", request.getParameter("nbtMaxAmt") == null || "".equals(request.getParameter("nbtMaxAmt")) ? null :new BigDecimal(request.getParameter("nbtMaxAmt")));
		params.put("nbtRangeSw", request.getParameter("nbtRangeSw"));
		params.put("nbtDedAggrSw", request.getParameter("nbtDedAggrSw"));
		params.put("nbtCeilingSw", request.getParameter("nbtCeilingSw"));
		params.put("paramDedAmt", request.getParameter("paramDedAmt") == null || "".equals(request.getParameter("paramDedAmt")) ? null :new BigDecimal(request.getParameter("paramDedAmt")));
		params.put("nbtDedLossExpCd", request.getParameter("nbtDedLossExpCd"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("perilCd", request.getParameter("perilCd"));
		params.put("groupedItemNo", request.getParameter("groupedItemNo"));
		params.put("payeeType", request.getParameter("payeeType"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("polIssCd", request.getParameter("polIssCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("polEffDate", request.getParameter("polEffDate") == null || "".equals(request.getParameter("polEffDate")) ? null :date.parse(request.getParameter("polEffDate")));
		params.put("expiryDate", request.getParameter("expiryDate") == null || "".equals(request.getParameter("expiryDate")) ? null :date.parse(request.getParameter("expiryDate")));
		params.put("lossDate", request.getParameter("lossDate") == null || "".equals(request.getParameter("lossDate")) ? null :date.parse(request.getParameter("lossDate")));
		return this.getGiclLossExpDtlDAO().validateSelectedLEDeductible(params);
	}

	@Override
	public Map<String, Object> getLossExpDeductibleAmts(
			HttpServletRequest request, GIISUser USER) throws SQLException,
			Exception {
		DateFormat date = new SimpleDateFormat("MM-dd-yyyy");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId"));
		params.put("lossExpCd", request.getParameter("lossExpCd"));
		params.put("dtlAmt", request.getParameter("dtlAmt") == null || "".equals(request.getParameter("dtlAmt")) ? null :new BigDecimal(request.getParameter("dtlAmt")));
		params.put("dedBaseAmt", request.getParameter("dedBaseAmt") == null || "".equals(request.getParameter("dedBaseAmt")) ? null :new BigDecimal(request.getParameter("dedBaseAmt")));
		params.put("noOfUnits", request.getParameter("noOfUnits"));
		params.put("nbtDeductType", request.getParameter("nbtDeductType"));
		params.put("dedRate", request.getParameter("dedRate") == null || "".equals(request.getParameter("dedRate")) ? null : Float.parseFloat(request.getParameter("dedRate")));  //changed big decimal to float : Kenneth : 05.26.2015 : SR 3637 
		params.put("nbtMinAmt", request.getParameter("nbtMinAmt") == null || "".equals(request.getParameter("nbtMinAmt")) ? null :new BigDecimal(request.getParameter("nbtMinAmt")));
		params.put("nbtMaxAmt", request.getParameter("nbtMaxAmt") == null || "".equals(request.getParameter("nbtMaxAmt")) ? null :new BigDecimal(request.getParameter("nbtMaxAmt")));
		params.put("nbtRangeSw", request.getParameter("nbtRangeSw"));
		params.put("nbtDedAggrSw", request.getParameter("nbtDedAggrSw"));
		params.put("nbtCeilingSw", request.getParameter("nbtCeilingSw"));
		params.put("paramDedAmt", request.getParameter("paramDedAmt") == null || "".equals(request.getParameter("paramDedAmt")) ? null :new BigDecimal(request.getParameter("paramDedAmt")));
		params.put("nbtDedLossExpCd", request.getParameter("nbtDedLossExpCd"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("perilCd", request.getParameter("perilCd"));
		params.put("groupedItemNo", request.getParameter("groupedItemNo"));
		params.put("payeeType", request.getParameter("payeeType"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("polIssCd", request.getParameter("polIssCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("polEffDate", request.getParameter("polEffDate") == null || "".equals(request.getParameter("polEffDate")) ? null :date.parse(request.getParameter("polEffDate")));
		params.put("expiryDate", request.getParameter("expiryDate") == null || "".equals(request.getParameter("expiryDate")) ? null :date.parse(request.getParameter("expiryDate")));
		params.put("lossDate", request.getParameter("lossDate") == null || "".equals(request.getParameter("lossDate")) ? null :date.parse(request.getParameter("lossDate")));
		return this.getGiclLossExpDtlDAO().getLossExpDeductibleAmts(params);
	}

	@Override
	public String validateLossExpDeductibleDelete(Map<String, Object> params)
			throws SQLException {
		return this.getGiclLossExpDtlDAO().validateLossExpDeductibleDelete(params);
	}
	
	@Override
	public String validateLossExpDeductibleUpdate(Map<String, Object> params)
			throws SQLException {
		return this.getGiclLossExpDtlDAO().validateLossExpDeductibleUpdate(params);
	}

	@Override
	public void saveLossExpDeductibles(HttpServletRequest request, GIISUser USER)
			throws SQLException, Exception {
		JSONObject objParams = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setGiclLossExpDeductibles", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setGiclLossExpDeductibles")), USER.getUserId(), GICLLossExpDtl.class));
		params.put("delGiclLossExpDeductibles", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("delGiclLossExpDeductibles")), USER.getUserId(), GICLLossExpDtl.class));
		this.getGiclLossExpDtlDAO().saveLossExpDeductibles(params);
	}

	@Override
	public Map<String, Object> checkLOAOverrideRequestExist(
			HttpServletRequest request, GIISUser USER) throws SQLException,
			Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", request.getParameter("claimId"));
		params.put("evalId", request.getParameter("evalId"));
		params.put("clmLossId", request.getParameter("clmLossId"));
		params.put("payeeClassCd", request.getParameter("payeeClassCd"));
		params.put("payeeCd", request.getParameter("payeeCd"));
		params.put("userId", USER.getUserId());
		return this.getGiclLossExpDtlDAO().checkLOAOverrideRequestExist(params);
	}

	@Override
	public void createLOAOverrideRequest(HttpServletRequest request,
			GIISUser USER) throws SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", request.getParameter("claimId"));
		params.put("evalId", request.getParameter("evalId"));
		params.put("clmLossId", request.getParameter("clmLossId"));
		params.put("payeeClassCd", request.getParameter("payeeClassCd"));
		params.put("payeeCd", request.getParameter("payeeCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("remarks", request.getParameter("remarks"));
		params.put("canvas", request.getParameter("canvas"));
		params.put("userId", USER.getUserId());
		this.getGiclLossExpDtlDAO().createLOAOverrideRequest(params);
		
	}

}
