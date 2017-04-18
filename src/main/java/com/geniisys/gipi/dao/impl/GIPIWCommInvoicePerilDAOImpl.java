/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIWCommInvoicePerilDAO;
import com.geniisys.gipi.entity.GIPIWCommInvoicePeril;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIWCommInvoicePerilDAOImpl.
 */
public class GIPIWCommInvoicePerilDAOImpl implements GIPIWCommInvoicePerilDAO {

	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWCommInvoiceDAOImpl.class);

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
	 * @see com.geniisys.gipi.dao.GIPIWCommInvoicePerilDAO#getWCommInvoicePeril(int, int, int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWCommInvoicePeril> getWCommInvoicePeril(int parId,
			int itemGroup, int intermediaryIntmNo) throws SQLException {
		// TODO Auto-generated method stub
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("parId", parId);
		params.put("itemGroup", itemGroup);
		params.put("intermediaryIntmNo", intermediaryIntmNo);
		
		List<GIPIWCommInvoicePeril> wcommInvoicePeril = this.getSqlMapClient().queryForList("getWCommInvoicePeril", params);
		
		return wcommInvoicePeril;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCommInvoicePerilDAO#getWCommInvoicePeril(int, int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWCommInvoicePeril> getWCommInvoicePeril(int parId) throws SQLException {
		// TODO Auto-generated method stub
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("parId", parId);
		
		List<GIPIWCommInvoicePeril> wcommInvoicePeril = this.getSqlMapClient().queryForList("getWCommInvoicePeril2", params);
		
		return wcommInvoicePeril;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCommInvoicePerilDAO#saveWCommInvoicePeril(int, int, int, int, int, java.math.BigDecimal, java.math.BigDecimal, java.math.BigDecimal, java.math.BigDecimal)
	 */
	@Override
	public boolean saveWCommInvoicePeril(List<GIPIWCommInvoicePeril> commInvoicePerils)
			throws SQLException {
		// TODO Auto-generated method stub
		
		Map<String, Object> params;
		int count = 0;
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			for (GIPIWCommInvoicePeril commInvoicePeril : commInvoicePerils) {
				log.info("DAO - Saving Commission Invoice Peril " + ++count);
				
				params = new HashMap<String, Object>();
				
				params.put("perilCd", commInvoicePeril.getPerilCd());
				params.put("itemGroup", commInvoicePeril.getItemGroup());
				params.put("takeupSeqNo", commInvoicePeril.getTakeupSeqNo());
				params.put("parId", commInvoicePeril.getParId());
				params.put("intermediaryIntmNo", commInvoicePeril.getIntermediaryIntmNo());
				params.put("premiumAmount", commInvoicePeril.getPremiumAmount());
				params.put("commissionRate", commInvoicePeril.getCommissionRate());
				params.put("commissionAmount", commInvoicePeril.getCommissionAmount());
				params.put("withholdingTax", commInvoicePeril.getWithholdingTax());
				
				this.getSqlMapClient().update("saveWCommInvoicePeril", params);
				
				//commInvoicePerils.remove(commInvoicePeril);
				
				log.info("Commission Invoice Peril " + count + " saved.");
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch(SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			log.info("SQL Error: " + e.getMessage());
			throw new SQLException();
		} catch(Exception e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			log.info("SQL Error: " + e.getMessage());
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
		
		return true;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCommInvoicePerilDAO#deleteWCommInvoicePeril(int, int, int, int)
	 */
	@Override
	public boolean deleteWCommInvoicePeril(int parId, int itemGroup,
			int intermediaryIntmNo, int perilCd) throws SQLException {
		// TODO Auto-generated method stub
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("parId", parId);
		params.put("itemGroup", itemGroup);
		params.put("intermediaryIntmNo", intermediaryIntmNo);
		params.put("perilCd", perilCd);
		
		this.getSqlMapClient().delete("deleteWCommInvoicePeril", params);
		
		return true;
	}
	
	@Override
	public boolean deleteWCommInvoicePerilsByList(
			List<GIPIWCommInvoicePeril> commInvoicePerils) throws SQLException {
		// TODO Auto-generated method stub
		Map<String, Object> params;
		int count = 0;
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			for (GIPIWCommInvoicePeril commInvoicePeril : commInvoicePerils) {
				log.info("DAO - Deleting Commission Invoice Peril " + ++count);
				
				params = new HashMap<String, Object>();
				
				params.put("perilCd", commInvoicePeril.getPerilCd());
				params.put("itemGroup", commInvoicePeril.getItemGroup());
				params.put("parId", commInvoicePeril.getParId());
				params.put("intermediaryIntmNo", commInvoicePeril.getIntermediaryIntmNo());
				
				this.getSqlMapClient().delete("deleteWCommInvoicePeril", params);
				
				log.info("Commission Invoice Peril " + count + " deleted.");
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch(SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			log.info("SQL Error: " + e.getMessage());
			throw new SQLException();
		} catch(Exception e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			log.info("SQL Error: " + e.getMessage());
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
		
		return true;
	}
}
