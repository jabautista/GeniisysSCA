package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.dao.GIISCargoTypeDAO;
import com.geniisys.common.entity.GIISCargoType;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISCargoTypeService;
import com.geniisys.framework.util.JSONUtil;

public class GIISCargoTypeServiceImpl implements GIISCargoTypeService{


	private GIISCargoTypeDAO giisCargoTypeDAO;
	
	/**
	 * @return the giisCargoTypeDAO
	 */
	public GIISCargoTypeDAO getGiisCargoTypeDAO() {
		return giisCargoTypeDAO;
	}

	/**
	 * @param giisCargoTypeDAO the giisCargoTypeDAO to set
	 */
	public void setGiisCargoTypeDAO(GIISCargoTypeDAO giisCargoTypeDAO) {
		this.giisCargoTypeDAO = giisCargoTypeDAO;
	}
		
	@Override
	public JSONObject showCargoClass(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("ACTION", "showCargoClass");		
		return this.giisCargoTypeDAO.showCargoClass(request, params); 
	}
	
	@Override
	public JSONObject showCargoType(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("ACTION", "showCargoType");	
		params.put("cargoClassCd", request.getParameter("cargoClassCd"));
		return this.giisCargoTypeDAO.showCargoType(request, params); 
	}

	@Override
	public Map<String, Object> saveCargoType(String parameter,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		JSONObject objParameters = new JSONObject(parameter);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), USER.getUserId(), GIISCargoType.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")), USER.getUserId(), GIISCargoType.class));
		return this.giisCargoTypeDAO.saveCargoType(params);
	}	
	
	@Override
	public Map<String, Object> validateCargoType(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("cargoType", request.getParameter("cargoType"));			
		return this.giisCargoTypeDAO.validateCargoType(params);
	}

	@Override
	public Map<String, Object> chkDeleteGIISS008CargoType(
			HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();			
		params.put("cargoType", request.getParameter("cargoType"));
		return this.giisCargoTypeDAO.chkDeleteGIISS008CargoType(params);
	}
}
