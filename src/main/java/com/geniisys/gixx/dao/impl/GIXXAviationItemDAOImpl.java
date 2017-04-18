package com.geniisys.gixx.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gixx.dao.GIXXAviationItemDAO;
import com.geniisys.gixx.entity.GIXXAviationItem;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIXXAviationItemDAOImpl implements GIXXAviationItemDAO{
	
	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIXXAviationItemDAOImpl.class);
	
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}


	@Override
	public GIXXAviationItem getGIXXAviationItemInfo(Map<String, Object> params)	throws SQLException {
		log.info("Retrieving aviation item information...");
		return (GIXXAviationItem) this.getSqlMapClient().queryForObject("getGIXXAviationItemInfo", params);
	}

}
