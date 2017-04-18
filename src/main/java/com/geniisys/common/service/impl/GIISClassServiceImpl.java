package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISClassDAO;
import com.geniisys.common.entity.GIISClass;
import com.geniisys.common.service.GIISClassService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISClassServiceImpl implements GIISClassService {
	
	private GIISClassDAO giisClassDAO;

	@Override
	public JSONObject showGiiss063(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss063RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("classCd") != null){
			String recId = request.getParameter("classCd");
			this.giisClassDAO.valDeleteRec(recId);
		}
	}

	@Override
	public void saveGiiss063(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISClass.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISClass.class));
		params.put("appUser", userId);
		this.giisClassDAO.saveGiiss063(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("classCd") != null){
			String recId = request.getParameter("classCd");
			this.giisClassDAO.valAddRec(recId);
		}
	}
	
	@Override
	public void valAddRec2(HttpServletRequest request) throws SQLException {
		if(request.getParameter("classDesc") != null){
			String recDesc = request.getParameter("classDesc");
			this.giisClassDAO.valAddRec2(recDesc);
		}
		
	}

	public GIISClassDAO getGiisClassDAO() {
		return giisClassDAO;
	}

	public void setGiisClassDAO(GIISClassDAO giisClassDAO) {
		this.giisClassDAO = giisClassDAO;
	}
}
