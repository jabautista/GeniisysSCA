package com.geniisys.gixx.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gixx.dao.GIXXCasualtyItemDAO;
import com.geniisys.gixx.entity.GIXXCasualtyItem;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIXXCasualtyItemDAOImpl implements GIXXCasualtyItemDAO{
	
	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIXXCasualtyItemDAOImpl.class);
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}


	@Override
	public GIXXCasualtyItem getGIXXCasualtyItemInfo(Map<String, Object> params) throws SQLException {
		log.info("Retrieving casualty item information...");
		return (GIXXCasualtyItem) this.getSqlMapClient().queryForObject("getGIXXCasualtyItemInfo", params);
	}

}
