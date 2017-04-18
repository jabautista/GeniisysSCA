package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gicl.dao.GICLLossExpPayeesDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLLossExpPayeesDAOImpl implements GICLLossExpPayeesDAO{
	
	private SqlMapClient sqlMapClient;
	
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}


	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}


	@Override
	public Integer getPayeeClmClmntNo(Map<String, Object> params)
			throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("getPayeeClmClmntNo", params);
	}


	@Override
	public String validateAssdClassCd(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateAssdClassCd", params);
	}

}
