package com.geniisys.gixx.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gixx.dao.GIXXFireItemDAO;
import com.geniisys.gixx.entity.GIXXFireItem;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIXXFireItemDAOImpl implements GIXXFireItemDAO{
	
	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIXXFireItemDAOImpl.class);

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public GIXXFireItem getGIXXFireItemInfo(Map<String, Object> params)	throws SQLException {
		log.info("Retrieving Fire Item information...");
		return (GIXXFireItem) this.getSqlMapClient().queryForObject("getGIXXFireItemInfo", params);
	}
	
	

}
