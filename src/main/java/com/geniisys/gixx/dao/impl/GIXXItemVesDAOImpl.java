package com.geniisys.gixx.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gixx.dao.GIXXItemVesDAO;
import com.geniisys.gixx.entity.GIXXItemVes;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIXXItemVesDAOImpl implements GIXXItemVesDAO {

	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIXXItemVesDAOImpl.class);
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	
	@Override
	public GIXXItemVes getGIXXItemVesInfo(Map<String, Object> params) throws SQLException {
		log.info("Retrieving Item Vessel Information...");
		return (GIXXItemVes) this.getSqlMapClient().queryForObject("getGIXXitemVesInfo", params);
	}
	
	
}
