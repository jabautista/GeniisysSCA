package com.geniisys.gicl.dao.impl;

import com.geniisys.gicl.dao.GICLLossRecoveryPaymentDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLLossRecoveryPaymentDAOImpl implements GICLLossRecoveryPaymentDAO{
private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
}
