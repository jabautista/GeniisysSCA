package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.TreatyPerilsDAO;
import com.geniisys.common.entity.GIISTrtyPeril;
import com.geniisys.common.service.TreatyPerilsService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;

public class TreatyPerilsServiceImpl implements TreatyPerilsService{
	private TreatyPerilsDAO treatyPerilsDAO;

	public TreatyPerilsDAO getTreatyPerilsDAO() {
		return treatyPerilsDAO;
	}

	public void setTreatyPerilsDAO(TreatyPerilsDAO treatyPerilsDAO) {
		this.treatyPerilsDAO = treatyPerilsDAO;
	}

	@Override
	public JSONObject showGiris007DistShare(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiris007DistShareRecList");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("trtyYy", request.getParameter("trtyYy"));
		params.put("shareCd", request.getParameter("shareCd"));
		params.put("userId", userId);
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}

	@Override
	public JSONObject showGiris007Xol(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiris007XolRecList");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("xolYy", request.getParameter("trtyYy"));
		params.put("xolSeqNo", request.getParameter("shareCd"));
		params.put("layerNo", request.getParameter("layerNo") == null ? "" : request.getParameter("layerNo"));
		params.put("userId", userId);
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}

	@Override
	public JSONObject executeA6401(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getA6401RecList");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("trtyYy", request.getParameter("trtyYy"));
		params.put("shareCd", request.getParameter("shareCd"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}

	@Override
	public void valAddA6401Rec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("lineCd") != null && request.getParameter("perilCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("lineCd", request.getParameter("lineCd"));
			params.put("trtyYy", request.getParameter("trtyYy"));
			params.put("shareCd", request.getParameter("shareCd"));
			params.put("perilCd", request.getParameter("perilCd"));
			System.out.println("validate add a6401 parameters :::::::::::::" + params);
			this.treatyPerilsDAO.valAddA6401Rec(params);
		}
	}

	@Override
	public void saveA6401(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISTrtyPeril.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISTrtyPeril.class));
		params.put("appUser", userId);
		this.treatyPerilsDAO.saveA6401(params);
	}

	@Override
	public JSONObject includeAllA6401(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getA6401IncAllRecList");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("trtyYy", request.getParameter("trtyYy"));
		params.put("shareCd", request.getParameter("shareCd"));;
		params.put("userId", userId);
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}

	@Override
	public JSONObject executeTrtyPerilXol(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		
		Integer shareCd = 0; //Added by Jerome Bautista 06.29.2016 SR 5558
		
		if (request.getParameter("shareCd").equals("") || request.getParameter("shareCd") == null){
			shareCd = 0;
		} else {
			shareCd = Integer.parseInt(request.getParameter("shareCd"));
		}
		
		params.put("ACTION", "getTrtyPerilXolRecList");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("xolYy", request.getParameter("xolYy") == null ? 0 : Integer.parseInt(request.getParameter("xolYy")));
		params.put("xolSeqNo", request.getParameter("xolSeqNo") == null ? 0 : Integer.parseInt(request.getParameter("xolSeqNo")));
	    params.put("shareCd", shareCd); //Modified by Jerome Bautista 06.29.2016 SR 5558
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}

	@Override
	public void valAddTrtyPerilXolRec(HttpServletRequest request)
			throws SQLException {
		if(request.getParameter("lineCd") != null && request.getParameter("perilCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("lineCd", request.getParameter("lineCd"));
			params.put("xolYy", request.getParameter("xolYy"));
			params.put("xolSeqNo", request.getParameter("xolSeqNo"));
			params.put("perilCd", request.getParameter("perilCd"));
			params.put("shareCd", request.getParameter("shareCd")); //nieko 02142017, SR 23828
			System.out.println("validate add treaty peril parameters :::::::::::::" + params);
			this.treatyPerilsDAO.valAddTrtyPerilXolRec(params);
		}
	}

	@Override
	public void saveTrtyPerilXol(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISTrtyPeril.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISTrtyPeril.class));
		params.put("appUser", userId);
		this.treatyPerilsDAO.saveTrtyPerilXol(params);
	}

	@Override
	public JSONArray getAllPerils(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("trtySeqNo", request.getParameter("trtySeqNo"));
		params.put("notIn", request.getParameter("notIn").toString());
		params.put("notInDeleted", request.getParameter("notInDeleted").toString());
		
		List<Map<String, Object>> perilList = this.getTreatyPerilsDAO().getAllPerils(params);
		return new JSONArray(perilList);
	}
}
