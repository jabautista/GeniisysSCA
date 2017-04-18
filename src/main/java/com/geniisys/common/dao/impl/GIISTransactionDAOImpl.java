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

import com.geniisys.common.dao.GIISTransactionDAO;
import com.geniisys.common.entity.GIISTransaction;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIISTransactionDAOImpl.
 */
public class GIISTransactionDAOImpl implements GIISTransactionDAO {

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
	 * @see com.geniisys.common.dao.GIISTransactionDAO#getGiisTransactionList()
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISTransaction> getGiisTransactionList() throws SQLException {
		//return getSqlMapClient().queryForList("getGiisTransactionList");
		return getSqlMapClient().queryForList("getAllGiisTransactionList"); //testing by angelo to be confirmed
	}

}
