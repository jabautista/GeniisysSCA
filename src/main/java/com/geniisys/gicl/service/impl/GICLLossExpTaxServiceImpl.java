package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.gicl.dao.GICLLossExpTaxDAO;
import com.geniisys.gicl.entity.GICLLossExpenseTax;
import com.geniisys.gicl.service.GICLLossExpTaxService;

public class GICLLossExpTaxServiceImpl implements GICLLossExpTaxService{

	private GICLLossExpTaxDAO giclLossExpTaxDAO;
	
	public void setGiclLossExpTaxDAO(GICLLossExpTaxDAO giclLossExpTaxDAO) {
		this.giclLossExpTaxDAO = giclLossExpTaxDAO;
	}

	public GICLLossExpTaxDAO getGiclLossExpTaxDAO() {
		return giclLossExpTaxDAO;
	}

	@Override
	public Integer getNextTaxId(Map<String, Object> params) throws SQLException,
			Exception {
		return this.getGiclLossExpTaxDAO().getNextTaxId(params);
	}

	@Override
	public void saveLossExpTax(HttpServletRequest request, GIISUser USER)
			throws SQLException, Exception {
		JSONObject objParams = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setGiclLossExpTax", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setGiclLossExpTax")), USER.getUserId(), GICLLossExpenseTax.class));
		params.put("delGiclLossExpTax", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("delGiclLossExpTax")), USER.getUserId(), GICLLossExpenseTax.class));
		this.getGiclLossExpTaxDAO().saveLossExpTax(params);
	}
	
	@Override
	public Integer checkLossExpTaxType(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", request.getParameter("claimId"));
		params.put("clmLossId", request.getParameter("clmLossId"));
		return this.getGiclLossExpTaxDAO().checkLossExpTaxType(params);
	}
	
	@Override
	public String checkLossExpTaxExist(HttpServletRequest request) throws SQLException { //benjo 03.08.2017 SR-5945
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", request.getParameter("claimId"));
		params.put("clmLossId", request.getParameter("clmLossId"));
		params.put("lossExpCd", request.getParameter("lossExpCd"));
		return this.getGiclLossExpTaxDAO().checkLossExpTaxExist(params);
	}

}
