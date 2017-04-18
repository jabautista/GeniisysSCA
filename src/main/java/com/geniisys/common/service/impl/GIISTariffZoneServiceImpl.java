package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.dao.GIISTariffZoneDAO;
import com.geniisys.common.entity.GIISTariffZone;
import com.geniisys.common.service.GIISTariffZoneService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISTariffZoneServiceImpl implements GIISTariffZoneService{
	
	private GIISTariffZoneDAO giisTariffZoneDAO;
	
	@Override
	public JSONObject showGiiss054(HttpServletRequest request, String userId)	
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss054RecList");	
		params.put("userId", userId);	
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);		
		return new JSONObject(recList);
	}
	
	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("tariffZone") != null){
			String recId = request.getParameter("tariffZone");
			this.giisTariffZoneDAO.valAddRec(recId);
		}		
	}
	
	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("tariffZone") != null){
			String recId = request.getParameter("tariffZone");
			this.giisTariffZoneDAO.valDeleteRec(recId);
		}
	}

	@Override
	public void saveGiiss054(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISTariffZone.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISTariffZone.class));
		params.put("appUser", userId);
		this.giisTariffZoneDAO.saveGiiss054(params);
	}

	public GIISTariffZoneDAO getGiisTariffZoneDAO() {
		return giisTariffZoneDAO;
	}

	public void setGiisTariffZoneDAO(GIISTariffZoneDAO giisTariffZoneDAO) {
		this.giisTariffZoneDAO = giisTariffZoneDAO;
	}

	@Override
	public Integer checkGiiss054UserAccess(String userId) throws SQLException {
		return this.giisTariffZoneDAO.checkGiiss054UserAccess(userId);		 
	}
}
