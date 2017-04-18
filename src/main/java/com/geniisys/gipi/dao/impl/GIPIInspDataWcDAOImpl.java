package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.List;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIInspDataWcDAO;
import com.geniisys.gipi.entity.GIPIInspDataWc;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIInspDataWcDAOImpl implements GIPIInspDataWcDAO{
	
	private Logger log = Logger.getLogger(GIPIInspDataWcDAOImpl.class);

	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	public List<GIPIInspDataWc> getGipiInspDataWc(Integer inspNo) throws SQLException {
		log.info("getGipiInspDataWc");
		return this.getSqlMapClient().queryForList("getGipiInspDataWc", inspNo);
	}
}
