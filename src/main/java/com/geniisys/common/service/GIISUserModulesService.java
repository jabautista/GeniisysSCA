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

import com.geniisys.common.entity.GIISUserModules;


/**
 * The Interface GIISUserModulesService.
 */
public interface GIISUserModulesService {

	/**
	 * Gets the giis user modules list.
	 * 
	 * @param userID the user id
	 * @return the giis user modules list
	 * @throws SQLException the sQL exception
	 */
	StringBuffer getGiisUserModulesList(String userID) throws SQLException;
	
	/**
	 * Gets the giis user modules tran list.
	 * 
	 * @param userID the user id
	 * @return the giis user modules tran list
	 * @throws SQLException the sQL exception
	 */
	List<GIISUserModules> getGiisUserModulesTranList(String userID) throws SQLException;

	List<GIISUserModules> getModuleUsers(String moduleId) throws SQLException;
}
