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
import com.geniisys.common.entity.GIISUserGrpModule;


/**
 * The Interface GIISUserGrpModuleService.
 */
public interface GIISUserGrpModuleService {

	/**
	 * Gets the giis grp modules list.
	 * 
	 * @param userGrp the user grp
	 * @return the giis grp modules list
	 * @throws SQLException the sQL exception
	 */
	List<GIISModule> getGiisGrpModulesList(String userGrp) throws SQLException;
	
	/**
	 * Delete giis user grp module.
	 * 
	 * @param giisUserGrpModule the giis user grp module
	 * @throws SQLException the sQL exception
	 */
	void deleteGiisUserGrpModule(GIISUserGrpModule giisUserGrpModule) throws SQLException;
	
	/**
	 * Sets the giis user grp module.
	 * 
	 * @param giisUserGrpModule the new giis user grp module
	 * @throws SQLException the sQL exception
	 */
	void setGiisUserGrpModule(GIISUserGrpModule giisUserGrpModule) throws SQLException;
	
	List<GIISUserGrpModule> getModuleUserGrps(String moduleId) throws SQLException;
	
	JSONObject getUserGrpModules(HttpServletRequest request) throws SQLException, JSONException;
	void saveUserGrpModules(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void checkUncheckModules(HttpServletRequest request, String userId) throws SQLException;
}
