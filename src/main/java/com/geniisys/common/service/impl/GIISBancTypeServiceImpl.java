package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISBancTypeDAO;
import com.geniisys.common.entity.GIISBancType;
import com.geniisys.common.entity.GIISBancTypeDtl;
import com.geniisys.common.service.GIISBancTypeService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISBancTypeServiceImpl implements GIISBancTypeService{

	private GIISBancTypeDAO giisBancTypeDAO;

	public GIISBancTypeDAO getGiisBancTypeDAO() {
		return giisBancTypeDAO;
	}

	public void setGiisBancTypeDAO(GIISBancTypeDAO giisBancTypeDAO) {
		this.giisBancTypeDAO = giisBancTypeDAO;
	}

	@Override
	public JSONObject showGiiss218(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss218RecList");
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public JSONObject getBancTypeDtls(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getBancTypeDtls");
		params.put("bancTypeCd", request.getParameter("bancTypeCd"));
		params.put("bancTypeDtlTotal", this.getGiisBancTypeDAO().getBancTypeDtlTotal(params));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("bancTypeCd") != null){
			String bancTypeCd = request.getParameter("bancTypeCd");
			this.getGiisBancTypeDAO().valAddRec(bancTypeCd);
		}
	}
	
	@Override
	public void valAddDtl(HttpServletRequest request) throws SQLException {
		if(request.getParameter("bancTypeCd") != null && request.getParameter("itemNo") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("bancTypeCd", request.getParameter("bancTypeCd"));
			params.put("itemNo", request.getParameter("itemNo"));
			this.getGiisBancTypeDAO().valAddDtl(params);
		}
	}

	@Override
	public void saveGiiss218(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISBancType.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISBancType.class));
		params.put("setDtlRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setDtlRows")), userId, GIISBancTypeDtl.class));
		params.put("delDtlRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delDtlRows")), userId, GIISBancTypeDtl.class));
		params.put("appUser", userId);
		this.getGiisBancTypeDAO().saveGiiss218(params);
	}
	
}
