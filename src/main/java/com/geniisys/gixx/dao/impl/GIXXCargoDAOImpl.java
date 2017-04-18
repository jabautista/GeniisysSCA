package com.geniisys.gixx.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gixx.dao.GIXXCargoDAO;
import com.geniisys.gixx.entity.GIXXCargo;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIXXCargoDAOImpl implements GIXXCargoDAO{

	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIXXCargoDAOImpl.class);
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	@Override
	public GIXXCargo getGIXXCargoInfo(Map<String, Object> params) throws SQLException {
		log.info("Retrieving cargo information...");
		return (GIXXCargo) this.getSqlMapClient().queryForObject("getGIXXCargoInfo", params);
	}
	
	
}
