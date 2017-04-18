package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIACOrPrefDAO;
import com.geniisys.common.entity.GIACOrPref;
import com.geniisys.common.service.GIACOrPrefService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIACOrPrefServiceImpl implements GIACOrPrefService {
	
	private GIACOrPrefDAO giacOrPrefDAO;

	public GIACOrPrefDAO getGiacOrPrefDAO() {
		return giacOrPrefDAO;
	}

	public void setGiacOrPrefDAO(GIACOrPrefDAO giacOrPrefDAO) {
		this.giacOrPrefDAO = giacOrPrefDAO;
	}
	
	
	@Override
	public JSONObject showGiacs355(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs355RecList");
		params.put("userId", userId);
		params.put("moduleId", "GIACS355");
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("orPrefSuf", request.getParameter("orPrefSuf"));
		this.giacOrPrefDAO.valDeleteRec(params);
	}
	
	@Override
	public void saveGiacs355(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACOrPref.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACOrPref.class));
		params.put("appUser", userId);
		this.getGiacOrPrefDAO().saveGiacs355(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("orPrefSuf", request.getParameter("orPrefSuf"));
		this.giacOrPrefDAO.valAddRec(params);
	}

}
