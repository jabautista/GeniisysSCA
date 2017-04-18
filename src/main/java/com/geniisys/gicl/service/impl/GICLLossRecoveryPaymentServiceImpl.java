package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLLossRecoveryPaymentDAO;
import com.geniisys.gicl.service.GICLLossRecoveryPaymentService;

public class GICLLossRecoveryPaymentServiceImpl implements GICLLossRecoveryPaymentService{
	
	private GICLLossRecoveryPaymentDAO giclLossRecoveryPaymentDAO;
	
	
	public GICLLossRecoveryPaymentDAO getGiclLossRecoveryPaymentDAO() {
		return giclLossRecoveryPaymentDAO;
	}


	public void setGiclLossRecoveryPaymentDAO(
			GICLLossRecoveryPaymentDAO giclLossRecoveryPaymentDAO) {
		this.giclLossRecoveryPaymentDAO = giclLossRecoveryPaymentDAO;
	}


	@Override
	public JSONObject showLossRecoveryPayment(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("ACTION", "getLossRecoveryPayment");
		params.put("appUser", USER.getUserId());
		Map<String, Object> lossRecoveryPaymentTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(lossRecoveryPaymentTableGrid);
		request.setAttribute("jsonLossRecoveryPayment", json);
		return json;
	}


	@Override
	public JSONObject showGICLS270PaymentDetails(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("ACTION", "getPaymentDetails");
		params.put("recoveryId", request.getParameter("recoveryId"));
		Map<String, Object> paymentDetailsTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(paymentDetailsTableGrid);
		request.setAttribute("jsonPaymentDetails", json);
		return json;
	}


	@Override
	public JSONObject showGICLS270DistributionDs(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("ACTION", "getDistributionDsDetails");
		params.put("recoveryId", request.getParameter("recoveryId"));
		params.put("recoveryPaytId", request.getParameter("recoveryPaytId"));
		Map<String, Object> distributionDsDetailsTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(distributionDsDetailsTableGrid);
		request.setAttribute("jsonDistributionDsDetails", json);
		return json;
	}


	@Override
	public JSONObject showGICLS270DistributionRids(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("ACTION", "getDistributionRidsDetails");
		params.put("recoveryId", request.getParameter("recoveryId"));
		params.put("recoveryPaytId", request.getParameter("recoveryPaytId"));
		params.put("recDistNo", request.getParameter("recDistNo"));
		params.put("grpSeqNo", request.getParameter("grpSeqNo"));
		Map<String, Object> distributionRidsDetailsTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(distributionRidsDetailsTableGrid);
		return json;
	}

}
