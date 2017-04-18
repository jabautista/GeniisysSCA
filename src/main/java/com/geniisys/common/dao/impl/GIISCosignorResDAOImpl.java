/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.common.dao.impl
	File Name: GIISCosignorResDAOImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: May 25, 2011
	Description: 
*/


package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.common.dao.GIISCosignorResDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISCosignorResDAOImpl implements GIISCosignorResDAO{
	
	private SqlMapClient sqlMapClient;
	
//	@SuppressWarnings("unchecked")
//	public List<GIISCosignorRes> getCosignorRes(Map<String, Object> params)
//			throws SQLException {
//		log.info("GETTING COSIGNOR FOR ASSURED NO: "+params.get("assdNo"));
//		return 	this.getSqlMapClient().queryForList("getCosignorRes", params);
//	}

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

	@SuppressWarnings("unchecked")
	@Override
	public List<Integer> getCoSignatoryIDList(Integer assdNo)throws SQLException {
		return this.sqlMapClient.queryForList("getCoSignatoryIDList", assdNo);
	}

}
