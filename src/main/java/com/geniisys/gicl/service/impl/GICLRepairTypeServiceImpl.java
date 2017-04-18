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
import com.geniisys.gicl.dao.GICLRepairTypeDAO;
import com.geniisys.gicl.entity.GICLRepairType;
import com.geniisys.gicl.service.GICLRepairTypeService;

public class GICLRepairTypeServiceImpl implements GICLRepairTypeService {
	
	private GICLRepairTypeDAO giclRepairTypeDAO;

	@Override
	public JSONObject showGicls172(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGicls172RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void saveGicls172(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GICLRepairType.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GICLRepairType.class));
		params.put("appUser", userId);
		this.giclRepairTypeDAO.saveGicls172(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("repairCode") != null){
			String recId = request.getParameter("repairCode");
			this.giclRepairTypeDAO.valAddRec(recId);
		}
	}

	public GICLRepairTypeDAO getGiclRepairTypeDAO() {
		return giclRepairTypeDAO;
	}

	public void setGiclRepairTypeDAO(GICLRepairTypeDAO giclRepairTypeDAO) {
		this.giclRepairTypeDAO = giclRepairTypeDAO;
	}
	
	public void valDelRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("repairCode") != null){
			String recId = request.getParameter("repairCode");
			this.giclRepairTypeDAO.valDelRec(recId);
		}
	}

}
