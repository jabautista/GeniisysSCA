package com.geniisys.gicl.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gicl.dao.GICLBrdrxClmsRegisterDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLBrdrxClmsRegisterDAOImpl implements GICLBrdrxClmsRegisterDAO{

	private Logger log = Logger.getLogger(GICLBrdrxClmsRegisterDAOImpl.class);
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> whenNewFormInstanceGicls202() throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("whenNewFormInstanceGicls202");
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> whenNewBlockE010Gicls202(String userId) throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("whenNewBlockE010", userId);
	}
	
	@Override
	public Map<String, Object> getPolicyNumberGicls202(String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		this.getSqlMapClient().update("getPolicyNumberGicls202", params);
		return params;
	}

	@Override
	public Integer extractGicls202(HashMap<String, Object> params) throws SQLException {
		Integer count = 0;
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);					
			this.getSqlMapClient().startBatch();
			
			Integer sessionId = (Integer) this.getSqlMapClient().queryForObject("gicls202GetSessionId");
			params.put("sessionId", sessionId);
			
			this.getSqlMapClient().update("extractGicls202Web", params);
			this.sqlMapClient.executeBatch();
			
			count = (Integer) this.getSqlMapClient().queryForObject("gicls202GetExtractCount", sessionId);
			
			System.out.println("extractGicls202 count: "+count);
			this.sqlMapClient.getCurrentConnection().commit();		
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return count;
	}
	
	@Override
	public String validateLineCd2GIcls202(HashMap<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateLineCd2Gicls202", params);
	}

	@Override
	public String validateSublineCd2Gicls202(HashMap<String, Object> params) throws SQLException{
		return (String) this.getSqlMapClient().queryForObject("validateSublineCd2Gicls202", params);
	}
	
	@Override
	public String validateIssCd2Gicls202(HashMap<String, Object> params) throws SQLException{
		return (String) this.getSqlMapClient().queryForObject("validateIssCd2Gicls202", params);
	}

	@Override
	public String validateLineCdGicls202(String lineCd) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateLineCdGicls202", lineCd);
	}

	@Override
	public String validateSublineCdGicls202(HashMap<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateSublineCdGicls202", params);
	}

	@Override
	public String validateIssCdGicls202(String issCd) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateIssCdGicls202", issCd);
	}

	@Override
	public String validateLossCatCdGicls202(HashMap<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateLossCatCdGicls202", params);
	}

	@Override
	public String validatePerilCdGicls202(HashMap<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validatePerilCdGicls202", params);
	}

	@Override
	public String validateIntmNoGicls202(BigDecimal intmNo) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateIntmNoGicls202", intmNo);
	}
	
	@Override
	public String validateControlTypeCdGicls202(Integer controlTypeCd) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateControlTypeCdGicls202", controlTypeCd);
	}

	@Override
	public Map<String, Object> printGicls202(Integer repName, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("repName", repName);
		this.getSqlMapClient().update("printGicls202", params);
		return params;
	}
}
