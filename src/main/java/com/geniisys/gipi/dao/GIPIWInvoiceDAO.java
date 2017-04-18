/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIWInvoice;


/**
 * The Interface GIPIWInvoiceDAO.
 */
public interface GIPIWInvoiceDAO {
	
	//public GIPIWInvoice getGIPIWInvoice(int parId, int itemGrp) throws SQLException;
	/**
	 * Gets the gIPIW invoice.
	 * 
	 * @param parId the par id
	 * @param itemGrp the item grp
	 * @return the gIPIW invoice
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIWInvoice> getGIPIWInvoice(int parId, int itemGrp) throws SQLException;
	
	/**
	 * Gets the gIPIW invoice using parId only. (Emman 04.27.10)
	 * 
	 * @param parId the par id
	 * @return the gIPIW invoice
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIWInvoice> getGIPIWInvoice2(int parId) throws SQLException;
	
	public List<GIPIWInvoice> getGIPIWInvoice3(int parId) throws SQLException;
	
	/**
	 * Gets the item grp winvoice.
	 * 
	 * @param parId the par id
	 * @return the item grp winvoice
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIWInvoice> getItemGrpWinvoice(int parId) throws SQLException;
	
	/**
	 * Gets the takeup winvoice.
	 * 
	 * @param parId the par id
	 * @return the takeup winvoice
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIWInvoice> getTakeupWinvoice(int parId) throws SQLException;
	
	/**
	 * Save gipiw invoice.
	 * 
	 * @param winvoice the winvoice
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public void saveGIPIWInvoice(Map<String, Object> allParams) throws SQLException;
	
	/**
	 * Delete gipi winvoice.
	 * 
	 * @param parId the par id
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean deleteGIPIWinvoice(int parId) throws SQLException;
	
	/**
	 * Winvoice new form inst.
	 * 
	 * @param packParId the pack par id
	 * @param issCd the iss cd
	 * @param parId the par id
	 * @return the map
	 * @throws SQLException the sQL exception
	 */
	Map<String, Object> winvoiceNewFormInst(int packParId, String issCd, int parId) throws SQLException;
	
	/**
	 * Winvoice post forms commit3.
	 * 
	 * @param parId the par id
	 * @throws SQLException the sQL exception
	 */
	void winvoicePostFormsCommit3(Integer parId) throws SQLException;
	
	public boolean updatePaytTermsGIPIWInvoice(Integer parId, Integer itemGrp, Integer takeupSeqNo, String paytTerms) throws SQLException;
	public Map<String, String> isExist(Integer parId) throws SQLException;
	public Map<String, String> checkPolicyCurrency(String currencyDesc, Integer parId) throws SQLException;
	public Map<String, String> getWInvoiceInputVatRate(Integer parId) throws SQLException;
	public void createWInvoice(Integer parId, String lineCd, String issCd) throws SQLException;
	
	/** ANTHONY SANTOS NOV 9, 2010 
	 * Winvoice get bond details.
	 * 
	 * @param parId the par id
	 * @throws SQLException the sQL exception
	 */
	public Map<String, Object> getWinvoiceBondDtls(Map<String, Object> params) throws SQLException;
	
	/** ANTHONY SANTOS NOV 9, 2010 
	 * Winvoice get take up list details.
	 * 
	 * @param parId the par id
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIWInvoice> getTakeUpListDtls(Integer parId) throws SQLException;
	
	/** ANTHONY SANTOS NOV 9, 2010 
	 * Winvoice save bond details.
	 * 
	 * @param map
	 * @throws SQLException the sQL exception
	 */
	public void saveBondBillDtls(Map<String, Object> params, Map<String, Object> gipiWInvoiceParams) throws SQLException;
	
	/** ANTHONY SANTOS NOV 30, 2010 
	 * Winvoice get temp takeup details.
	 * 
	 * @param map
	 * @throws SQLException the sQL exception
	 */
	public Map<String, Object> getTempTakeupListDtls(Map<String, Object> params) throws SQLException;

	Map<String, String> isExist2(Integer parId) throws SQLException;
	
	/** ANTHONY SANTOS NOV 30, 2010 
	 * Validate tax entry.
	 * 
	 * @param map
	 * @throws SQLException the sQL exception
	 */
	Map<String, Object> validateTaxEntry(Map<String, Object> params) throws SQLException;
	
	List<GIPIWInvoice> getLeadPolGipiWInvoice(Integer parId) throws SQLException;
	
	Map<String, Object> getAnnualAmt(Map<String, Object> params) throws SQLException;
	BigDecimal getWInvoiceInputVatRate2(Integer parId) throws SQLException;
	void gipis026ValidateBookingDate(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateBondDueDate(Map<String, Object> params) throws SQLException;
	
	void deleteWDistTables(Integer parId) throws SQLException;
	public String checkForPostedBinders(Integer parId) throws SQLException;
	public String getRangeAmount(Map<String, Object> params) throws SQLException;
	public String getRateAmount(Map<String, Object> params) throws SQLException;
	public String getDocStampsTaxAmt(Map<String, Object> params) throws SQLException;	
	public String getFixedAmountTax(Map<String, Object> params) throws SQLException;
	public String getCompTaxAmt(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateBondsTaxEntry(Map<String, Object> params) throws SQLException;
	
	String recreateInvoice(Map<String, Object> parameters) throws SQLException; //added by Daniel Marasigan SR 2169 08.01.2016

}

	