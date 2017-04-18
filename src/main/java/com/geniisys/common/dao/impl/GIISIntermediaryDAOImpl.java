/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.jfree.util.Log;

import com.geniisys.common.dao.GIISIntermediaryDAO;
import com.geniisys.common.entity.GIISIntermediary;
import com.geniisys.common.entity.GIISTakeupTerm;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIISIntermediaryDAOImpl.
 */
public class GIISIntermediaryDAOImpl implements GIISIntermediaryDAO {

	/** The sql map client. */
	private SqlMapClient sqlMapClient;

	/**
	 * Sets the sql map client.
	 * 
	 * @param sqlMapClient the new sql map client
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/**
	 * Gets the sql map client.
	 * 
	 * @return the sql map client
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GiisIntermediaryDAO#getIntermediaryList(int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISIntermediary> getIntermediaryList(int intmNo)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getGIISIntermediary", intmNo);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GiisIntermediaryDAO#getParentIntermediaryName(int)
	 */
	@Override
	public String getParentIntermediaryName(int parentIntmNo)
			throws SQLException {
		return (String)this.getSqlMapClient().queryForObject("getGIISIntermediaryParentName", parentIntmNo);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.GiisIntermediaryDAO#getDefaultTaxRate(int)
	 */
	@Override
	public BigDecimal getDefaultTaxRate(int intmNo) throws SQLException {
		BigDecimal wtaxRate = null;	
		
		wtaxRate = (BigDecimal)this.getSqlMapClient().queryForObject("getDefaultTaxRate", intmNo);
		wtaxRate = wtaxRate == null ? new BigDecimal(0) : wtaxRate;
		
		return wtaxRate;
	}
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.GiisIntermediaryDAO#getPayorLOV()
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISIntermediary> getPayorLOV(String keyword) throws SQLException {
		return getSqlMapClient().queryForList("getPayorLOV", keyword);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISIntermediary> getPayorLOV2(Map<String, Object> params) throws SQLException {
		return getSqlMapClient().queryForList("getPayorLOV2", params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.GiisIntermediaryDAO#getAllGIISIntermediary()
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISIntermediary> getAllGIISIntermediary() throws SQLException {
		return (List<GIISIntermediary>)this.getSqlMapClient().queryForList("getAllGIISIntermediaryLOV");
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISIntermediaryDAO#getGIPICommInvoiceIntmList(java.lang.String, java.lang.String, java.lang.String, java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISIntermediary> getGIPICommInvoiceIntmList(String tranType,
			String issCd, String premSeqNo, String intmName) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tranType", tranType);
		params.put("issCd", issCd);
		params.put("premSeqNo", premSeqNo);
		params.put("intmName", intmName);
		return this.getSqlMapClient().queryForList("getGIPICommInvoiceIntmList", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISIntermediaryDAO#getIntermediaryList2(java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISIntermediary> getIntermediaryList2(String keyword)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getIntermediaryListing2", keyword);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISIntermediaryDAO#getBancaIntermediaryList(java.lang.String, java.lang.String, java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISIntermediary> getBancaIntermediaryList(String keyword,
			String bancTypeCd, String intmType) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("keyword", keyword);
		params.put("bancTypeCd", bancTypeCd);
		params.put("intmType", intmType);
		
		return this.getSqlMapClient().queryForList("getBancaIntermediaryListing", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISIntermediaryDAO#getGipis085IntmLOVListing(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISIntermediary> getGipis085IntmLOVListing(Map<String, Object> params) throws SQLException {
		List<GIISIntermediary> intmList = null;
		if (params.get("lovName") != null) {
			if ("cgfk$wcominvDspIntmName".equals(params.get("lovName"))) {
				intmList = this.getSqlMapClient().queryForList("getGipis085IntmNameLov", params);
			} else if ("cgfk$wcominvDspIntmName".equals(params.get("lovName"))) {
				intmList = this.getSqlMapClient().queryForList("getGipis085IntmNameLov3", params);
			} else {
				intmList = this.getSqlMapClient().queryForList("getGipis085IntmNameLov5", params);
			}
		} else {
			intmList = this.getSqlMapClient().queryForList("getGipis085IntmNameLov5", params);
		}
		return intmList;
	}

	@Override
	public Map<String, Object> getPremWarrLetter(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("getPremWarrLetter", params);
		return params;
	}
	
	@Override
	public Map<String, Object> validateIntmNo(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validatePurgeIntmNo", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIISIntermediary> validateIntmNoGiexs006(Integer intmNo)
			throws SQLException {
		return this.sqlMapClient.queryForList("validateIntmNoGiexs006", intmNo);
	}
	
	@Override
	public Map<String, Object> validateIntmType(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateIntmType", params);
		return params;
	}

	@Override
	public String getParentIntmNo(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getParentIntmNo", params);
	}

	@Override
	public void extractIntmProdColln(Map<String, Object> params)
			throws SQLException {
		
		try {
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("extractIntmProdColln", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
			
		} catch (Exception e) {
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		
		
	}

	@Override
	public void extractWeb(Map<String, Object> params) throws SQLException {
		
		try {
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("extractWeb", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
			
		} catch (Exception e) {
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		
	}
	
	//shan 11.7.2013
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss203(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			/*
			List<GIISIntermediary> delList = (List<GIISIntermediary>) params.get("delRows");
			for(GIISIntermediary d: delList){
				this.sqlMapClient.update("delIntermediary", d.getIntmNo());
			}*/
			this.sqlMapClient.executeBatch();
			
			List<GIISIntermediary> setList = (List<GIISIntermediary>) params.get("setRows");
			for(GIISIntermediary s: setList){
				this.sqlMapClient.update("setIntermediary", s);
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
	public Map<String, Object> valDeleteRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDeleteIntermediary", params);
		return params;
	}

	/*@Override
	public void valAddRec(Integer intmNo) throws SQLException {
		this.sqlMapClient.update("valAddIntermediary", intmNo);		
	}*/
	
	public GIISIntermediary getGiiss076Record(Integer intmNo) throws SQLException{
		return (GIISIntermediary) this.sqlMapClient.queryForObject("getGiiss076Record", intmNo);
	}
	
	public String getRequireWtax() throws SQLException{
		return (String) this.sqlMapClient.queryForObject("getRequireWtaxGiiss076");
	}
	
	public String getParentTinGiiis076(Integer parentIntmNo) throws SQLException{
		return (String) this.sqlMapClient.queryForObject("getParentTinGiiss076", parentIntmNo);
	}
	
	public Integer valIntmNameGiiis076(String intmName) throws SQLException{
		return (Integer) this.sqlMapClient.queryForObject("valIntmNameGiiss076", intmName);
	}
	
	public String getGiacParamValueN(String paramName) throws SQLException{
		return (String) this.sqlMapClient.queryForObject("getGIACParamValueN2", paramName);
	}
	
	public void valDeleteRecGiiis076(Integer intmNo) throws SQLException{
		this.sqlMapClient.update("valDeleteGiiss076", intmNo);
	}
	
	public void saveGiiss076(GIISIntermediary intm) throws SQLException{
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();			
			String recordStatus = intm.getRecordStatus();
			
			System.out.println("-1".equals(recordStatus));
			
			if("-1".equals(recordStatus)){
				System.out.println("Deleting Intermediary " + intm.getIntmNo());
				this.sqlMapClient.update("deleteGiiss076", intm.getIntmNo());
			}else{
				String log = "0".equals(recordStatus) ? "Inserting " : "Updating " + "Intermediary " + intm.getIntmNo();
				System.out.println(log);		
				this.sqlMapClient.update("setGiiss076", intm);
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
	
	public Map<String, Object> copyIntermediaryGiiss076(Map<String, Object> params) throws SQLException{
		this.sqlMapClient.update("copyIntermediaryGiiss076", params);
		return params;
	}
	
	public Integer getIntermediaryNoSequence() throws SQLException{
		return (Integer) this.sqlMapClient.queryForObject("getIntermediaryNoSequence");
	}
	
	public String checkMobilePrefixGiiss076(Map<String, Object> params) throws SQLException{
		return (String) this.sqlMapClient.queryForObject("checkMobilePrefixGiiss076", params);
	}

	@Override
	public String valCommRate(Map<String, Object> params) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("valCommRate", params);
	}
}
