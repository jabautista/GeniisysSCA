package com.geniisys.gixx.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gixx.dao.GIXXMainCoInsDAO;
import com.geniisys.gixx.entity.GIXXMainCoIns;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIXXMainCoInsDAOImpl implements GIXXMainCoInsDAO{

	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIXXMainCoInsDAOImpl.class);
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	
	@Override
	public GIXXMainCoIns getGIXXMainCoInsInfo(Map<String, Object> params) throws SQLException {
		log.info("Retrieving Main Co-Ins information...");
		return (GIXXMainCoIns) this.getSqlMapClient().queryForObject("getGIXXMainCoInsInfo", params);
	}

	
}
