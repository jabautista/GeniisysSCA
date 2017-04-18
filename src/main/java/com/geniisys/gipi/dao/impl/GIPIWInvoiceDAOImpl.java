/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;

import com.geniisys.framework.util.Debug;
import com.geniisys.gipi.dao.GIPIWInvoiceDAO;
import com.geniisys.gipi.entity.GIPIWInstallment;
import com.geniisys.gipi.entity.GIPIWInvoice;
import com.geniisys.gipi.entity.GIPIWinvTax;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIWInvoiceDAOImpl.
 */
public class GIPIWInvoiceDAOImpl implements GIPIWInvoiceDAO {

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
	 * @param sqlMapClient
	 *            the new sql map client
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWInvoiceDAOImpl.class);

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.geniisys.gipi.dao.GIPIWInvoiceDAO#getGIPIWInvoice(int, int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWInvoice> getGIPIWInvoice(int parId, int itemGrp)
			throws SQLException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("parId", parId);
		param.put("itemGrp", itemGrp);
		log.info("DAO - Retrieving Bill...");
		log.info("DAO - PAR ID : "+parId);
		log.info("DAO - ITEM GROUP : "+itemGrp);
		List<GIPIWInvoice> gipiWInvoice = getSqlMapClient().queryForList(
				"getWInvoice", param);
		log.info("DAO - Winvoice Size(): " + gipiWInvoice.size());
		return gipiWInvoice;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.geniisys.gipi.dao.GIPIWInvoiceDAO#getGIPIWInvoice2(int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWInvoice> getGIPIWInvoice2(int parId) throws SQLException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("parId", parId);
		log.info("DAO - Retrieving Bill...");
		List<GIPIWInvoice> gipiWInvoice = getSqlMapClient().queryForList(
				"getWInvoice2", param);
		log.info("DAO - Winvoice Size(): " + gipiWInvoice.size());
		return gipiWInvoice;
	}
	
	@SuppressWarnings("unchecked")
	public List<GIPIWInvoice> getGIPIWInvoice3(int parId) throws SQLException {
		log.info("DAO - Retrieving Bill for PAR_ID "+parId);
		List<GIPIWInvoice> gipiWInvoice = this.getSqlMapClient().queryForList("getWInvoice3", parId);
		System.out.println("DAO - Winvoice Size(): " + gipiWInvoice.size());
		return gipiWInvoice;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.geniisys.gipi.dao.GIPIWInvoiceDAO#getItemGrpWinvoice(int)
	 */
	@SuppressWarnings("unchecked")
	public List<GIPIWInvoice> getItemGrpWinvoice(int parId) throws SQLException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("parId", parId);

		log.info("DAO - Retrieving Distinct winvoice...");
		List<GIPIWInvoice> gipiWinvoice = getSqlMapClient().queryForList(
				"getItemGrpWinvoice", param);
		log.info("DAO -  Distinct Winvoice Size(): " + gipiWinvoice.size());
		return gipiWinvoice;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.geniisys.gipi.dao.GIPIWInvoiceDAO#getTakeupWinvoice(int)
	 */
	@SuppressWarnings("unchecked")
	public List<GIPIWInvoice> getTakeupWinvoice(int parId) throws SQLException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("parId", parId);

		log.info("DAO - Retrieving Distinct takeup winvoice...");
		List<GIPIWInvoice> gipiWinvoice = getSqlMapClient().queryForList("getTakeupWinvoice", param);
		log.info("DAO -  Distinct takeup Winvoice Size(): "
				+ gipiWinvoice.size());
		return gipiWinvoice;

	}

	/*
	 * public GIPIWInvoice getGIPIWInvoice(int parId, int itemGrp) throws
	 * SQLException { Map<String, Object> param = new HashMap<String, Object>();
	 * param.put("parId", parId); param.put("itemGrp", itemGrp);
	 * log.info("DAO - Retrieving Bill..."); GIPIWInvoice gipiWInvoice =
	 * (GIPIWInvoice) getSqlMapClient().queryForObject("getWInvoice", param);
	 * log.info("DAO - Winvoice Size(): " + gipiWInvoice.getItemGrp()); return
	 * gipiWInvoice; }
	 */
	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.geniisys.gipi.dao.GIPIWInvoiceDAO#saveGIPIWInvoice(com.geniisys.gipi
	 * .entity.GIPIWInvoice)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void saveGIPIWInvoice(Map<String, Object> allParams) throws SQLException {
		try{		
			List<GIPIWInvoice> gipiWInvoice = (List<GIPIWInvoice>) (allParams.get("modifiedWInvoice"));
			List<GIPIWInvoice> gipiWInvoiceAll = (List<GIPIWInvoice>) (allParams.get("allWInvoice")); //added by steven 08.26.2014
			List<GIPIWinvTax> gipiWinvTax = (List<GIPIWinvTax>) (allParams.get("addedModifiedWinvTax"));
			List<Map<String, Object> > deletedWinvTax = (List<Map<String, Object>>) allParams.get("deletedWinvTax");
			List<GIPIWInstallment> gipiWInstallment = (List<GIPIWInstallment>) (allParams.get("addedModifiedInstallment"));
			Map<String, Object> parListParams = (Map<String, Object>) allParams.get("parListParams");
			Integer parId = (Integer) parListParams.get("parId");
			
			this.getSqlMapClient().startTransaction();			
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			String insured = StringEscapeUtils.unescapeHtml((String) parListParams.get("insured")) ;
			//Save gipiWinvoice details
			if (gipiWInvoice.isEmpty()) {//added by steven 08.26.2014
				gipiWInvoice = gipiWInvoiceAll;
			}
			for(GIPIWInvoice gipiWInvoiceDtls: gipiWInvoice){
				log.info("DAO - Inserting WInvoice ..." + " property: " + gipiWInvoiceDtls.getProperty());
				gipiWInvoiceDtls.setInsured(insured); // added insured - irwin .9.3.2012 // from rsic
				this.sqlMapClient.insert("saveGIPIWInvoice", gipiWInvoiceDtls);
				parListParams.put("riCommVat", gipiWInvoiceDtls.getRiCommVat()); // mark jm 06.30.2011 ucpbgen (for RI)
				log.info("DAO - WInvoice inserted.");
			}
								
			//Delete WinvTax details
			System.out.println("------------> --" + deletedWinvTax.size());
			for(Map<String, Object> gipiWinvTaxDtls: deletedWinvTax){
				Debug.print("Map of deleted info: " + deletedWinvTax);
				this.sqlMapClient.delete("delSelGipiWinvTax", gipiWinvTaxDtls);
				log.info("DAO - WinvTax inserted.");
			}
			
			this.getSqlMapClient().executeBatch();
			
			//Save WinvTax details
			System.out.println("-----------> ++" + gipiWinvTax.size());
			for(GIPIWinvTax gipiWinvTaxDtls: gipiWinvTax){
				log.info("DAO - Inserting WinvTax ...");
				this.sqlMapClient.insert("saveGIPIWinvTax", gipiWinvTaxDtls);
				log.info("DAO - WinvTax inserted.");
			}
			
			//Delete GIPIWInstallment details
			System.out.println("PAR ID to delete: " + parId);
			this.sqlMapClient.insert("deleteGIPIWinstallment2", parId);
			
			this.getSqlMapClient().executeBatch();
			
			
			//update parStatus of gipi parlist
			/*
			System.out.println("PAR ID: " + parId);
			this.sqlMapClient.update("updateParStatusByParId", parListParams);*/
			
			//POST FORMS COMMIT
			Debug.print("PARLIST PARAMS POSTFORMSCOMMIT: " + parListParams);
			this.sqlMapClient.insert("postFormsCommitGipis026", parListParams);
			this.getSqlMapClient().executeBatch();
			//Add gipiwinstallment details
			for (GIPIWInstallment gipiWInstallmentDtls: gipiWInstallment){
				System.out.println("DUE DATE2: " + gipiWInstallmentDtls.getDueDate());
				this.sqlMapClient.insert("saveGIPIWInstallment", gipiWInstallmentDtls);
			}
			
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
		}catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		} finally {
			this.getSqlMapClient().endTransaction();
		}	

	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.geniisys.gipi.dao.GIPIWInvoiceDAO#deleteGIPIWinvoice(int)
	 */
	public boolean deleteGIPIWinvoice(int parId) throws SQLException {
		Map<String, Object> param = new HashMap<String, Object>();

		param.put("parId", parId);
		// param.put("itemGrp", itemGrp);

		log.info("DAO - Deleting Winvoice... " + parId);// + " " + itemGrp);
		this.sqlMapClient.delete("deleteGIPIWinvoice", param);
		log.info("DAO - Winvoice deleted.");

		return true;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.geniisys.gipi.dao.GIPIWInvoiceDAO#winvoiceNewFormInst(int,
	 * java.lang.String, int)
	 */
	@Override
	public Map<String, Object> winvoiceNewFormInst(int packParId, String issCd,
			int parId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("packParId", packParId);
		params.put("issCd", issCd);
		params.put("parId", parId);
		this.sqlMapClient.queryForObject("winvoiceNewFormInst", params);

		return params;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.geniisys.gipi.dao.GIPIWInvoiceDAO#winvoicePostFormsCommit3(java.lang
	 * .Integer)
	 */
	@Override
	public void winvoicePostFormsCommit3(Integer parId) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		params.get("cnt");
		this.sqlMapClient.update("winvoicePostFormsCommit3", params);
		System.out.println("postforms" + params);
	}

	@Override
	public boolean updatePaytTermsGIPIWInvoice(Integer parId, Integer itemGrp, Integer takeupSeqNo, String paytTerms) throws SQLException {		
		this.getSqlMapClient().startTransaction(); 
		this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
		
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		params.put("itemGrp", itemGrp.toString());
		params.put("takeupSeqNo", takeupSeqNo.toString());
		params.put("paytTerms", paytTerms);
		this.sqlMapClient.insert("updatePaytTermsGIPIWInvoice", params);
		
		this.getSqlMapClient().getCurrentConnection().rollback();  
		this.getSqlMapClient().endTransaction();
		return true;
	}

	@Override
	public Map<String, String> isExist(Integer parId) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		this.sqlMapClient.update("isExistWInvoice", params);
		return params;
	}

	@Override
	public Map<String, String> checkPolicyCurrency(String currencyDesc,
			Integer parId) throws SQLException {
		Map<String, String> checkParams = new HashMap<String, String>();
		checkParams.put("currencyDesc", currencyDesc);
		checkParams.put("parId", parId.toString());
		checkParams.get("cd");
		checkParams.get("switch");

		this.sqlMapClient.update("checkPolicyCurrency", checkParams);
		System.out.println("policy curr params" + checkParams);
		return checkParams;
	}

	@Override
	public Map<String, String> getWInvoiceInputVatRate(Integer parId)
			throws SQLException {
		Map<String, String> inputParams = new HashMap<String, String>();
		inputParams.put("parId", parId.toString());
		this.sqlMapClient.queryForObject("getWInvoiceInputVatRate", inputParams);
		return inputParams;
	}

	@Override
	public void createWInvoice(Integer parId, String lineCd, String issCd)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("newParId", parId);
		params.put("lineCd", lineCd);
		params.put("issCd", issCd);
		this.getSqlMapClient().insert("createWInvoiceForCopyPar", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getWinvoiceBondDtls(Map<String, Object> params)
			throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject(
				"getWinvoiceBondDtls", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWInvoice> getTakeUpListDtls(Integer parId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getTakeUpListDtls", parId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveBondBillDtls(Map<String, Object> allParams, Map<String, Object> gipiWInvoiceParams) throws SQLException {
		try{
			List<GIPIWInvoice> addModifiedTakeUp = (List<GIPIWInvoice>) allParams.get("addModifiedTakeUp");
			List<GIPIWinvTax> addModifiedTaxInfo = (List<GIPIWinvTax>) allParams.get("addModifiedTaxInfo");
			List<Map<String, Object> > deletedTaxInfo = (List<Map<String, Object>>) allParams.get("deletedTaxInfo");
			Map<String, Object> postFormsParams = (Map<String, Object>) allParams.get("postFormsParams");
			
			String insured = StringEscapeUtils.unescapeHtml((String) allParams.get("insured")) ; // jhing 11.10.2014 
			
			this.getSqlMapClient().startTransaction();			
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			//added by robert GENQA SR 4828 08.27.15
			System.out.println("Prem Amount Changed: " + gipiWInvoiceParams.get("updateBondAutoPrem").toString());
			if (gipiWInvoiceParams.get("updateBondAutoPrem").toString().equals("Y")){
				System.out.println("updateBondAutoPrem = Y");
				this.getSqlMapClient().update("updateBondAutoPrem", postFormsParams.get("parId"));
			}
			//end robert GENQA SR 4828 08.27.15
			//create winvoice
			System.out.println("Marker Value: " + gipiWInvoiceParams.get("newInvoiceMarker").toString());
			if (gipiWInvoiceParams.get("newInvoiceMarker").toString().equals("Y")){
				System.out.println("INN");
				this.getSqlMapClient().queryForObject("getTempTakeupListDtls", gipiWInvoiceParams);
			}
			//Set added/modified records from takeup list
			for(GIPIWInvoice takeUp: addModifiedTakeUp){
				Debug.print("Added/Modified Takeup: " + takeUp.getDueDate());
				takeUp.setInsured(insured);  // jhing 11.10.2014
				this.getSqlMapClient().insert("saveGIPIWInvoice", takeUp);	
			}
			
			//Delete records form taxInfo List
			for(Map<String, Object> deletetaxInfo: deletedTaxInfo){
				Debug.print("Map of deleted info: " + deletetaxInfo);
				this.getSqlMapClient().delete("deleteGIPIWinvTaxPerRecord", deletetaxInfo);			
			}
			
			//Set added/modified records from taxInfo list
			for(GIPIWinvTax taxInfo: addModifiedTaxInfo){
				Debug.print("Added/Modified Tax Info: " + taxInfo);
				this.getSqlMapClient().insert("saveGIPIWinvTax", taxInfo);			
			}
			
			this.getSqlMapClient().executeBatch();
			
			//Post Forms Commit
			
			if("E".equals(postFormsParams.get("parType"))) {
				Debug.print("POST FORMS COMMIT(PARAMS endt): " + postFormsParams);
				this.getSqlMapClient().insert("postFormsCommitgipis165b", postFormsParams);
			} else {
				Debug.print("POST FORMS COMMIT(PARAMS): " + postFormsParams);
				this.getSqlMapClient().insert("postFormsCommitgipis017b", postFormsParams);
			}
						
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
	}

	@Override
	public Map<String, Object> getTempTakeupListDtls(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();			
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();	
			
			this.getSqlMapClient().queryForObject("getTempTakeupListDtls", params);
		
			//this.getSqlMapClient().executeBatch(); removed by robert SR 19785 07.23.15
			this.getSqlMapClient().getCurrentConnection().rollback();
			
			return params;
			
		}catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public Map<String, String> isExist2(Integer parId) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		this.sqlMapClient.update("isExistWInvoice2", params);
		return params;
	}

	@Override
	public Map<String, Object> validateTaxEntry(Map<String, Object> params) throws SQLException {
		sqlMapClient.queryForObject("validateTaxEntry", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWInvoice> getLeadPolGipiWInvoice(Integer parId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getLeadPolGipiWInvoice", parId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getAnnualAmt(Map<String, Object> params) throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getAnnualAmt", params);
	}

	@Override
	public BigDecimal getWInvoiceInputVatRate2(Integer parId)
			throws SQLException {
		log.info("Getting input vat rate ...");
		return (BigDecimal) this.sqlMapClient.queryForObject("getWInvoiceInputVatRate", parId);
	}

	@Override
	public void gipis026ValidateBookingDate(Map<String, Object> params)
			throws SQLException {
		try{
			this.sqlMapClient.queryForObject("gipis026ValidateBookingDate", params);
		}catch(SQLException e){
			throw e;
		}
		
	}

	@Override
	public Map<String, Object> validateBondDueDate(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("validateDueDate", params);
	  return params;
	}
	
	@Override
	public void deleteWDistTables(Integer parId) throws SQLException {
		this.getSqlMapClient().update("deleteWDistTables", parId);
	}

	@Override
	public String checkForPostedBinders(Integer parId) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkForPostedBinders", parId);
	}

	@Override
	public String getRangeAmount(Map<String, Object> params)
			throws SQLException {
		BigDecimal rangeAmt =  (BigDecimal) this.getSqlMapClient().queryForObject("getGipis026RangeAmt", params);
		return rangeAmt.toString();
	}

	@Override
	public String getRateAmount(Map<String, Object> params) throws SQLException {
		BigDecimal rateAmt =  (BigDecimal) this.getSqlMapClient().queryForObject("getGipis026RateAmt", params);
		return rateAmt.toString();
	}
	
	@Override
	public String getDocStampsTaxAmt(Map<String, Object> params)
			throws SQLException {
		BigDecimal dstTaxAmt =  (BigDecimal) this.getSqlMapClient().queryForObject("getGipis026DocStampsAmt", params);
		return dstTaxAmt.toString();
	}		
	
	@Override
	public String getFixedAmountTax(Map<String, Object> params)
			throws SQLException {
		BigDecimal fixedAmtTax =  (BigDecimal) this.getSqlMapClient().queryForObject("getFixedAmountTax", params);
		return fixedAmtTax.toString();
	}		
	@Override
	public String getCompTaxAmt(Map<String, Object> params)
			throws SQLException {
		BigDecimal compTaxAmount =  (BigDecimal) this.getSqlMapClient().queryForObject("getCompTaxAmt", params);
		return compTaxAmount.toString();
	}		

	@Override
	public Map<String, Object> validateBondsTaxEntry(Map<String, Object> params) throws SQLException {
		sqlMapClient.queryForObject("validateBondsTaxEntry", params);
		return params;
	}

	@Override
	public String recreateInvoice(Map<String, Object> parameters) throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();			
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			String message = (String) sqlMapClient.queryForObject("createWInvoiceForCopyPar", parameters);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
			return message;
		
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	
}
