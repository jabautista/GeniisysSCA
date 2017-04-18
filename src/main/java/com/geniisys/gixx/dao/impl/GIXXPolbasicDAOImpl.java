package com.geniisys.gixx.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gixx.dao.GIXXPolbasicDAO;
import com.geniisys.gixx.entity.GIXXPolbasic;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIXXPolbasicDAOImpl implements GIXXPolbasicDAO{
	
	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIXXPolbasicDAOImpl.class);
	

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public GIXXPolbasic getPolicySummary(Map<String, Object> params) throws SQLException {
		log.info("Retrieving policy summary...");
		/*Map<String, Object> params2 = new HashMap<String, Object>();
		params2 = (Map<String, Object>) this.getSqlMapClient().queryForObject("getPolicySummary", params);
		log.info("Retrieved policySummary [params2] :" + params2);*/
		return (GIXXPolbasic) this.getSqlMapClient().queryForObject("getPolicySummary", params);
		//return (Map<String, Object>) this.getSqlMapClient().queryForObject("getPolicySummary", params);
	}

	@Override
	public GIXXPolbasic getPolicySummarySu(Map<String, Object> params) throws SQLException {
		log.info("retrieving bond policy summary...");
		return (GIXXPolbasic) this.getSqlMapClient().queryForObject("getPolicySummarySu", params);
	}

	@Override
	public GIXXPolbasic getBondPolicyData(Map<String, Object> params) throws SQLException {
		log.info("retrieving bond policy details...");
		return (GIXXPolbasic) this.getSqlMapClient().queryForObject("getBondPolicyDtl", params);
	}

}
