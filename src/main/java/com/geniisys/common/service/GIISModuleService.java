/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.service;

import java.sql.SQLException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISModule;
import com.geniisys.framework.util.PaginatedList;


/**
 * The Interface GIISModuleService.
 */
public interface GIISModuleService {

	/**
	 * Gets the module menu list.
	 * 
	 * @param userId the user id
	 * @return the module menu list
	 * @throws SQLException the sQL exception
	 */
	String getModuleMenuList(String userId) throws SQLException;
	
	/**
	 * Gets the giis modules list.
	 * 
	 * @return the giis modules list
	 * @throws SQLException the sQL exception
	 */
	List<GIISModule> getGiisModulesList() throws SQLException;

	
	PaginatedList getCompleteModuleList(String keyword, int pageNo) throws SQLException;
	
	List<GIISModule> getModuleTranList(String moduleId) throws SQLException;
	
	void setGiisModule(GIISModule module) throws SQLException;
	
	GIISModule getGiisModule(String moduleId) throws SQLException;
	
	void updateGiisModule(GIISModule module) throws SQLException;
	
	JSONObject showGiiss081(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	void saveGiiss081(HttpServletRequest request, String userId) throws SQLException, JSONException;
	
	JSONObject showGeniisysModuleTran(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteTranRec(HttpServletRequest request) throws SQLException;
	void valAddTranRec(HttpServletRequest request) throws SQLException;
	void saveGeniisysModuleTran(HttpServletRequest request, String userId) throws SQLException, JSONException;
	
	JSONObject showGeniisysUsersWAccess(HttpServletRequest request, String userId) throws SQLException, JSONException;
	
	JSONObject showGeniisysUserGrpWAccess(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject queryGiisUsers(HttpServletRequest request, String userId) throws SQLException, JSONException;
}
