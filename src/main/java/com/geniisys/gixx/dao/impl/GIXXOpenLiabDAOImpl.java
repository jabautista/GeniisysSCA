package com.geniisys.gixx.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gixx.dao.GIXXOpenLiabDAO;
import com.geniisys.gixx.entity.GIXXOpenLiab;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIXXOpenLiabDAOImpl implements GIXXOpenLiabDAO{

	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIXXOpenLiabDAOImpl.class);
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	
	@Override
	public GIXXOpenLiab getGIXXOpenLianInfo(Map<String, Object> params) throws SQLException {
		log.info("Retrieving Open Liab information...");
		return (GIXXOpenLiab) this.getSqlMapClient().queryForObject("getGIXXOpenLiabInfo", params);
	}
	
	
	
}
