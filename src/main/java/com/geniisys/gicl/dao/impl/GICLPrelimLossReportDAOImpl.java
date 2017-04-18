package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.gicl.dao.GICLPrelimLossReportDAO;
import com.geniisys.gicl.entity.GICLClaims;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLPrelimLossReportDAOImpl implements GICLPrelimLossReportDAO{
	private SqlMapClient sqlMapClient;

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public GICLClaims getPrelimLossInfo(Integer claimId) throws SQLException {
		return (GICLClaims) this.getSqlMapClient().queryForObject("getPrelimLossInfo", claimId);
	}

	public GICLClaims getFinalLossInfo(Integer claimId) throws SQLException {
		return (GICLClaims) this.getSqlMapClient().queryForObject("getFinalLossInfo", claimId);
	}

	@SuppressWarnings("unchecked")
	public List<String> getAgentList(Integer claimId) throws SQLException {
		return this.getSqlMapClient().queryForList("getAgentList", claimId);
	}	
	@SuppressWarnings("unchecked")
	public List<String> getMortgageeList(Integer claimId) throws SQLException {
		return this.getSqlMapClient().queryForList("getClmMortgageeList", claimId);
	}

}
