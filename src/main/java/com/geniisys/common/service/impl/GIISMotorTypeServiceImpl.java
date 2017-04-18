package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.dao.GIISMotorTypeDAO;
import com.geniisys.common.entity.GIISLineSublineCoverages;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.GIISMotorType;
import com.geniisys.common.service.GIISMotorTypeService;
import com.geniisys.framework.util.JSONUtil;

public class GIISMotorTypeServiceImpl implements GIISMotorTypeService {


	private GIISMotorTypeDAO giisMotorTypeDAO;
	
	/**
	 * @return the giisMotorTypeDAO
	 */
	public GIISMotorTypeDAO getGiisMotorTypeDAO() {
		return giisMotorTypeDAO;
	}

	/**
	 * @param giisMotorTypeDAO the giisMotorTypeDAO to set
	 */
	public void setGiisMotorTypeDAO(GIISMotorTypeDAO giisMotorTypeDAO) {
		this.giisMotorTypeDAO = giisMotorTypeDAO;
	}
		
	@Override
	public JSONObject showSubline(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("ACTION", "getGIISS055Subline");	
		params.put("userId", USER.getUserId());
		return this.giisMotorTypeDAO.showSubline(request, params); 
	}

	

	@Override
	public JSONObject showMotorType(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("ACTION", "getMotorType");	
		params.put("sublineCd", request.getParameter("sublineCd"));
		return this.giisMotorTypeDAO.showMotorType(request, params); 
	}
	
	@Override
	public Map<String, Object> validateGIISS055MotorType(
			HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();			
		params.put("typeCd", request.getParameter("typeCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		return this.giisMotorTypeDAO.validateGIISS055MotorType(params);
	}
	
	@Override
	public Map<String, Object> chkDeleteGIISS055MotorType(
			HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();			
		params.put("typeCd", request.getParameter("typeCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		return this.giisMotorTypeDAO.chkDeleteGIISS055MotorType(params);
	}
	
	@Override
	public Map<String, Object> saveGiiss055(String parameter, GIISUser USER)
			throws SQLException, JSONException, ParseException {
		JSONObject objParameters = new JSONObject(parameter);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), USER.getUserId(), GIISMotorType.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")), USER.getUserId(), GIISMotorType.class));
		return this.giisMotorTypeDAO.saveGiiss055(params);
	}
}