package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISRiStatusDAO;
import com.geniisys.common.entity.GIISRiStatus;
import com.geniisys.common.service.GIISRiStatusService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISRiStatusServiceImpl implements GIISRiStatusService{

	private GIISRiStatusDAO giisRiStatusDAO;

	@Override
	public JSONObject showGiiss073(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss073RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("statusCd") != null){
			String recId = request.getParameter("statusCd");
			this.giisRiStatusDAO.valDeleteRec(recId);
		}
	}

	@Override
	public void saveGiiss073(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISRiStatus.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISRiStatus.class));
		params.put("appUser", userId);
		this.giisRiStatusDAO.saveGiiss073(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("statusCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("recId", (request.getParameter("statusCd") != null && !request.getParameter("statusCd").equals("")) ? Integer.parseInt(request.getParameter("statusCd")) : null);
			params.put("recDesc", request.getParameter("statusDesc"));
			this.giisRiStatusDAO.valAddRec(params);
		}
	}

	public GIISRiStatusDAO getGiisRiStatusDAO() {
		return giisRiStatusDAO;
	}

	public void setGiisRiStatusDAO(GIISRiStatusDAO giisRiStatusDAO) {
		this.giisRiStatusDAO = giisRiStatusDAO;
	}
}
