/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.common.dao.GIISUserModulesDAO;
import com.geniisys.common.entity.GIISUserModules;
import com.geniisys.common.service.GIISUserModulesService;


/**
 * The Class GIISUserModulesServiceImpl.
 */
public class GIISUserModulesServiceImpl implements GIISUserModulesService {

	/** The giis user modules dao. */
	private GIISUserModulesDAO giisUserModulesDAO;
	
	/**
	 * Gets the giis user modules dao.
	 * 
	 * @return the giis user modules dao
	 */
	public GIISUserModulesDAO getGiisUserModulesDAO() {
		return giisUserModulesDAO;
	}

	/**
	 * Sets the giis user modules dao.
	 * 
	 * @param giisUserModulesDAO the new giis user modules dao
	 */
	public void setGiisUserModulesDAO(GIISUserModulesDAO giisUserModulesDAO) {
		this.giisUserModulesDAO = giisUserModulesDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserModulesService#getGiisUserModulesList(java.lang.String)
	 */
	@Override
	public StringBuffer getGiisUserModulesList(String userID)
			throws SQLException {
		StringBuffer modules = new StringBuffer();
		for (GIISUserModules m: this.getGiisUserModulesDAO().getGiisUserModulesList(userID)) {
			modules.append(m.getModuleId()+",");
		}
		return modules;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserModulesService#getGiisUserModulesTranList(java.lang.String)
	 */
	@Override
	public List<GIISUserModules> getGiisUserModulesTranList(String userID) throws SQLException {
		return this.getGiisUserModulesDAO().getGiisUserModulesTranList(userID);
	}

	@Override
	public List<GIISUserModules> getModuleUsers(String moduleId)
			throws SQLException {
		return this.getGiisUserModulesDAO().getModuleUsers(moduleId);
	}

}
