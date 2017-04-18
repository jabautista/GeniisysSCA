/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;

import org.jfree.util.Log;

import com.geniisys.gipi.dao.GIPIWPolGeninDAO;
import com.geniisys.gipi.entity.GIPIWPolGenin;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIWPolGeninDAOImpl.
 */
public class GIPIWPolGeninDAOImpl implements GIPIWPolGeninDAO {

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
	 * @see com.geniisys.gipi.dao.GIPIWPolGeninDAO#getGipiWPolGenin(int)
	 */
	@Override
	public GIPIWPolGenin getGipiWPolGenin(int parId) throws SQLException {
		Log.info("Getting record on gipi_wpolgenin ...");
		return (GIPIWPolGenin) this.getSqlMapClient().queryForObject("getGipiWPolGenin", parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolGeninDAO#saveGipiWPolGenin(com.geniisys.gipi.entity.GIPIWPolGenin)
	 */
	@Override
	public void saveGipiWPolGenin(GIPIWPolGenin gipiWPolGenin)
			throws SQLException {
		this.getSqlMapClient().insert("saveGipiWPolGenin", gipiWPolGenin);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolGeninDAO#deleteGipiWPolGenin(java.lang.Integer)
	 */
	@Override
	public void deleteGipiWPolGenin(Integer parId) throws SQLException {
		this.sqlMapClient.delete("deleteGipiWPolGenin", parId);
	}

	@Override
	public String getGenInfo(int parId) throws SQLException {		
		return (String) this.getSqlMapClient().queryForObject("getGenInfo", parId);
	}

}
