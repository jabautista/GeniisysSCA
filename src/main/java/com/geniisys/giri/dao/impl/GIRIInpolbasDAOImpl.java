package com.geniisys.giri.dao.impl;

import com.geniisys.giri.dao.GIRIInpolbasDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIRIInpolbasDAOImpl implements GIRIInpolbasDAO{
	
	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
}
