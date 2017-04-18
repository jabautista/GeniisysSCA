package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACChartOfAcctsDAO;
import com.geniisys.giac.entity.GIACChartOfAccts;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACChartOfAcctsDAOImpl implements GIACChartOfAcctsDAO{

	private static Logger log = Logger.getLogger(GIACChartOfAcctsDAOImpl.class);
	
	private SqlMapClient sqlMapClient;
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACChartOfAcctsDAO#getAccountCodeDtls(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIACChartOfAccts> getAccountCodeDtls(Map<String, Object> params) throws SQLException {
		log.info("getAccountCodeDtls");
		return sqlMapClient.queryForList("getGlAcctListing4", params);
	}

	/**
	 * @return the sqlMapClient
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/**
	 * @param sqlMapClient the sqlMapClient to set
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACChartOfAcctsDAO#getAccountCodeDtls2(java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIACChartOfAccts> getAccountCodeDtls2(String keyword) throws SQLException {
		return sqlMapClient.queryForList("searchGlAcctListing", keyword);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACChartOfAcctsDAO#getAllChartOfAccts()
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIACChartOfAccts> getAllChartOfAccts() throws SQLException {
		log.info("Getting all chart of accounts...");
		return this.getSqlMapClient().queryForList("getGlAcctListing2", "");
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIACChartOfAccts> getAccountCodes(Map<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getGlAcctListing4", params);
	}
	
	@Override
	public String checkGiacs311UserFunction(String userId) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkGiacs311UserFunction", userId);
	}
	
	@Override
	public Map<String, Object> getChildChartOfAccts(Map<String, Object> params) throws SQLException {
		List<?> list = this.getSqlMapClient().queryForList("getChildRecList", params);
		params.put("list", list);
		return params;
	}
	
	@Override
	public String getGlMotherAcct(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getGlMotherAcct", params);
	}
	
	@Override
	public String getIncrementedLevel(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getIncrementedLevel", params);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiacs311(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACChartOfAccts> delList = (List<GIACChartOfAccts>) params.get("delRows");
			for(GIACChartOfAccts d: delList){
				this.sqlMapClient.update("delChartOfAccts", d.getGlAcctId());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACChartOfAccts> setList = (List<GIACChartOfAccts>) params.get("setRows");
			for(GIACChartOfAccts s: setList){
				this.sqlMapClient.update("setChartOfAccts", s);
			}
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}

	@Override
	public void valUpdateRec(String recId) throws SQLException {
		this.sqlMapClient.update("valUpdateChartOfAccts", recId);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddChartOfAccts", params);		
	}

	@Override
	public void valDelRec(String recId) throws SQLException {
		this.sqlMapClient.update("valDelChartOfAccts", recId);		
	}
	
}
