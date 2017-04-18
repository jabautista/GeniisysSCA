package com.geniisys.gipi.pack.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.pack.dao.GIPIPackPolbasicDAO;
import com.geniisys.gipi.pack.entity.GIPIPackPolbasic;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIPackPolbasicDAOImpl implements GIPIPackPolbasicDAO {
	
	/** The SQL Map Client */
	private SqlMapClient sqlMapClient;

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPackPolbasic> getPolicyForPackEndt(
			Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getPolicyForPackEndt", params);
	}

	@Override
	public GIPIPackPolbasic getPackageBinders(Map<String, Object> params)
			throws SQLException {
		return (GIPIPackPolbasic) this.sqlMapClient.queryForObject("getPackageBindersLOV", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPackPolbasic> checkPackPolicyGiexs006(
			Map<String, Object> params) throws SQLException {
		return this.sqlMapClient.queryForList("checkPackPolicyGiexs006", params);
	}

	@Override
	public Map<String, Object> copyPackPolbasicGiuts008a(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().insert("copyPackPolbasicGiuts008a", params);
		return params;
	}

	@Override
	public String checkIfPackGIACS007(Map<String, Object> params)
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("checkIfPackGIACS007", params);
	}

	@Override
	public String checkIfBillsSettledGIACS007(Map<String, Object> params)
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("checkIfBillsSettledGIACS007", params);
	}

	@Override
	public String checkIfWithMc(Integer packParId) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("checkIfWithMc", packParId);
	}
}
