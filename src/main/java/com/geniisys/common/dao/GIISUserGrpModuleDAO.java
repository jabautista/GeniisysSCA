/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.common.entity.GIISModule;
import com.geniisys.common.entity.GIISUserGrpModule;

/**
 * The Interface GIISUserGrpModuleDAO.
 */
public interface GIISUserGrpModuleDAO {

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
	void saveUserGrpModules(Map<String, Object> params) throws SQLException, JSONException;
	void checkUncheckModules(Map<String, Object> params) throws SQLException;
}
