package com.geniisys.giri.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giri.dao.GIRIDistFrpsWdistFrpsVDAO;
import com.geniisys.giri.entity.GIRIDistFrpsWdistFrpsV;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIRIDistFrpsWdistFrpsVDAOImpl implements GIRIDistFrpsWdistFrpsVDAO{
	
	private Logger log = Logger.getLogger(GIRIDistFrpsDAOImpl.class);
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giri.dao.GIRIDistFrpsWdistFrpsVDAO#getWdistFrpsVDtls(java.util.Map)
	 */
	@Override
	public GIRIDistFrpsWdistFrpsV getWdistFrpsVDtls(Map<String, Object> params) throws SQLException{
		log.info("getWdistFrpsVDtls");
		return (GIRIDistFrpsWdistFrpsV) sqlMapClient.queryForObject("getWdistFrpsVDtls", params);
	}

}
