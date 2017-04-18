package com.geniisys.giri.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giri.dao.GIRIInpolbasDAO;
import com.geniisys.giri.service.GIRIInpolbasService;

public class GIRIInpolbasServiceImpl implements GIRIInpolbasService{
	
	private GIRIInpolbasDAO giriInpolbasDAO;
	
	public GIRIInpolbasDAO getGiriInpolbasDAO() {
		return giriInpolbasDAO;
	}

	public void setGiriInpolbasDAO(GIRIInpolbasDAO giriInpolbasDAO) {
		this.giriInpolbasDAO = giriInpolbasDAO;
	}

	@Override
	public JSONObject getInwardRiPaymentStatus(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("policyId", request.getParameter("policyId") == null || request.getParameter("policyId") == "" ? null : Integer.parseInt(request.getParameter("policyId")));
		params.put("ACTION", "getInwardRiPaymentStatus");
		Map<String, Object> inwardRiPaymentStatusTG = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonInwardRiPaymentStatus = new JSONObject(inwardRiPaymentStatusTG);
		request.setAttribute("jsonInwardRiPaymentStatus", jsonInwardRiPaymentStatus);
		return jsonInwardRiPaymentStatus;
	}

	@Override
	public JSONObject showInwRiDetailsOverlay(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		params.put("ACTION", "getInwRiDetails");
		Map<String, Object> inwRiDetailsTG = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonInwRiDetails = new JSONObject(inwRiDetailsTG);
		request.setAttribute("jsonInwRiDetails", jsonInwRiDetails);
		return jsonInwRiDetails;
	}

	@Override
	public JSONObject showGIRIS012MainTableGrid(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "populateGIRIS012MainTG");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("frpsYy", request.getParameter("frpsYy"));
		params.put("frpsSeqNo", request.getParameter("frpsSeqNo"));
		params.put("userId", USER.getUserId());
		
		Map<String, Object> giris012MainTG = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonGIRIS012MainTG = new JSONObject(giris012MainTG);
		return jsonGIRIS012MainTG;
	}

	@Override
	public JSONObject showGIRIS012Details(HttpServletRequest request) throws SQLException, JSONException, ParseException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIRIS012Details");
		params.put("fnlBinderId", request.getParameter("fnlBinderId"));
		
		Map<String, Object> giris012Details = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonGIRIS012Details = new JSONObject(giris012Details);
		return jsonGIRIS012Details;
	}

	@Override
	public JSONObject getGIUTS030BinderList(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIUTS030BinderList");
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("status", request.getParameter("status"));
		params.put("userId", USER.getUserId());
		System.out.println(params);
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(map);
		return json;		
	}

	@Override
	public JSONObject populateGiris027(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "populateGiris027");
		params.put("riCd", request.getParameter("riCd"));
		params.put("userId", USER.getUserId());
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(map);
		return json;
	}

}
