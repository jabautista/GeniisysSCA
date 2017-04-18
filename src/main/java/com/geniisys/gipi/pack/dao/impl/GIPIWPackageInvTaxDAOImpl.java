package com.geniisys.gipi.pack.dao.impl;

import com.geniisys.gipi.pack.dao.GIPIWPackageInvTaxDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIWPackageInvTaxDAOImpl implements GIPIWPackageInvTaxDAO{
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}	
}
