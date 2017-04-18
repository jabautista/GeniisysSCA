/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACModulesDAO;
import com.geniisys.giac.entity.GIACModules;
import com.geniisys.giac.service.GIACModulesService;

public class GIACModulesServiceImpl implements GIACModulesService{

	/** The gipi par item dao. */
	private GIACModulesDAO giacModulesDAO;
	
	/**
	 * Validate User Function
	 */
	@Override
	public String validateUserFunc(Map<String, Object> param) throws SQLException {
		// TODO Auto-generated method stub
		return giacModulesDAO.validateUserFunc(param);
	}

	/**
	 * @return the giacModulesDAO
	 */
	public GIACModulesDAO getGiacModulesDAO() {
		return giacModulesDAO;
	}

	/**
	 * @param giacModulesDAO the giacModulesDAO to set
	 */
	public void setGiacModulesDAO(GIACModulesDAO giacModulesDAO) {
		this.giacModulesDAO = giacModulesDAO;
	}

	@Override
	public String validateUserFunc2(Map<String, Object> params)
			throws SQLException {
		return giacModulesDAO.validateUserFunc2(params);
	}

	@Override
	public String validateUserFunc3(Map<String, Object> params)
			throws SQLException {
		return giacModulesDAO.validateUserFunc3(params);
	}
	
	@Override
	public JSONObject showGiacs317(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs317RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}

	@Override
	public String valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("moduleId") != null){
			Integer moduleId = Integer.parseInt(request.getParameter("moduleId"));
			return this.giacModulesDAO.valDeleteRec(moduleId);
		} else {
			return null;
		}
		
	}

	@Override
	public void saveGiacs317(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACModules.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACModules.class));
		params.put("appUser", userId);
		this.giacModulesDAO.saveGiacs317(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("moduleName") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("moduleName", request.getParameter("moduleName"));
			params.put("genType", request.getParameter("genType"));
			this.giacModulesDAO.valAddRec(params);
		}
	}
	
	public Map<String, Object> validateGiacs317ScreenRepTag(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("scrnRepTagName", request.getParameter("scrnRepTagName"));
		return this.giacModulesDAO.validateGiacs317ScreenRepTag(params);
	}
}
