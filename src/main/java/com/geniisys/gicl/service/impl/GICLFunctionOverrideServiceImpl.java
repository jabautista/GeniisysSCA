package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLFunctionOverrideDAO;
import com.geniisys.gicl.service.GICLFunctionOverrideService;

public class GICLFunctionOverrideServiceImpl implements GICLFunctionOverrideService{

	private GICLFunctionOverrideDAO giclFunctionOverrideDAO;
	
	public GICLFunctionOverrideDAO getGiclFunctionOverrideDAO() {
		return giclFunctionOverrideDAO;
	}

	public void setGiclFunctionOverrideDAO(GICLFunctionOverrideDAO giclFunctionOverrideDAO) {
		this.giclFunctionOverrideDAO = giclFunctionOverrideDAO;
	}

	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLFunctionOverrideService#getGICLFunctionOverrideRecords(javax.servlet.http.HttpServletRequest, com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public JSONObject getGICLFunctionOverrideRecords(HttpServletRequest request, GIISUser user, String ACTION) 
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", ACTION);
		params.put("appUser", user.getUserId());
		params.put("moduleId",	request.getParameter("moduleId") == null ? 0 : request.getParameter("moduleId"));
		params.put("functionCd", request.getParameter("functionCd"));
		
		Map<String, Object> functionOverrideRec = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(functionOverrideRec);
		
		return json;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLFunctionOverrideService#updateFunctionOverride(java.util.Map)
	 */
	@Override
	public void updateFunctionOverride(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		System.out.println(request.getParameter("functions"));
		params.put("functions", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("functions"))));
		params.put("approveRecFlg", request.getParameter("approveRecFlg"));
		params.put("userId", userId);
		System.out.println("Update GICLS183 params: "+params.toString());
		
		this.getGiclFunctionOverrideDAO().updateFunctionOverride(params);		
	}

}
