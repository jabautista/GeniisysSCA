/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISUserGrpModuleDAO;
import com.geniisys.common.entity.GIISModule;
import com.geniisys.common.entity.GIISUserGrpModule;
import com.geniisys.common.service.GIISUserGrpModuleService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;


/**
 * The Class GIISUserGrpModuleServiceImpl.
 */
public class GIISUserGrpModuleServiceImpl implements GIISUserGrpModuleService {

	/** The giis user grp module dao. */
	private GIISUserGrpModuleDAO giisUserGrpModuleDAO;
	
	/**
	 * Sets the giis user grp module dao.
	 * 
	 * @param giisUserGrpModuleDAO the new giis user grp module dao
	 */
	public void setGiisUserGrpModuleDAO(GIISUserGrpModuleDAO giisUserGrpModuleDAO) {
		this.giisUserGrpModuleDAO = giisUserGrpModuleDAO;
	}

	/**
	 * Gets the giis user grp module dao.
	 * 
	 * @return the giis user grp module dao
	 */
	public GIISUserGrpModuleDAO getGiisUserGrpModuleDAO() {
		return giisUserGrpModuleDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserGrpModuleService#getGiisGrpModulesList(java.lang.String)
	 */
	@Override
	public List<GIISModule> getGiisGrpModulesList(String userGrp) throws SQLException {
		return this.getGiisUserGrpModuleDAO().getGiisGrpModulesList(userGrp);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserGrpModuleService#deleteGiisUserGrpModule(com.geniisys.common.entity.GIISUserGrpModule)
	 */
	@Override
	public void deleteGiisUserGrpModule(GIISUserGrpModule giisUserGrpModule) throws SQLException {
		this.getGiisUserGrpModuleDAO().deleteGiisUserGrpModule(giisUserGrpModule);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserGrpModuleService#setGiisUserGrpModule(com.geniisys.common.entity.GIISUserGrpModule)
	 */
	@Override
	public void setGiisUserGrpModule(GIISUserGrpModule giisUserGrpModule) throws SQLException {
		this.getGiisUserGrpModuleDAO().setGiisUserGrpModule(giisUserGrpModule);
	}

	@Override
	public List<GIISUserGrpModule> getModuleUserGrps(String moduleId)
			throws SQLException {
		return this.getGiisUserGrpModuleDAO().getModuleUserGrps(moduleId);
	}

	@Override
	public JSONObject getUserGrpModules(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getUserGrpModules");
		params.put("userGrp", request.getParameter("userGrp"));
		params.put("tranCd", request.getParameter("tranCd"));
		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}

	@Override
	public void saveUserGrpModules(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("modRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("modRows")), userId, GIISUserGrpModule.class));
		params.put("appUser", userId);
		this.getGiisUserGrpModuleDAO().saveUserGrpModules(params);
	}

	@Override
	public void checkUncheckModules(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userGrp", request.getParameter("userGrp"));
		params.put("tranCd", request.getParameter("tranCd"));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("moduleDesc", request.getParameter("moduleDesc"));
		params.put("check", request.getParameter("check"));
		params.put("userId", userId);
		this.getGiisUserGrpModuleDAO().checkUncheckModules(params);
	}
	
}
