/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.common.dao.GIISUserModulesDAO;
import com.geniisys.common.entity.GIISUserModules;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIISUserModulesDAOImpl.
 */
public class GIISUserModulesDAOImpl implements GIISUserModulesDAO {

	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/**
	 * Gets the sql map client.
	 * 
	 * @return the sql map client
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/**
	 * Sets the sql map client.
	 * 
	 * @param sqlMapClient the new sql map client
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserModulesDAO#getGiisUserModulesList(java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISUserModules> getGiisUserModulesList(String userID)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getGiisUserModulesList", userID);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserModulesDAO#getGiisUserModulesTranList(java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISUserModules> getGiisUserModulesTranList(String userID) throws SQLException {
		return this.getSqlMapClient().queryForList("getGiisUserModulesTranList", userID);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIISUserModules> getModuleUsers(String moduleId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getModuleUsers", moduleId);
	}

}
