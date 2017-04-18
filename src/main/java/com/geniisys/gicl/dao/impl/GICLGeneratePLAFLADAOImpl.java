package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gicl.dao.GICLGeneratePLAFLADAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLGeneratePLAFLADAOImpl implements GICLGeneratePLAFLADAO{

	private static Logger log = Logger.getLogger(GICLGeneratePLAFLADAOImpl.class);
	public SqlMapClient sqlMapClient;
	
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public Map<String, Object> queryCountUngenerated(Map<String, Object> params) throws SQLException {
		log.info("Querying count...");
		if(params.get("currentView").equals("P")){
			this.getSqlMapClient().queryForObject("queryCountUngenPLA", params);
		} else if(params.get("currentView").equals("F")){
			this.getSqlMapClient().queryForObject("queryCountUngenFLA", params);
		}		
		log.info("Count queried: "+params);
		return params;
	}

}
