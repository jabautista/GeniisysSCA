package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.dao.GIISLossCtgryDAO;
import com.geniisys.common.entity.GIISLossCtgry;
import com.geniisys.common.entity.GIISLossCtgry;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISLossCtgryDAOImpl implements GIISLossCtgryDAO{
	/** The log. */
	private Logger log = Logger.getLogger(GIISLossCtgryDAOImpl.class);
	
	/** The sql map client. */
	private SqlMapClient sqlMapClient;
		
	/**
	 * Gets the sql map client.
	 * 
	 * @return the sql map client
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/**
	 * Sets the sql map client.
	 * 
	 * @param sqlMapClient the new sql map client
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISLossCtgryDAO#getLossDtls(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getLossDtls(Map<String, Object> params) throws SQLException {
		log.info("get loss details");
		return this.getSqlMapClient().queryForList("getLossCatDtl", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> fetchCorrespondingNatureOfLossBasedOnLineCd(
			Map<String, Object> params) throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getLossCatCdDtlLOV2", params);
	}
	
	@SuppressWarnings("unchecked")
	public void saveGicls105(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISLossCtgry> delList = (List<GIISLossCtgry>) params.get("delRows");
			for(GIISLossCtgry d: delList){
				Map<String, Object> p = new HashMap<String, Object>();
				p.put("lineCd", d.getLineCd());
				p.put("lossCatCd", d.getLossCatCd());
				this.sqlMapClient.update("delLossCtgry", p);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISLossCtgry> setList = (List<GIISLossCtgry>) params.get("setRows");
			for(GIISLossCtgry s: setList){
				this.sqlMapClient.update("setLossCtgry", s);
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
	public void valDeleteRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDeleteLossCtgry", params);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddLossCtgry", params);		
	}

}
