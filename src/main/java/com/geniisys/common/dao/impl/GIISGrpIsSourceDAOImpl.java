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

import com.geniisys.common.dao.GIISGrpIsSourceDAO;
import com.geniisys.common.entity.GIISGrpIsSource;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIISGrpIsSourceDAOImpl.
 */
public class GIISGrpIsSourceDAOImpl implements GIISGrpIsSourceDAO {

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
	 * @see com.geniisys.common.dao.GIISGrpIsSourceDAO#getGrpIsSourceAllList()
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISGrpIsSource> getGrpIsSourceAllList() throws SQLException {
		return this.getSqlMapClient().queryForList("getGrpIsSourceAllList");
	}

}
