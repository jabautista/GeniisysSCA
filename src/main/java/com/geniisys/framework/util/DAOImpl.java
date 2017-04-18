/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.framework.util
	File Name: DAOImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Mar 11, 2011
	Description: 
*/


package com.geniisys.framework.util;

import com.ibatis.sqlmap.client.SqlMapClient;

public class DAOImpl {
	private SqlMapClient sqlMapClient; 

	/**
	 * @param sqlMapClient the sqlMapClient to set
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/**
	 * @return the sqlMapClient
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
}
