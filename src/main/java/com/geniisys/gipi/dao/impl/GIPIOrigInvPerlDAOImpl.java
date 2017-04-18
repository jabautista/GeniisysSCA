package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIOrigInvPerlDAO;
import com.geniisys.gipi.entity.GIPIOrigInvPerl;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIOrigInvPerlDAOImpl implements GIPIOrigInvPerlDAO {

	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIOrigInvPerlDAOImpl.class);

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIOrigInvPerl> getGipiInvPerl(HashMap<String, Object> params)
			throws SQLException {
		log.info("Getting gipi_inv_perl_records...");
		List<GIPIOrigInvPerl> gipiOrigInvPerlList = this.getSqlMapClient().queryForList("getGipiOrigInvPerl", params);
		return gipiOrigInvPerlList;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<HashMap<String, Object>> getInvPerils(HashMap<String, Object> params) throws SQLException {
		return this.sqlMapClient.queryForList("getInvPerils",params);
	}

}
