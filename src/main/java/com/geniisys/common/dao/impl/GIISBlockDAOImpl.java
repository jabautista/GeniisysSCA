package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.dao.GIISBlockDAO;
import com.geniisys.common.entity.GIISBlock;
import com.geniisys.common.entity.GIISCoIntrmdryTypes;
import com.geniisys.common.entity.GIISRisks;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISBlockDAOImpl implements GIISBlockDAO{
	/** The log. */
	private Logger log = Logger.getLogger(GIISBlockDAOImpl.class);
	
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
	 * @see com.geniisys.common.dao.GIISBlockDAO#getDistrictLovGICLS010(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getDistrictLovGICLS010(
			Map<String, Object> params) throws SQLException {
		log.info("get district lov GICL");
		return this.getSqlMapClient().queryForList("getDistrictDtlLOV", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISBlockDAO#getBlockLovGICLS010(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getBlockLovGICLS010(
			Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getBlockDtlLOV", params);
	}
	
	@Override
	public void valDeleteRecRisk(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDeleteRecRisk", params);
	}
	
	@Override
	public void valAddRecRisk(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddRecRisk", params);		
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveRiskDetails(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISRisks> delList = (List<GIISRisks>) params.get("delRows");
			for(GIISRisks d: delList){
				this.sqlMapClient.update("delGiiss007Risk", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISRisks> setList = (List<GIISRisks>) params.get("setRows");
			for(GIISRisks s: setList){
				this.sqlMapClient.update("setGiiss007Risk", s);
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
	public void valAddRecBlock(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddRecBlock", params);		
	}	
	@Override
	public void valDeleteRecBlock(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDeleteRecBlock", params);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss007(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISBlock> delListProvince = (List<GIISBlock>) params.get("delRowsProvince");
			for(GIISBlock p: delListProvince){
				this.sqlMapClient.update("delGiiss007Province", p.getProvinceCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISBlock> delListCity = (List<GIISBlock>) params.get("delRowsCity");
			for(GIISBlock c: delListCity){
				this.sqlMapClient.update("delGiiss007City", c);
				System.out.println("fP"+c.getProvinceCd());
				System.out.println("fc"+c.getCityCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISBlock> delListDistrict = (List<GIISBlock>) params.get("delRowsDistrict");
			for(GIISBlock c: delListDistrict){
				this.sqlMapClient.update("delGiiss007District", c);
				System.out.println("fd"+c.getProvinceCd());
				System.out.println("fd"+c.getCityCd());
				System.out.println("fd"+c.getDistrictNo());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISBlock> delListBlock = (List<GIISBlock>) params.get("delRowsBlock");
			for(GIISBlock b: delListBlock){
				this.sqlMapClient.update("delGiiss007Block", b.getBlockId());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISBlock> setList = (List<GIISBlock>) params.get("setRowsBlock");
			for(GIISBlock s: setList){
				this.sqlMapClient.update("setGiiss007Block", s);
			}			
			this.sqlMapClient.executeBatch();
			
			List<GIISBlock> updateList = (List<GIISBlock>) params.get("updateRowsDistrict");
			for(GIISBlock s: updateList){
				this.sqlMapClient.update("updateGiiss007District", s);
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
	public void valDeleteRecProvince(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDeleteRecProvince", params);
	}
	
	@Override
	public void valDeleteRecCity(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDeleteRecCity", params);
	}
	
	@Override
	public void valDeleteRecDistrict(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDeleteRecDistrict", params);
	}

	@Override
	public void valAddRecDistrict(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddRecDistrict", params);
	}
}
