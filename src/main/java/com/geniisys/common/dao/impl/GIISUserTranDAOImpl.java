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

import com.geniisys.common.dao.GIISUserTranDAO;
import com.geniisys.common.entity.GIISUserTran;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIISUserTranDAOImpl.
 */
public class GIISUserTranDAOImpl implements GIISUserTranDAO {

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
	 * @see com.geniisys.common.dao.GIISUserTranDAO#deleteGiisUserTran(java.lang.String)
	 */
	@Override
	public void deleteGiisUserTran(String userID) throws SQLException {
		this.getSqlMapClient().delete("deleteGiisUserTran", userID);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserTranDAO#getGiisUserTranList(java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISUserTran> getGiisUserTranList(String userID) throws SQLException {
		return this.getSqlMapClient().queryForList("getGiisUserTranList", userID);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserTranDAO#setGiisUserTran(com.geniisys.common.entity.GIISUserTran)
	 */
	@Override
	public void setGiisUserTran(GIISUserTran userTran) throws SQLException {
		this.getSqlMapClient().insert("setGiisUserTran", userTran);
	}

}
