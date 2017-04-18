package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISMCCarCompany;
import com.geniisys.common.service.GIISMcCarCompanyService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giis.dao.GIISMcCarCompanyDAO;

public class GIISMcCarCompanyServiceImpl implements GIISMcCarCompanyService{

	private GIISMcCarCompanyDAO giisMcCarCompanyDAO;

	@Override
	public JSONObject showGiiss115(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss115RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}
	@Override
	public void valAddRec(HttpServletRequest request) // carlo  - 08052015 - SR 19241
			throws SQLException, JSONException  {		
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("ACTION", "valAddRec");
		params.put("carCompany", request.getParameter("carCompany"));
		params.put("carCompanyCd",request.getParameter("carCompanyCd"));
		params.put("pAction", request.getParameter("pAction"));
			this.giisMcCarCompanyDAO.valAddRec(params);
		}
	
	

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("carCompanyCd") != null && request.getParameter("carCompanyCd") != ""){
			Integer carCompanyCd = Integer.parseInt(request.getParameter("carCompanyCd"));
			this.giisMcCarCompanyDAO.valDeleteRec(carCompanyCd);
		}
	}

	@Override
	public void saveGiiss115(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISMCCarCompany.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISMCCarCompany.class));
		params.put("appUser", userId);
		this.giisMcCarCompanyDAO.saveGiiss115(params);
	}


	

	public GIISMcCarCompanyDAO getGiisMcCarCompanyDAO() {
		return giisMcCarCompanyDAO;
	}

	public void setGiisMcCarCompanyDAO(GIISMcCarCompanyDAO giisMcCarCompanyDAO) {
		this.giisMcCarCompanyDAO = giisMcCarCompanyDAO;
	}
	
}
