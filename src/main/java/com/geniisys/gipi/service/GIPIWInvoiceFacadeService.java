/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIWInvoice;


/**
 * The Interface GIPIWInvoiceFacadeService.
 */
public interface GIPIWInvoiceFacadeService {
//	public GIPIWInvoice getGIPIWInvoice(int parId, int itemGrp) throws SQLException;
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
	
	/*
	 * Gets the gIPIW invoice.
	 * 
	 * @param parId the par id
	 * 
	 * @return the gIPIW invoice
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIWInvoice> getGIPIWInvoice3(int parId) throws SQLException, ParseException;
	
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
	
	/** Modified by Anthony Santos Jan 31, 2011
	 * Save w invoice.
	 * 
	 * @param parameters the parameters
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 * @throws ParseException the parse exception
	 */
	public void saveWInvoice(String allParameters, Map<String, Object> params) throws SQLException, ParseException, JSONException;
	
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
	Map<String, String> isExist(Integer parId) throws SQLException;
	
	Map<String, String> checkPolicyCurrency(String currencyDesc, Integer parId) throws SQLException;
	Map<String, String> getWInvoiceInputVatRate(Integer parId) throws SQLException;
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
	
	/** ANTHONY SANTOS NOV 24, 2010 
	 * Save Bond Dtls .
	 * 
	 * @param JSON Object
	 * @throws SQLException the sQL exception
	 */
	public void saveBondBillDtls(String parameters, Map<String, Object> gipiWInvoiceParams) throws SQLException, JSONException, ParseException;
	
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
	public Map<String, Object> validateTaxEntry(Map<String, Object> params) throws SQLException;
	
	List<Map<String, Object>> prepareGIPIWInvoiceForDelete(JSONArray delRows) throws JSONException;
	
	List<GIPIWInvoice> getLeadPolGipiWInvoice(Integer parId) throws SQLException;
	
	Map<String, Object> getAnnualAmt(Map<String, Object> params) throws SQLException;
	
	List<GIPIWInvoice> prepareWInvoice(JSONArray setRows) throws JSONException, ParseException;
	
	List<Map<String, Object>> prepareWInvoice2(JSONArray setRows) throws JSONException, ParseException;
	
	BigDecimal getWInvoiceInputVatRate2(Integer parId) throws SQLException;
	
	void gipis026ValidateBookingDate(Map<String, Object> params) throws SQLException;
	
	String validateBondDueDate(Map<String, Object> params) throws SQLException;
	
	public void deleteWDistTables(HttpServletRequest request) throws SQLException;

	public String checkForPostedBinders(HttpServletRequest request) throws SQLException;

	public String getRangeAmount(HttpServletRequest request) throws SQLException;

	public String getRateAmount(HttpServletRequest request) throws SQLException;
	
	public String getDocStampsTaxAmt(HttpServletRequest request) throws SQLException; 
	
	public String getFixedAmountTax (HttpServletRequest request) throws SQLException;
	
	public String getCompTaxAmt (HttpServletRequest request) throws SQLException;

	public Map<String, Object> validateBondsTaxEntry(Map<String, Object> params) throws SQLException;
	
	public String recreateInvoice(HttpServletRequest request) throws SQLException; //added by Daniel Marasigan SR 2169 08.01.2016
}
