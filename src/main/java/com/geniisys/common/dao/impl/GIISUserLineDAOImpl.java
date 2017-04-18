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

import com.geniisys.common.dao.GIISUserLineDAO;
import com.geniisys.common.entity.GIISUserLine;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIISUserLineDAOImpl.
 */
public class GIISUserLineDAOImpl implements GIISUserLineDAO {

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
	 * @see com.geniisys.common.dao.GIISUserLineDAO#deleteGiisUserLine(java.lang.String)
	 */
	@Override
	public void deleteGiisUserLine(String userID) throws SQLException {
		this.getSqlMapClient().delete("deleteGiisUserLine", userID);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserLineDAO#getGiisUserLineList(java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISUserLine> getGiisUserLineList(String userID) throws SQLException {
		return this.getSqlMapClient().queryForList("getGiisUserLineList", userID);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserLineDAO#setGiisUserLine(com.geniisys.common.entity.GIISUserLine)
	 */
	@Override
	public void setGiisUserLine(GIISUserLine userLine) throws SQLException {
		this.getSqlMapClient().insert("setGiisUserLine", userLine);
	}

}
