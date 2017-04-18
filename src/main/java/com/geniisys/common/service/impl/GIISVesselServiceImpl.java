package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISVesselDAO;
import com.geniisys.common.entity.GIISVessel;
import com.geniisys.common.service.GIISVesselService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;

public class GIISVesselServiceImpl implements GIISVesselService {
	
	private GIISVesselDAO giisVesselDAO;

	@Override
	public JSONObject showGiiss049(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss049RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}

	@Override
	public String valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("vesselCd") != null){
			String vesselCd = request.getParameter("vesselCd");
			return giisVesselDAO.valDeleteRec(vesselCd);
		} else {
			return null;
		}
		
	}

	@Override
	public void saveGiiss049(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISVessel.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISVessel.class));
		params.put("appUser", userId);
		giisVesselDAO.saveGiiss049(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("vesselCd") != null){
			System.out.println(request.getParameter("vesselCd"));
			String recId = request.getParameter("vesselCd");
			giisVesselDAO.valAddRec(recId);
		}
	}
	
	public Map<String, Object> validateAirTypeCd(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("airTypeCd", request.getParameter("airTypeCd"));
		params.put("airDesc", request.getParameter("airDesc"));
		return this.giisVesselDAO.validateAirTypeCd(params);
	}

	public GIISVesselDAO getGiisVesselDAO() {
		return giisVesselDAO;
	}

	public void setGiisVesselDAO(GIISVesselDAO giisVesselDAO) {
		this.giisVesselDAO = giisVesselDAO;
	}
	
	@Override
	public JSONObject showGiiss050(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss050RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRecGiiss050(HttpServletRequest request) throws SQLException {
		if(request.getParameter("vesselCd") != null){
			String recId = request.getParameter("vesselCd");
			this.giisVesselDAO.valDeleteRecGiiss050(recId);
		}
	}

	@Override
	public void saveGiiss050(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISVessel.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISVessel.class));
		params.put("appUser", userId);
		this.giisVesselDAO.saveGiiss050(params);
	}

	@Override
	public void valAddRecGiiss050(HttpServletRequest request) throws SQLException {
		if(request.getParameter("vesselCd") != null){
			String recId = request.getParameter("vesselCd");
			giisVesselDAO.valAddRecGiiss050(recId);
		}
	}

	@Override
	public JSONObject showGiiss039(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss039RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}
	
	@Override
	public void valDeleteRecGiiss039(HttpServletRequest request) throws SQLException {
		if(request.getParameter("vesselCd") != null){
			String vesselCd = request.getParameter("vesselCd");
			this.giisVesselDAO.valDeleteRecGiiss039(vesselCd);
		}
	}

	@Override
	public void saveGiiss039(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISVessel.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISVessel.class));
		params.put("appUser", userId);
		this.giisVesselDAO.saveGiiss039(params);
	}

	@Override
	public void valAddRecGiiss039(HttpServletRequest request) throws SQLException {
		if(request.getParameter("vesselCd") != null){
			String vesselCd = request.getParameter("vesselCd");
			giisVesselDAO.valAddRecGiiss039(vesselCd);
		}
	}
}
