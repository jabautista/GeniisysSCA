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

import com.geniisys.common.entity.GIISModule;


/**
 * The Interface GIISModuleDAO.
 */
public interface GIISModuleDAO {

	/**
	 * Gets the module menu list.
	 * 
	 * @param userId the user id
	 * @return the module menu list
	 * @throws SQLException the sQL exception
	 */
	List<GIISModule> getModuleMenuList(String userId) throws SQLException;
	
	/**
	 * Gets the giis modules list.
	 * 
	 * @return the giis modules list
	 * @throws SQLException the sQL exception
	 */
	List<GIISModule> getGiisModulesList() throws SQLException;
	
	List<GIISModule> getCompleteModuleList(String keyword) throws SQLException;
	
	List<GIISModule> getModuleTranList(String moduleId) throws SQLException;
	
	void setGiisModule(GIISModule module) throws SQLException;
	
	GIISModule getGiisModule(String moduleId) throws SQLException;
	
	void updateGiisModule(GIISModule module) throws SQLException;
	
	void valDeleteRec(Map<String, Object> params) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;
	void saveGiiss081(Map<String, Object> params) throws SQLException;
	
	void valDeleteTranRec(Map<String, Object> params) throws SQLException;
	void valAddTranRec(Map<String, Object> params) throws SQLException;
	void saveGeniisysModuleTran(Map<String, Object> params) throws SQLException;
}

