/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.dao.impl;

import java.sql.SQLException;

import com.geniisys.common.dao.GIISValidIPDAO;
import com.geniisys.common.entity.GIISValidIP;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIISValidIPDAOImpl.
 */
public class GIISValidIPDAOImpl implements GIISValidIPDAO {

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
	 * @see com.geniisys.common.dao.GIISValidIPDAO#getValidUser(java.lang.String)
	 */
	@Override
	public GIISValidIP getValidUser(String ipAddress) throws SQLException {
		return (GIISValidIP) getSqlMapClient().queryForObject("getValidUser", ipAddress);
	}

	@Override
	public GIISValidIP getValidUserByMacAddress(String macAddress) throws SQLException {
		return (GIISValidIP) getSqlMapClient().queryForObject("getValidUserByMacAddress", macAddress);
	}

}
