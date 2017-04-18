package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISPolicyTypeDAO;
import com.geniisys.common.entity.GIISPolicyType;
import com.geniisys.common.service.GIISPolicyTypeService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISPolicyTypeServiceImpl implements GIISPolicyTypeService{
	
	private GIISPolicyTypeDAO giisPolicyTypeDAO;

	public GIISPolicyTypeDAO getGiisPolicyTypeDAO() {
		return giisPolicyTypeDAO;
	}

	public void setGiisPolicyTypeDAO(GIISPolicyTypeDAO giisPolicyTypeDAO) {
		this.giisPolicyTypeDAO = giisPolicyTypeDAO;
	}
	
	@Override
	public JSONObject showGiiss091(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss091RecList");
		params.put("userId", userId);
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("lineCd") != null && request.getParameter("typeCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("lineCd", request.getParameter("lineCd"));
			params.put("typeCd", request.getParameter("typeCd"));
			params.put("typeDesc", request.getParameter("typeDesc"));
			this.giisPolicyTypeDAO.valAddRec(params);
		}
	}

	@Override
	public void saveGiiss091(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISPolicyType.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISPolicyType.class));
		params.put("appUser", userId);
		System.out.println("Policy type save parameters : " + params);
		this.giisPolicyTypeDAO.saveGiiss091(params);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("lineCd") != null && request.getParameter("typeCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("lineCd", request.getParameter("lineCd"));
			params.put("typeCd", request.getParameter("typeCd"));
			this.giisPolicyTypeDAO.valDeleteRec(params);
		}
	}

	@Override
	public void valTypeDesc(HttpServletRequest request) throws SQLException {
		if(request.getParameter("typeDesc") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("typeDesc", request.getParameter("typeDesc"));
			this.giisPolicyTypeDAO.valTypeDesc(params);
		}
	}

	@Override
	public JSONObject getAllLineCdTypeCd(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getAllLineCdTypeCd");
		params.put("pageSize", 2000);
		Map<String, Object> allLineCdTypeCd = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonAllLineCdTypeCd = new JSONObject(allLineCdTypeCd);
		request.setAttribute("jsonAllLineCdTypeCd", jsonAllLineCdTypeCd);
		return jsonAllLineCdTypeCd;
	}

	@Override
	public JSONObject getAllTypeDesc(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getAllTypeDesc");
		params.put("pageSize", 2000);
		Map<String, Object> allTypeDesc = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonAllTypeDesc = new JSONObject(allTypeDesc);
		request.setAttribute("jsonAllLineCdTypeCd", jsonAllTypeDesc);
		return jsonAllTypeDesc;
	}
	
}
