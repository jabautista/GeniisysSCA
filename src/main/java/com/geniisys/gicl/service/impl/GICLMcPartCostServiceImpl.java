package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;


import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLMcPartCostDAO;
import com.geniisys.gicl.entity.GICLMcPartCost;
import com.geniisys.gicl.service.GICLMcPartCostService;

public class GICLMcPartCostServiceImpl implements GICLMcPartCostService {
	
	private GICLMcPartCostDAO giclMcPartCostDAO;

	@Override
	public JSONObject showGicls058(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGicls058RecList");		
		params.put("carCompanyCd", request.getParameter("carCompanyCd"));
		params.put("makeCd", request.getParameter("makeCd"));
		params.put("modelYear", request.getParameter("modelYear"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		System.out.println(recList);
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("clauseType") != null){
			String recId = request.getParameter("clauseType");
			this.giclMcPartCostDAO.valDeleteRec(recId);
		}
	}

	@Override
	public void saveGicls058(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GICLMcPartCost.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GICLMcPartCost.class));
		params.put("appUser", userId);
		this.giclMcPartCostDAO.saveGicls058(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("carCompanyCd", request.getParameter("carCompanyCd").equals("")?null:Integer.parseInt(request.getParameter("carCompanyCd")));
		params.put("makeCd", request.getParameter("makeCd").equals("")?null:Integer.parseInt(request.getParameter("makeCd")));
		params.put("modelYear", request.getParameter("modelYear"));
		this.giclMcPartCostDAO.valAddRec(params);
	}

	public GICLMcPartCostDAO getGiclMcPartCostDAO() {
		return giclMcPartCostDAO;
	}

	public void setGiclMcPartCostDAO(GICLMcPartCostDAO giclMcPartCostDAO) {
		this.giclMcPartCostDAO = giclMcPartCostDAO;
	}

	@Override
	public JSONObject showGicls058History(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGicls058HistoryRecList");		
		params.put("partCostId", request.getParameter("partCostId").equals("")?null:Integer.parseInt(request.getParameter("partCostId")));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}

	@Override
	public String valModelYear(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("carCompanyCd", request.getParameter("carCompanyCd").equals("")?null:Integer.parseInt(request.getParameter("carCompanyCd")));
		params.put("makeCd", request.getParameter("makeCd").equals("")?null:Integer.parseInt(request.getParameter("makeCd")));
		return this.giclMcPartCostDAO.checkModelYear(params);
	}
	
}
