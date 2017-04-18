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

import com.geniisys.framework.util.Debug;
import com.geniisys.gipi.dao.GIPIWInstallmentDAO;
import com.geniisys.gipi.entity.GIPIWInstallment;
import com.geniisys.gipi.entity.GIPIWinvTax;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIWInstallmentDAOImpl.
 */
public class GIPIWInstallmentDAOImpl implements GIPIWInstallmentDAO {

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

	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWInstallmentDAOImpl.class);

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWInstallmentDAO#getGIPIWInstallment(int, int, int)
	 */
	@SuppressWarnings("unchecked")
	public List<GIPIWInstallment> getGIPIWInstallment(int parId, int itemGrp,
			int takeupSeqNo) throws SQLException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("parId", parId);
		param.put("itemGrp", itemGrp);
		param.put("takeupSeqNo", takeupSeqNo);
		log.info("DAO - Retrieving Installment...");
		List<GIPIWInstallment> gipiWInstallment = getSqlMapClient()
				.queryForList("getWInstallment", param);
		log.info("DAO - Winstallment Size(): " + gipiWInstallment.size());
		return gipiWInstallment;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWInstallmentDAO#deleteGIPIWinstallment(int)
	 */
	@Override
	public boolean deleteGIPIWinstallment(int parId) throws SQLException {
		Map<String, Object> param = new HashMap<String, Object>();
			param.put("parId", parId);
			log.info("DAO - Deleting Winstallment... " + parId );//+ " " + itemGrp);
			this.sqlMapClient.delete("deleteGIPIWinstallment", param);
			log.info("DAO - Winstallment deleted.");
			return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWInstallmentDAO#saveGIPIWInstallment(com.geniisys.gipi.entity.GIPIWInstallment)
	 */
	@Override
	public boolean saveGIPIWInstallment(GIPIWInstallment winstallment) throws SQLException {
		log.info("Saving winstallment. . . ");
		this.sqlMapClient.insert("saveGIPIWInstallment", winstallment);
		log.info("DAO - Winstallment inserted.");
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWInstallmentDAO#doPaytermComputation(java.lang.Integer, java.lang.String, java.lang.Integer, java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> doPaytermComputation(Map<String, Object> allParams) throws SQLException {
		Map<String, Object> paytermParams = (Map<String, Object>) allParams.get("paytermParams");
		List<GIPIWinvTax> gipiWinvTax = (List<GIPIWinvTax>) (allParams.get("addedModifiedWinvTax"));
		List<Map<String, Object> > deletedWinvTax = (List<Map<String, Object>>) allParams.get("deletedWinvTax");
		List<Map<String, Object>> allWInvoiceDtls = (List<Map<String, Object>>) allParams.get("allWInvoiceDtls");
		this.getSqlMapClient().startTransaction(); 
		this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
		this.getSqlMapClient().startBatch();
				
		//Delete WinvTax details
		for(Map<String, Object> gipiWinvTaxDtls: deletedWinvTax){
			Debug.print("Map of deleted info: " + deletedWinvTax);
			this.sqlMapClient.delete("delSelGipiWinvTax", gipiWinvTaxDtls);
			log.info("DAO - WinvTax inserted.");
		}
		this.getSqlMapClient().executeBatch();
		
		for(GIPIWinvTax gipiWinvTaxDtls: gipiWinvTax){
			log.info("DAO - Inserting WinvTax ...");
			this.sqlMapClient.insert("saveGIPIWinvTax", gipiWinvTaxDtls);
			log.info("DAO - WinvTax inserted.");
		}
		this.getSqlMapClient().executeBatch();
		
		/*//Delete WinvTax details
		for(Map<String, Object> gipiWinvTaxDtls: deletedWinvTax){
			Debug.print("Map of deleted info: " + deletedWinvTax);
			this.sqlMapClient.delete("delSelGipiWinvTax", gipiWinvTaxDtls);
			log.info("DAO - WinvTax inserted.");
		}
		this.getSqlMapClient().executeBatch();*/ //belle 07.09.2012 mauna muna ung delete bago ung insert
		
		for(Map<String, Object> paytermParameters: allWInvoiceDtls){
			Debug.print("PAYTERMS PARAMS: " + paytermParameters);
			this.sqlMapClient.insert("updatePaytTermsGIPIWInvoice", paytermParameters);
		}
		this.getSqlMapClient().executeBatch();
		
		this.sqlMapClient.update("doPaytermComputation2", paytermParams);
		log.info("doPaytermComputation2: "+  paytermParams);
		this.getSqlMapClient().executeBatch();

		this.getSqlMapClient().getCurrentConnection().rollback();  
		this.getSqlMapClient().endTransaction();
		
		return paytermParams;
		
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWInstallmentDAO#getAllGIPIWInstallment(int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWInstallment> getAllGIPIWInstallment(int parId)	throws SQLException {
		// TODO Auto-generated method stub
		log.info("DAO - Retrieving Installment...");
		List<GIPIWInstallment> gipiWInstallment = getSqlMapClient().queryForList("getAllWInstallment", parId);		
		log.info("DAO - Winstallment Size(): " + gipiWInstallment.size());
		return gipiWInstallment;
	}

}
