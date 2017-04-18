package com.geniisys.gicl.dao.impl;

import com.geniisys.gicl.dao.GICLLossRecoveryStatusDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLLossRecoveryStatusDAOImpl implements GICLLossRecoveryStatusDAO{
private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
}
