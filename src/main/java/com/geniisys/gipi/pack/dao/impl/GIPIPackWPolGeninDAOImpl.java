package com.geniisys.gipi.pack.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gipi.pack.dao.GIPIPackWPolGeninDAO;
import com.geniisys.gipi.pack.entity.GIPIPackWPolGenin;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIPackWPolGeninDAOImpl implements GIPIPackWPolGeninDAO {
	
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

	@Override
	public GIPIPackWPolGenin getGipiPackWPolGenin(Integer packParId)
			throws SQLException {
		return (GIPIPackWPolGenin) this.getSqlMapClient().queryForObject("getGipiPackWPolGenin", packParId);
	}

	@Override
	public void copyPackWPolGeninGiuts008a(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().insert("copyPackWPolGeninGiuts008a", params);
	}
}
