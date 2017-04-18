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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIWCommInvoice;


/**
 * The Interface GIPIWCommInvoiceService.
 */
public interface GIPIWCommInvoiceService {

	/**
	 * Gets the w comm invoice.
	 * 
	 * @param parId the par id
	 * @param itemGroup the item group
	 * @return the w comm invoice
	 * @throws SQLException the sQL exception
	 */
	List<GIPIWCommInvoice> getWCommInvoice(int parId, int itemGroup) throws SQLException;
	
	/**
	 * Gets the w comm invoice using parId only.
	 * 
	 * @param parId the par id
	 * @return the w comm invoice
	 * @throws SQLException the sQL exception
	 */
	List<GIPIWCommInvoice> getWCommInvoice(int parId) throws SQLException;
	
	/**
	 * Save w comm invoice.
	 * 
	 * @param commInvoice The comm invoice to be saved.
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	boolean saveWCommInvoice(List<GIPIWCommInvoice> commInvoices) throws SQLException;
	
	/**
	 * Saves GIPI_WCOMM_INVOICES and GIPI_WCOMM_INV_PERILS records and performs key-delrec and post-forms-commit of GIPIS085
	 * @param strParameters
	 * @throws SQLException
	 * @throws JSONException
	 * @throws ParseException
	 */
	void saveGipiWcommInvoice(String strParameters) throws SQLException, JSONException, ParseException;
	
	/**
	 * Delete w comm invoice.
	 * 
	 * @param parId the par id
	 * @param itemGroup the item group
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	boolean deleteWCommInvoice(int parId, int itemGroup) throws SQLException;
	
	/**
	 * Delete wcomm invoices
	 * 
	 * @param commInvoices The list of comm invoices to be deleted.
	 * 			required parameters are par_id, item_grp, takeup_seq_no, and intm_no
	 * @return
	 * @throws SQLException
	 */
	boolean deleteWCommInvoice2(List<GIPIWCommInvoice> commInvoices) throws SQLException;
	
	/**
	 * Calls the function CHECK_PERIL_COMM_RATE
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	String checkPerilCommRate(Map<String, Object> params) throws SQLException;
	
	/**
	 * Calls the function giacp.v
	 * 
	 * @param paramName - the parameter name
	 * @return the string result of the function
	 * @throws SQLException the SQL Exception
	 */
	String getAccountingParameter(String paramName) throws SQLException;
	
	/**
	 * Calls the procedure to execute when Apply button (for Intm Info) is pressed
	 *  and returns the map result for that procedure
	 * @param parId The Par ID
	 * @param itemGrp The item group
	 * @param intmNo The intermediary number
	 * @param intmNoNbt The non-base item intermediary number
	 * @param takeupSeqNo The takeup seq no.
	 * @param sharePercentage The share percentage
	 * @param sharePercentageNbt The non-base item share percentage
	 * @param prevSharePercentage The previous share percentage value
	 * @param lineCd The line code
	 * @param issCd The ISS code
	 * @param intmTypeNbt The intermediary type
	 * @param recordStatus The record status for current wcominvper record
	 * @param perilCd The peril code
	 * @param commissionAmt The commission amount
	 * @param commissionAmtNbt The non-base item commission amount
	 * @param premiumAmt The premium amount
	 * @param commissionRt The commission rate
	 * @param wholdingTax The withholding tax
	 * @param varRate The variable intermediary rate
	 * @return The map result of the procedure
	 * @throws SQLException
	 */
	Map<String, Object> getApplyBtnMap(int parId, int itemGrp, int intmNo, int intmNoNbt, int takeupSeqNo, BigDecimal sharePercentage, BigDecimal sharePercentageNbt,
			BigDecimal prevSharePercentage, String lineCd, String issCd, String intmTypeNbt, String recordStatus, String perilCd, BigDecimal commissionAmt, BigDecimal commissionAmtNbt,
			BigDecimal premiumAmt, BigDecimal commissionRate, BigDecimal wholdingTax) throws SQLException;
	
	/*Map<String, Object> populateWcommInvPerils(int parId, int itemGrp, int takeupSeqNo, String lineCd, int intmNo,
			String nbtIntmType, String nbtRetOrig, String perilCd, String nbtPerilCd,
			BigDecimal sharePercentage, BigDecimal prevSharePercentage, BigDecimal premiumAmt,
			BigDecimal commissionRate, BigDecimal commissionAmt, BigDecimal nbtCommissionAmt,
			BigDecimal wholdingTax, String issCd, BigDecimal varRate) throws SQLException;*/
	
	/**
	 * Calls the procedure to get the function that will be used to populate the WCOMINVPER block
	 * @param params
	 * @throws SQLException
	 */
	void populateWcommInvPerils(Map<String, Object> params) throws SQLException;
	
	/**
	 * Calls the procedure to validate intm no
	 * @param parId Par Id
	 * @param intmNo Intermediary number
	 * @param lineCd Line code
	 * @param lovTag LOV Tag
	 * @param globalCancelTag The Global Cancel Tag
	 * @return
	 * @throws SQLException
	 */
	Map<String, Object> validateIntmNo(int parId, int intmNo, String lineCd, String lovTag, String globalCancelTag) throws SQLException;
	
	/**
	 * Gets the par type and endt tax, for validation
	 * @param parId The Par ID
	 * @return
	 * @throws SQLException
	 */
	Map<String, Object> getParTypeAndEndtTax(int parId) throws SQLException;
	
	/**
	 * Executes some of the codes in WHEN-NEW-FORM-INSTANCE of GIPIS085, and loads the BANCA block record
	 * @param params
	 * @throws SQLException
	 */
	void executeGipis085WhenNewFormInstance(Map<String, Object> params) throws SQLException;
	
	/**
	 * Executes the procedure BANCASSURANCE.get_default_tax_rt
	 * @param params
	 * @throws SQLException
	 */
	void executeBancassuranceGetDefaultTaxRt(Map<String, Object> params) throws SQLException;
	
	/**
	 * Executes the procedure BANCASSURANCE.get_default_tax_rt
	 * @param params
	 * @throws SQLException
	 */
	void executeBancassuranceProcessCommission(Map<String, Object> params) throws SQLException;
	
	/**
	 * Validates the intm_no in GIPIS085
	 * @param params
	 * @throws SQLException
	 */
	void validateGipis085IntmNo(Map<String, Object> params) throws SQLException;
	
	/**
	 * Populates the WCOMINVPER block
	 * @param params
	 * @throws SQLException
	 */
	void populateWcommInvPerils2(Map<String, Object> params) throws SQLException;
	
	/**
	 * Executes the GET_INTMDRY_RATE procedure and gets the intermediary rate for the Comm Invoice Peril record
	 * @param params
	 * @throws SQLException
	 */
	void getIntmdryRate(Map<String, Object> params) throws SQLException;
	
	/**
	 * Executes the GET_ADJUST_INTMDRY_RATE procedure and gets the intermediary rate for the Comm Invoice Peril record
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	BigDecimal getAdjustIntmdryRate(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets the GIPI_WITMPERL records to be used for POPULATE_PACKAGE_PERILS function
	 * @param params
	 * @throws SQLException
	 */
	void populatePackagePerils(Map<String, Object> params) throws SQLException;
	
	/**
	 * Executes the GET_PACKAGE_INTM_RATE procedure and gets the intermediary rate for the Comm Invoice Peril record
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	BigDecimal getPackageIntmRate(Map<String, Object> params) throws SQLException;
	
	List<Map<String, Object>> prepareGIPIWCommInvoicesForDelete(JSONArray delRows) throws JSONException;
	
	/**
	 * Get initial values for package
	 * @param packParId
	 * @return
	 * @throws SQLException
	 */
	List<Map<String, Object>> getPackParlistParams(Integer packParId) throws SQLException;
	
	/**
	 * Used for preparing the table grid for record group WT_RATE in GIPIS085 (Invoice Commission)
	 * @param params
	 * @return
	 * @throws SQLException
	 * @throws JSONException
	 * @throws ParseException
	 */
	HashMap<String, Object> prepareWtRateRecordGroupMap(HashMap<String, Object> params) throws SQLException, JSONException, ParseException;
	
	/**
	 * Executes some of the codes in WHEN-NEW-FORM-INSTANCE of GIPIS160
	 * @param params
	 * @throws SQLException
	 */
	void executeGIPIS160WhenNewFormInstance(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets the table grid listing of gipi_wcomm_invoices records
	 * @param params
	 * @return
	 * @throws SQLException
	 * @throws JSONException
	 */
	Map<String, Object> getWCommInvoiceTableGridMap(Map<String, Object> params) throws SQLException, JSONException;
	
	/**
	 * @param params
	 * @throws SQLException
	 */
	void applySlidingCommission(Map<String, Object> params) throws SQLException;
	List<Integer> getCommInvDfltIntms(Map<String, Object> params) throws SQLException;
}
