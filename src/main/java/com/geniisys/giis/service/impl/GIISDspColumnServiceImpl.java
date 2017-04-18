package com.geniisys.giis.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.giis.dao.GIISDspColumnDAO;
import com.geniisys.giis.entity.GIISDspColumn;
import com.geniisys.giis.service.GIISDspColumnService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISDspColumnServiceImpl implements GIISDspColumnService{
	
	private GIISDspColumnDAO giisDspColumnDAO;

	public GIISDspColumnDAO getGiisDspColumnDAO() {
		return giisDspColumnDAO;
	}

	public void setGiisDspColumnDAO(GIISDspColumnDAO giisDspColumnDAO) {
		this.giisDspColumnDAO = giisDspColumnDAO;
	}

	@Override
	public JSONObject showDisplayColumns(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiisDspColumnRecList");
		params.put("dspColId", request.getParameter("dspColId"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("dspColId") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("dspColId", request.getParameter("dspColId"));
			params.put("tableName", request.getParameter("tableName"));
			params.put("columnName", request.getParameter("columnName"));
			this.giisDspColumnDAO.valAddRec(params);
		}
	}

	@Override
	public void saveGiiss167(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISDspColumn.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISDspColumn.class));
		params.put("appUser", userId);
		this.giisDspColumnDAO.saveGiiss167(params);
	}
	
}
