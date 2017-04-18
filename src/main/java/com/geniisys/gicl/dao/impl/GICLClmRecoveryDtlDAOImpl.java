package com.geniisys.gicl.dao.impl;

import com.geniisys.gicl.dao.GICLClmRecoveryDtlDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLClmRecoveryDtlDAOImpl implements GICLClmRecoveryDtlDAO{

	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	
}
