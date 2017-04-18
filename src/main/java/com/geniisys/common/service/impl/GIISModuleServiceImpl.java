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

import com.geniisys.common.dao.GIISModuleDAO;
import com.geniisys.common.entity.GIISModule;
import com.geniisys.common.service.GIISModuleService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;
//import com.sun.xml.internal.ws.api.ha.StickyFeature;


/**
 * The Class GIISModuleServiceImpl.
 */
public class GIISModuleServiceImpl implements GIISModuleService{

	/** The giis module dao. */
	private GIISModuleDAO giisModuleDAO;
	
	/**
	 * Gets the giis module dao.
	 * 
	 * @return the giis module dao
	 */
	public GIISModuleDAO getGiisModuleDAO() {
		return giisModuleDAO;
	}

	/**
	 * Sets the giis module dao.
	 * 
	 * @param giisModuleDAO the new giis module dao
	 */
	public void setGiisModuleDAO(GIISModuleDAO giisModuleDAO) {
		this.giisModuleDAO = giisModuleDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISModuleService#getModuleMenuList(java.lang.String)
	 */
	@Override
	public String getModuleMenuList(String userId) throws SQLException {
		List<GIISModule> modules = this.getGiisModuleDAO().getModuleMenuList(userId);
		StringBuffer commaDelimitedModules = new StringBuffer();
		for (GIISModule module: modules) {
			commaDelimitedModules.append(module.getModuleId()+",");
		}
		return commaDelimitedModules.toString();
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISModuleService#getGiisModulesList()
	 */
	@Override
	public List<GIISModule> getGiisModulesList() throws SQLException {
		return this.getGiisModuleDAO().getGiisModulesList();
	}

	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getCompleteModuleList(String keyword, int pageNo)
			throws SQLException {
		List<GIISModule> modules = this.getGiisModuleDAO().getCompleteModuleList(keyword);
		PaginatedList result = new PaginatedList(modules, ApplicationWideParameters.PAGE_SIZE);
		result.gotoPage(pageNo);
		return result;
	}

	@Override
	public List<GIISModule> getModuleTranList(String moduleId)
			throws SQLException {
		return this.getGiisModuleDAO().getModuleTranList(moduleId);
	}

	@Override
	public void setGiisModule(GIISModule module) throws SQLException {
		this.getGiisModuleDAO().setGiisModule(module);
	}

	@Override
	public GIISModule getGiisModule(String moduleId) throws SQLException {
		return this.getGiisModuleDAO().getGiisModule(moduleId);
	}

	@Override
	public void updateGiisModule(GIISModule module) throws SQLException {
		this.getGiisModuleDAO().updateGiisModule(module);
	}

	@Override
	public JSONObject showGiiss081(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss081RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("moduleId") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("moduleId", request.getParameter("moduleId"));
			this.giisModuleDAO.valDeleteRec(params);
		}
	}

	@Override
	public void saveGiiss081(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISModule.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISModule.class));
		params.put("appUser", userId);
		this.giisModuleDAO.saveGiiss081(params);
	}

	@Override
	public JSONObject showGeniisysModuleTran(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGeniisysModuleTranRecList");	
		params.put("moduleId", request.getParameter("moduleId"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}

	@Override
	public void valDeleteTranRec(HttpServletRequest request)
			throws SQLException {
		if(request.getParameter("tranCd") != null || request.getParameter("moduleId") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("moduleId", request.getParameter("moduleId"));
			params.put("tranCd", request.getParameter("tranCd"));
			this.giisModuleDAO.valDeleteTranRec(params);
		}
	}

	@Override
	public void saveGeniisysModuleTran(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISModule.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISModule.class));
		params.put("appUser", userId);
		this.giisModuleDAO.saveGeniisysModuleTran(params);
	}

	@Override
	public JSONObject showGeniisysUsersWAccess(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiisUserModulesRecList");	
		params.put("moduleId", request.getParameter("moduleId"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}

	@Override
	public JSONObject showGeniisysUserGrpWAccess(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiisUserGrpModulesRecList");	
		params.put("moduleId", request.getParameter("moduleId"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}

	@Override
	public JSONObject queryGiisUsers(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiisUsersRecList");	
		params.put("userGrp", request.getParameter("userGrp"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("moduleId") != null || request.getParameter("moduleDesc") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("moduleId", request.getParameter("moduleId"));
			params.put("moduleDesc", request.getParameter("moduleDesc"));
			this.giisModuleDAO.valAddRec(params);
		}
	}

	@Override
	public void valAddTranRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("moduleId") != null || request.getParameter("txtTranCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("moduleId", request.getParameter("moduleId"));
			params.put("tranCd", request.getParameter("tranCd"));
			this.giisModuleDAO.valAddTranRec(params);
		}
	}

}