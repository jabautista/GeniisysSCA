package com.geniisys.gicl.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gicl.dao.GICLLossRatioDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLLossRatioDAOImpl implements GICLLossRatioDAO{

	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public String validateAssdNoGicls204(BigDecimal assdNo) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateAssdNoGicls204", assdNo);
	}

	@Override
	public String validatePerilCdGicls204(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validatePerilCdGicls204", params);
	}

	@Override
	public Map<String, Object> extractGicls204(Map<String, Object> params) throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);					
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("extractGicls204", params);
			this.sqlMapClient.executeBatch();
			
			System.out.println("extractGicls204 params: "+params);
			this.sqlMapClient.getCurrentConnection().commit();
			//this.sqlMapClient.getCurrentConnection().rollback();
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}

	@Override
	public Map<String, Object> getDetailReportDate(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("getDetailReportDate", params);
		return params;
	}
}
