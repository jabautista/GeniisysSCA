package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISEngPrincipalDAO;
import com.geniisys.common.entity.GIISEngPrincipal;
import com.geniisys.common.service.GIISEngPrincipalService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISEngPrincipalServiceImpl implements GIISEngPrincipalService {

	private GIISEngPrincipalDAO giisEngPrincipalDAO;
	
	public GIISEngPrincipalDAO getGiisEngPrincipalDAO() {
		return giisEngPrincipalDAO;
	}

	public void setGiisEngPrincipalDAO(GIISEngPrincipalDAO giisEngPrincipalDAO) {
		this.giisEngPrincipalDAO = giisEngPrincipalDAO;
	}

	@Override
	public JSONObject showGiiss068(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss068RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("principalCd", (request.getParameter("principalCd") != null && !request.getParameter("principalCd").equals("")) ? Integer.parseInt(request.getParameter("principalCd")) : null );
		this.giisEngPrincipalDAO.valDeleteRec(params);
	}

	@Override
	public void saveGiiss068(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISEngPrincipal.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISEngPrincipal.class));
		params.put("appUser", userId);
		this.giisEngPrincipalDAO.saveGiiss068(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("principalCd", (request.getParameter("principalCd") != null && !request.getParameter("principalCd").equals("")) ? Integer.parseInt(request.getParameter("principalCd")) : null );
		this.giisEngPrincipalDAO.valAddRec(params);
	}

}
