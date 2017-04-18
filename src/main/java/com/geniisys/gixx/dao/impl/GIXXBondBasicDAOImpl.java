package com.geniisys.gixx.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gixx.dao.GIXXBondBasicDAO;
import com.geniisys.gixx.entity.GIXXBondBasic;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIXXBondBasicDAOImpl implements GIXXBondBasicDAO{

	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIXXBondBasicDAOImpl.class);
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	
	@Override
	public GIXXBondBasic getGIXXBondBasicInfo(Map<String, Object> params) throws SQLException {
		log.info("Retrieving bond basic information...");
		return (GIXXBondBasic) this.getSqlMapClient().queryForObject("getGIXXBondBasic", params);
	}
	
	
}
