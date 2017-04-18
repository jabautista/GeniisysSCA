package com.geniisys.gipi.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.dao.GIPIMortgageeDAO;
import com.geniisys.gipi.entity.GIPIMortgagee;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIMortgageeDAOImpl implements GIPIMortgageeDAO{
	
	private SqlMapClient sqlMapClient;

	/**
	 * 
	 * @return
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/**
	 * 
	 * @param sqlMapClient
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIMortgageeDAO#getMortgageeList(java.util.HashMap)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIMortgagee> getMortgageeList(HashMap<String, Object> params)throws SQLException {
		return this.getSqlMapClient().queryForList("getMortgageeList", params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIMortgageeDAO#getItemMortgagees(java.util.HashMap)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIMortgagee> getItemMortgagees(HashMap<String, Object> params) throws SQLException {
		//return this.getSqlMapClient().queryForList("getItemMortgagees",params);
		return this.getSqlMapClient().queryForList("getGIPIS100Mortgagees",params);
	}

	//kenneth SR 5483 05.26.2016
	@Override
	public BigDecimal getPerItemAmount(Map<String, Object> params) throws SQLException {
		return (BigDecimal) this.getSqlMapClient().queryForObject("getPerItemAmount", params);
	}
	//kenneth SR 5483 05.26.2016
	@Override
	public String getPerItemMortgName(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getPerItemMortgName", params);
	}

	
}
