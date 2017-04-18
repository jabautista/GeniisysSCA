package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISTrtyPanelDAO;
import com.geniisys.common.entity.GIISTrtyPanel;
import com.geniisys.common.service.GIISTrtyPanelService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISTrtyPanelServiceImpl implements GIISTrtyPanelService {
	
	private GIISTrtyPanelDAO giisTrtyPanelDAO;

	@Override
	public JSONObject showGiiss031(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss031RecList");
		params.put("lineCd", request.getParameter("lineCd"));		
		params.put("trtyYy", request.getParameter("trtyYy"));
		params.put("shareCd", request.getParameter("shareCd"));	
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}

	public GIISTrtyPanelDAO getGiisTrtyPanelDAO() {
		return giisTrtyPanelDAO;
	}

	public void setGiisTrtyPanelDAO(GIISTrtyPanelDAO giisTrtyPanelDAO) {
		this.giisTrtyPanelDAO = giisTrtyPanelDAO;
	}

	@Override
	public void saveGiiss031(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		Map<String, Object> paramsRecompute = new HashMap<String, Object>();
		paramsRecompute.put("newTrtyLimit", request.getParameter("newTrtyLimit"));
		paramsRecompute.put("lineCd", request.getParameter("lineCd"));
		paramsRecompute.put("trtyYy", request.getParameter("trtyYy"));
		paramsRecompute.put("trtySeqNo", request.getParameter("trtySeqNo"));
		params.put("recompute", request.getParameter("recompute"));
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISTrtyPanel.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISTrtyPanel.class));
		params.put("appUser", userId);
		this.giisTrtyPanelDAO.saveGiiss031(params, paramsRecompute);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("riCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("lineCd", request.getParameter("lineCd"));		
			params.put("trtyYy", request.getParameter("trtyYy"));
			params.put("trtySeqNo", request.getParameter("trtySeqNo"));
			params.put("riCd", request.getParameter("riCd"));
			this.giisTrtyPanelDAO.valAddRec(params);
		}
	}
	
	public Map<String, Object> validateGiiss031Reinsurer(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("riSname", request.getParameter("riSname"));
		return giisTrtyPanelDAO.validateGiiss031Reinsurer(params);
	}
	
	public Map<String, Object> validateGiiss031ParentRi(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("prntSname", request.getParameter("prntSname"));
		return giisTrtyPanelDAO.validateGiiss031ParentRi(params);
	}
	
	public JSONObject showGiiss031AllRec(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss031AllRecList");
		params.put("lineCd", request.getParameter("lineCd"));		
		params.put("trtyYy", request.getParameter("trtyYy"));
		params.put("shareCd", request.getParameter("shareCd"));	
		
		params.put("pageSize", 100);
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}
	
	@Override
	public void valAddNpRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		if(request.getParameter("layerNo") != null){
			params.put("xolId", request.getParameter("xolId"));		
			params.put("layerNo", request.getParameter("layerNo"));
			this.giisTrtyPanelDAO.valAddNpRec(params);
		}
	}
	
	@Override
	public void saveGiiss031Np(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISTrtyPanel.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISTrtyPanel.class));
		params.put("appUser", userId);
		this.giisTrtyPanelDAO.saveGiiss031Np(params);
	}
	
	public void valDeleteRec(HttpServletRequest request) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		if(request.getParameter("riCd") != null){
			params.put("riCd", request.getParameter("riCd"));		
			params.put("lineCd", request.getParameter("lineCd"));
			params.put("trtySeqNo", request.getParameter("trtySeqNo"));
			params.put("trtyYy", request.getParameter("trtyYy"));	
			giisTrtyPanelDAO.valDeleteRec(params);
		}
	}

}
