/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.framework.util.Debug;
import com.geniisys.gipi.dao.GIPIQuoteItemENDAO;
import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.entity.GIPIQuoteItemEN;
import com.geniisys.gipi.entity.GIPIQuotePrincipal;
import com.ibatis.sqlmap.client.SqlMapClient;

/**
 * The Class GIPIQuoteItemENDAOImpl.
 */
public class GIPIQuoteItemENDAOImpl implements GIPIQuoteItemENDAO {
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIQuoteItemENDAOImpl.class);

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
	 * @param getSqlMapClient the new sql map client
	 */
	public void setSqlMapClient(SqlMapClient getSqlMapClient) {
		this.sqlMapClient = getSqlMapClient;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemENDAO#getGIPIQuoteItemENDetails(int, int)
	 */
	@Override
	public GIPIQuoteItemEN getGIPIQuoteItemENDetails(int quoteId, int itemNo)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("quoteId", quoteId);
		params.put("itemNo", itemNo);
		return (GIPIQuoteItemEN) this.getSqlMapClient().queryForObject("getGIPIQuoteItemENDetails", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemENDAO#saveGIPIQuoteItemEN(com.geniisys.gipi.entity.GIPIQuoteItemEN)
	 */
	@Override
	public void saveGIPIQuoteItemEN(GIPIQuoteItemEN quoteItemEN) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
	
			this.getSqlMapClient().insert("saveGIPIQuoteItemEN", quoteItemEN);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally {
			this.getSqlMapClient().endTransaction();
		}	
	}

	@Override
	public void deleteGIPIQuoteItemEN(int quoteId, int itemNo)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("quoteId", quoteId);
		params.put("itemNo", itemNo);
		this.sqlMapClient.delete("deleteGIPIQuoteItemEN", params);
	}

	@Override
	public List<GIPIQuoteItemEN> getGIPIQuoteItemENs(int quoteId)
			throws SQLException {
		
		
		
		return null;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGIPIQuoteItemEN(GIPIQuoteItemEN quoteItemEN, Map<String, Object> parameters) throws SQLException {
		try{
			List<Map<String, Object>> addModifiedPrincipal = (List<Map<String, Object>>) parameters.get("addModifiedPrincipal");
			List<Map<String, Object>> deletedPrincipals = (List<Map<String, Object>>) parameters.get("deletedPrincipal");
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
	
			this.getSqlMapClient().insert("saveGIPIQuoteItemEN", quoteItemEN);
						
			for(Map<String, Object> delPrincipal: deletedPrincipals){
				Debug.print("Map of Deleted info: " + delPrincipal);
				this.getSqlMapClient().delete("deleteGIPIQuotePrincipal", delPrincipal);			
			}
			
			for(Map<String, Object> principal: addModifiedPrincipal){
				Debug.print("Map of Inserted/Modified info: " + principal);
				this.getSqlMapClient().insert("saveGIPIQuotePrincipal", principal);			
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuoteItemEN> getQuoteENDetailsForPackQuotation(
			List<GIPIQuote> enQuoteList) throws SQLException {
		List<GIPIQuoteItemEN> quoteENDetailsList = new ArrayList<GIPIQuoteItemEN>();
		Map<String, Object> params = new HashMap<String, Object>();
		
		for(GIPIQuote quote : enQuoteList){
			List<GIPIQuoteItemEN> quoteEN = new ArrayList<GIPIQuoteItemEN>();
			params.clear();
			params.put("quoteId", quote.getQuoteId());
			quoteEN = this.getSqlMapClient().queryForList("getGIPIQuoteItemEN", params);
			for(GIPIQuoteItemEN en : quoteEN){
				quoteENDetailsList.add(en);
			}
		}
		return quoteENDetailsList;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGIPIQuoteENDetailsForPackQuote(Map<String, Object> listParams) throws SQLException {
	try{
		List<GIPIQuoteItemEN> setENRows = (List<GIPIQuoteItemEN>) listParams.get("setENRows");
		System.out.println("Set EN Rows Length: " + setENRows.size());
		List<GIPIQuoteItemEN> delENRows = (List<GIPIQuoteItemEN>) listParams.get("delENRows");
		System.out.println("Delete EN Rows Length: " + delENRows.size());
		List<GIPIQuotePrincipal> setPrincipalRows = (List<GIPIQuotePrincipal>) listParams.get("setPrincipalRows");
		System.out.println("Set Principal Rows Length: " + setPrincipalRows.size());
		List<GIPIQuotePrincipal> delPrincipalRows = (List<GIPIQuotePrincipal>) listParams.get("delPrincipalRows");
		System.out.println("Delete Principal Rows Length: " + delPrincipalRows.size());
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		this.getSqlMapClient().startTransaction();
		this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
		this.getSqlMapClient().startBatch();
		
		for(GIPIQuoteItemEN delEn : delENRows){
			log.info("Deleting gipi_quote_item_en with quote_id: " + delEn.getQuoteId());
			params.clear();
			params.put("quoteId", delEn.getQuoteId());
			this.getSqlMapClient().delete("delGIPIQuoteItemEN", params);
		}
		
		for(GIPIQuotePrincipal delPrincipal : delPrincipalRows){
			log.info("Deleting gipi_quote_principal with quote_id: " + delPrincipal.getQuoteId());
			params.clear();
			params.put("quoteId", delPrincipal.getQuoteId());
			params.put("principalCd", delPrincipal.getPrincipalCd());
			this.getSqlMapClient().delete("deleteGIPIQuotePrincipal", params);
		}
		
		for(GIPIQuoteItemEN setEN : setENRows){
			log.info("Saving gipi_quote_item_en with quote_id: " + setEN.getQuoteId());
			this.getSqlMapClient().update("saveGIPIQuoteItemEN", setEN);
		}
		
		for(GIPIQuotePrincipal setPrincipal : setPrincipalRows){
			log.info("Saving gipi_quote_principal with quote_id: " + setPrincipal.getQuoteId() + " and principal_cd: " + setPrincipal.getPrincipalCd());
			params.clear();
			params.put("quoteId", setPrincipal.getQuoteId());
			params.put("principalCd", setPrincipal.getPrincipalCd());
			params.put("enggBasicInfoNum", setPrincipal.getEnggBasicInfonum());
			params.put("subconSw", setPrincipal.getSubconSw());
			this.getSqlMapClient().update("setGIPIQuotePrincipal", params);
		}
		
		this.getSqlMapClient().executeBatch();
		this.getSqlMapClient().getCurrentConnection().commit();
	}catch (SQLException e) {
		e.printStackTrace();
		this.getSqlMapClient().getCurrentConnection().rollback();
		throw e;
	}finally {
		this.getSqlMapClient().endTransaction();
	}
	}

}
