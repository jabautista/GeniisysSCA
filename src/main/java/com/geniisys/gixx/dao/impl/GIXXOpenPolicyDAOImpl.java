package com.geniisys.gixx.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gixx.dao.GIXXOpenPolicyDAO;
import com.geniisys.gixx.entity.GIXXOpenPolicy;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIXXOpenPolicyDAOImpl implements GIXXOpenPolicyDAO {

	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIXXOpenPolicyDAOImpl.class);
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	
	@Override
	public GIXXOpenPolicy getGIXXOpenPolicy(Map<String, Object> params) throws SQLException {
		log.info("Retrieving Open Policy Information...");
		return (GIXXOpenPolicy) this.getSqlMapClient().queryForObject("getGIXXOpenPolicy", params);
	}
	
	
}
