/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.gipi.dao.GIPIMCErrorLogDAO;
import com.geniisys.gipi.entity.GIPIMCErrorLog;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIMCErrorLogDAOImpl.
 */
public class GIPIMCErrorLogDAOImpl implements GIPIMCErrorLogDAO {

	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIMCErrorLogDAO#getGipiMCErrorList(java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIMCErrorLog> getGipiMCErrorList(String fileName) throws SQLException {
		return this.getSqlMapClient().queryForList("getGipiMCErrorList", fileName);
	}

	/**
	 * Sets the sql map client.
	 * 
	 * @param sqlMapClient the new sql map client
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/**
	 * Gets the sql map client.
	 * 
	 * @return the sql map client
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	

}
