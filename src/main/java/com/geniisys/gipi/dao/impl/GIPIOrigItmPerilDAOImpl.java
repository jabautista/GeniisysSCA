package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIOrigItmPerilDAO;
import com.geniisys.gipi.entity.GIPIOrigItmPeril;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIOrigItmPerilDAOImpl implements GIPIOrigItmPerilDAO{
	
	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIOrigItmPerilDAOImpl.class);

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIOrigItmPeril> getGipiOrigItmPerils(HashMap<String, Object> params) 
			throws SQLException {
		log.info("Getting records from gipi_orig_itmperil for records:" + params.get("parId"));
		List<GIPIOrigItmPeril> origItmPerilList = this.getSqlMapClient().queryForList("getGipiOrigItmPeril", params);
		return origItmPerilList;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<HashMap<String, Object>> getOrigItmPerils(HashMap<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getOrigItmPerils",params);
	}

}
