package com.geniisys.gism.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gism.dao.GISMRecipientGroupDAO;
import com.geniisys.gism.entity.GISMRecipientGroup;
import com.geniisys.gism.service.GISMRecipientGroupService;

public class GISMRecipientGroupServiceImpl implements GISMRecipientGroupService {
	
	private GISMRecipientGroupDAO gismRecipientGroupDAO;

	@Override
	public JSONObject showGisms003(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGisms003RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("groupCd") != null){
			String recId = request.getParameter("groupCd");
			this.gismRecipientGroupDAO.valDeleteRec(recId);
		}
	}

	@Override
	public void saveGisms003(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GISMRecipientGroup.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GISMRecipientGroup.class));
		params.put("appUser", userId);
		this.gismRecipientGroupDAO.saveGisms003(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("groupCd") != null){
			String recId = request.getParameter("groupCd");
			this.gismRecipientGroupDAO.valAddRec(recId);
		}
	}

	public GISMRecipientGroupDAO getGismRecipientGroupDAO() {
		return gismRecipientGroupDAO;
	}

	public void setGismRecipientGroupDAO(GISMRecipientGroupDAO gismRecipientGroupDAO) {
		this.gismRecipientGroupDAO = gismRecipientGroupDAO;
	}

}
