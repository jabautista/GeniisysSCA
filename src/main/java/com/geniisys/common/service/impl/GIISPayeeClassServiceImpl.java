package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISPayeeClassDAO;
import com.geniisys.common.entity.GIISPayeeClass;
import com.geniisys.common.service.GIISPayeeClassService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISPayeeClassServiceImpl implements GIISPayeeClassService {
	
	private GIISPayeeClassDAO giisPayeeClassDAO;

	@Override
	public JSONObject showGicls140(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGicls140RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("payeeClassCd") != null){
			String recId = request.getParameter("payeeClassCd");
			this.giisPayeeClassDAO.valDeleteRec(recId);
		}
	}

	@Override
	public void saveGicls140(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISPayeeClass.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISPayeeClass.class));
		params.put("appUser", userId);
		this.giisPayeeClassDAO.saveGicls140(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("payeeClassCd") != null){
			String recId = request.getParameter("payeeClassCd");
			this.giisPayeeClassDAO.valAddRec(recId);
		}
	}

	public GIISPayeeClassDAO getGiisPayeeClassDAO() {
		return giisPayeeClassDAO;
	}

	public void setGiisPayeeClassDAO(GIISPayeeClassDAO giisPayeeClassDAO) {
		this.giisPayeeClassDAO = giisPayeeClassDAO;
	}
	
	

}
