/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	rencela
 * Create Date	:	Apr 13, 2012
 ***************************************************/
package com.geniisys.gicl.dao.impl;

import com.geniisys.gicl.dao.GICLReserveRidsDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLReserveRidsDAOImpl implements GICLReserveRidsDAO {
	private SqlMapClient sqlMapClient;

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
}
