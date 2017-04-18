package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISTypeOfBodyDAO;
import com.geniisys.common.entity.GIISTypeOfBody;
import com.geniisys.common.service.GIISTypeOfBodyService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISTypeOfBodyServiceImpl implements GIISTypeOfBodyService {
	
	private GIISTypeOfBodyDAO giisTypeOfBodyDAO;

	@Override
	public JSONObject showGiiss117(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss117RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}

	@Override
	public String valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("typeOfBodyCd") != null){
			String typeOfBodyCd = request.getParameter("typeOfBodyCd");
			return this.giisTypeOfBodyDAO.valDeleteRec(typeOfBodyCd);
		} else {
			return null;
		}
		
	}

	@Override
	public void saveGiiss117(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISTypeOfBody.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISTypeOfBody.class));
		params.put("appUser", userId);
		this.giisTypeOfBodyDAO.saveGiiss117(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("typeOfBodyCd") != null){
			String recId = request.getParameter("typeOfBodyCd");
			this.giisTypeOfBodyDAO.valAddRec(recId);
		}
	}

	public GIISTypeOfBodyDAO getGiisTypeOfBodyDAO() {
		return giisTypeOfBodyDAO;
	}

	public void setGiisTypeOfBodyDAO(GIISTypeOfBodyDAO giisTypeOfBodyDAO) {
		this.giisTypeOfBodyDAO = giisTypeOfBodyDAO;
	}
}
