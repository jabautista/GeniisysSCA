package com.geniisys.gicl.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gicl.dao.GICLBiggestClaimDAO;
import com.geniisys.gicl.service.GICLBiggestClaimService;

public class GICLBiggestClaimServiceImpl implements GICLBiggestClaimService{
	
	private GICLBiggestClaimDAO giclBiggestClaimDAO;

	public GICLBiggestClaimDAO getGiclBiggestClaimDAO() {
		return giclBiggestClaimDAO;
	}

	public void setGiclBiggestClaimDAO(GICLBiggestClaimDAO giclBiggestClaimDAO) {
		this.giclBiggestClaimDAO = giclBiggestClaimDAO;
	}
	
	@Override
	public String whenNewFormInstanceGICLS220(HttpServletRequest request)
			throws SQLException {
		JSONObject result = new JSONObject(this.giclBiggestClaimDAO.whenNewFormInstanceGICLS220());
		return result.toString();
	}

	@Override
	public String extractGICLS220(HttpServletRequest request, String userId)
			throws SQLException, ParseException {
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("lossAmt", request.getParameter("lossAmt") == null || "".equals(request.getParameter("lossAmt")) ? null : new BigDecimal(request.getParameter("lossAmt")));
		//params.put("biggestClaims", request.getParameter("biggestClaims") == null || request.getParameter("biggestClaims") == "" ? null : Integer.parseInt(request.getParameter("biggestClaims")));
		params.put("biggestClaims", request.getParameter("biggestClaims"));
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("fromdate", request.getParameter("fromdate")); 
		params.put("todate", request.getParameter("todate"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("assdCedantNo", request.getParameter("assdCedantNo"));
		params.put("claimStatusOP", request.getParameter("claimStatusOP"));
		params.put("claimStatusCL", request.getParameter("claimStatusCL"));
		params.put("claimStatusCC", request.getParameter("claimStatusCC"));
		params.put("claimStatusDE", request.getParameter("claimStatusDE"));
		params.put("claimStatusWD", request.getParameter("claimStatusWD"));
		params.put("branchParam", request.getParameter("branchParam"));
		params.put("claimAmtO", request.getParameter("claimAmtO"));
		params.put("claimAmtR", request.getParameter("claimAmtR"));
		params.put("claimAmtS", request.getParameter("claimAmtS"));
		params.put("lossExpense", request.getParameter("lossExpense"));
		params.put("claimDate", request.getParameter("claimDate"));
		params.put("hidRiIssCd", request.getParameter("hidRiIssCd"));
		params.put("extractType", request.getParameter("extractType"));
		JSONObject result = new JSONObject(this.getGiclBiggestClaimDAO().extractGICLS220(params)); 
		return result.toString();
	}

	@Override
	public String extractParametersExistGicls220(HttpServletRequest request,
			GIISUser USER) throws SQLException, Exception {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("extractType", request.getParameter("extractType"));
		params.put("lossAmt", request.getParameter("lossAmt"));
		params.put("biggestClaims", request.getParameter("biggestClaims"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("asOfDate", request.getParameter("asOfDate"));
		
		return giclBiggestClaimDAO.extractParametersExistGicls220(params);
	}
}
