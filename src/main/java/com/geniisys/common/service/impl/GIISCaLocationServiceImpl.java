package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.dao.GIISCaLocationDAO;
import com.geniisys.common.entity.GIISCaLocation;
import com.geniisys.common.service.GIISCaLocationService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISCaLocationServiceImpl implements GIISCaLocationService{
	private GIISCaLocationDAO giisCaLocationDAO;

	private Logger log = Logger.getLogger(GIISCaLocationServiceImpl.class);
	
	@Override
	public JSONObject showGiiss217(HttpServletRequest request, String userId)	
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss217RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);		
		return new JSONObject(recList);
	}	

	@Override
	public void saveGiiss217(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISCaLocation.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISCaLocation.class));
		params.put("appUser", userId);
		this.giisCaLocationDAO.saveGiiss217(params);
	}
	
	public GIISCaLocationDAO getGiisCaLocationDAO() {
		return giisCaLocationDAO;
	}

	public void setGiisCaLocationDAO(GIISCaLocationDAO giisCaLocationDAO) {
		this.giisCaLocationDAO = giisCaLocationDAO;
	}
}
