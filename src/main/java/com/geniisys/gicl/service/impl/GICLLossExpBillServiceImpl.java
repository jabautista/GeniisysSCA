package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.gicl.dao.GICLLossExpBillDAO;
import com.geniisys.gicl.entity.GICLLossExpBill;
import com.geniisys.gicl.service.GICLLossExpBillService;

public class GICLLossExpBillServiceImpl implements GICLLossExpBillService{
	
	private GICLLossExpBillDAO giclLossExpBillDAO;
	
	public GICLLossExpBillDAO getGiclLossExpBillDAO() {
		return giclLossExpBillDAO;
	}

	public void setGiclLossExpBillDAO(GICLLossExpBillDAO giclLossExpBillDAO) {
		this.giclLossExpBillDAO = giclLossExpBillDAO;
	}

	@Override
	public void saveLossExpBill(HttpServletRequest request, GIISUser USER)
			throws SQLException, Exception {
		JSONObject objParams = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setGiclLossExpBill", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setGiclLossExpBill")), USER.getUserId(), GICLLossExpBill.class));
		params.put("delGiclLossExpBill", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("delGiclLossExpBill")), USER.getUserId(), GICLLossExpBill.class));
		this.getGiclLossExpBillDAO().saveLossExpBill(params);
	}

	@Override
	public Map<String, Object> chkLossExpBill(HttpServletRequest request) throws SQLException,
			Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("payeeClassCd", request.getParameter("payeeClassCd"));
		params.put("payeeCd", request.getParameter("payeeCd"));
		params.put("docType", request.getParameter("docType"));
		params.put("docNumber", request.getParameter("docNumber"));
		return this.giclLossExpBillDAO.chkLossExpBill(params);
	} //Added by: Jerome Bautista 05.28.2015 SR 3646
}
