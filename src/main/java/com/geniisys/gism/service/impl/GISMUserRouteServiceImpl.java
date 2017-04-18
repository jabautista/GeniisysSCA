package com.geniisys.gism.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gism.dao.GISMUserRouteDAO;
import com.geniisys.gism.entity.GISMUserRoute;
import com.geniisys.gism.service.GISMUserRouteService;

public class GISMUserRouteServiceImpl implements GISMUserRouteService{
	
	private GISMUserRouteDAO gismUserRouteDAO;
	
	public GISMUserRouteDAO getGismUserRouteDAO() {
		return gismUserRouteDAO;
	}

	public void setGismUserRouteDAO(GISMUserRouteDAO gismUserRouteDAO) {
		this.gismUserRouteDAO = gismUserRouteDAO;
	}

	@Override
	public JSONObject showGisms010(HttpServletRequest request, String userId)	
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGisms010RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);		
		return new JSONObject(recList);
	}

	@Override
	public void saveGisms010(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GISMUserRoute.class));
		params.put("appUser", userId);
		this.gismUserRouteDAO.saveGisms010(params);
	}
}
