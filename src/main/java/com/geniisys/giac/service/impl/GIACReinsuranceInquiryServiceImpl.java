package com.geniisys.giac.service.impl;


import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.service.GIACReinsuranceInquiryService;

public class GIACReinsuranceInquiryServiceImpl implements GIACReinsuranceInquiryService {
	
	//ape 6-4-2013
	@Override
	public JSONObject viewRiLossRecoveries(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getRiLossRecov");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("riCd", request.getParameter("riCd"));
		params.put("paidFlag", request.getParameter("paidFlag"));
		params.put("withClmPay", request.getParameter("withClmPay"));
		Map<String, Object> riLossesRecoveriesTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonriLossesRecoveries = new JSONObject(riLossesRecoveriesTableGrid);
		request.setAttribute("jsonriLossesRecoveries", jsonriLossesRecoveries);
		return jsonriLossesRecoveries;
	}
	@Override
	public JSONObject viewRiLossRecoveriesOverlay(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getRiLossRecovOverlay");
		params.put("lineCd2", request.getParameter("lineCd2"));
		params.put("laYy", request.getParameter("laYy"));
		params.put("flaSeqNo", request.getParameter("flaSeqNo"));
		params.put("mainPageAmt", request.getParameter("mainPageAmt"));
		
		Map<String, Object> riLossesRecoveriesOverLayTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonriLossesRecoveriesOverlay = new JSONObject(riLossesRecoveriesOverLayTableGrid);
		request.setAttribute("jsonriLossesRecoveriesOverlay", jsonriLossesRecoveriesOverlay);
		return jsonriLossesRecoveriesOverlay;
	}

	@Override
	public JSONObject getGIACS270GipiInvoice(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", request.getParameter("action"));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", USER.getUserId());
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		Map<String, Object> gipiInvoiceRiMap = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonGipiInvoiceRi = new JSONObject(gipiInvoiceRiMap);
		return jsonGipiInvoiceRi;
	}

	@Override
	public JSONObject showRiBillPayment(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIACS270GiacInwfaculPremCollns");
		Map<String, Object> giacInwfaculPremCollnsTg = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonGiacInwfaculPremCollnsTg = new JSONObject(giacInwfaculPremCollnsTg);
		return jsonGiacInwfaculPremCollnsTg;
	}

	@Override
	public JSONObject getGIACS270GiacInwfaculPremCollns(
			HttpServletRequest request, GIISUser USER) throws SQLException,
			JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", request.getParameter("action"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		Map<String, Object> giacInwfaculPremCollnsTg = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonGiacInwfaculPremCollnsTg = new JSONObject(giacInwfaculPremCollnsTg);
		return jsonGiacInwfaculPremCollnsTg;
	}
}
