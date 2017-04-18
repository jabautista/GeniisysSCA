package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISTakeupTermDAO;
import com.geniisys.common.entity.GIISTakeupTerm;
import com.geniisys.common.service.GIISTakeupTermService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISTakeupTermServiceImpl implements GIISTakeupTermService{
	
	private GIISTakeupTermDAO giisTakeupTermDAO;
	

	public GIISTakeupTermDAO getGiisTakeupTermDAO() {
		return giisTakeupTermDAO;
	}

	public void setGiisTakeupTermDAO(GIISTakeupTermDAO giisTakeupTermDAO) {
		this.giisTakeupTermDAO = giisTakeupTermDAO;
	}

	@Override
	public JSONObject showGiiss211(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss211RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("takeupTerm") != null){
			String takeupTerm = request.getParameter("takeupTerm");
			this.giisTakeupTermDAO.valDeleteRec(takeupTerm);
		}
	}

	@Override
	public void saveGiiss211(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISTakeupTerm.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISTakeupTerm.class));
		params.put("appUser", userId);
		this.giisTakeupTermDAO.saveGiiss211(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("takeupTerm", request.getParameter("takeupTerm"));
		params.put("takeupTermDesc", request.getParameter("takeupTermDesc"));
		this.giisTakeupTermDAO.valAddRec(params);
	}

}
