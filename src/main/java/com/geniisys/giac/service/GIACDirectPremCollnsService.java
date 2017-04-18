/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.framework.util.PaginatedList;

/**
 * The Interface GIACBranchService.
 */
public interface GIACDirectPremCollnsService {

	/**
	 * Validate Bill No and retrieve details.
	 * 
	 * @return the Direct Prem Collns details, message
	 * @throws SQLException the sQL exception
	 */
	
	Map<String, Object> validateBillNo(Map<String, Object> params) throws SQLException;
	
	/**
	 * Validate Open Policy and retrieve details.
	 * 
	 * @return the Direct Prem Collns details, message
	 * @throws SQLException the sQL exception
	 */
	
	Map<String, Object> validateOpenPolicy(Map<String, Object> params) throws SQLException;
	
	/**
	 * Get invoice listing.
	 * 
	 * @return the invoice listing
	 * @throws SQLException the sQL exception
	 */
	
	PaginatedList getInvoiceListing(Map<String, Object> params, Integer pageNo) throws SQLException;
	
	/**
	 * Get invoice listing.
	 * 
	 * @return the invoice listing
	 * @throws SQLException the sQL exception
	 */
	
	Map<String, Object> getDefaultTaxValueType(Map<String, Object> params, Integer taxType) throws SQLException;
	
	/**
	 * Save directPremCollns details.
	 * 
	 * @throws SQLException the sQL exception
	 */
	String saveDirectPremCollnsDtls(Map<String, Object> allParams) throws SQLException;
	
	/**
	 * Gets directPremCollns details.
	 * @param gacc_tra_id
	 * @throws SQLException the sQL exception
	 */
	List<Map<String, Object>> getDirectPremCollnsDtls(Integer gacc_tran_id) throws SQLException;
	
	/**
	 * Save directPremCollns accounting details.
	 * 
	 * @throws SQLException the sQL exception
	 */
	void saveDirectPremCollnsAcctDtls(Map<String, Object> allParams) throws SQLException;
	
	Map<String, Object> validateRecord(Map<String, Object> params) throws SQLException;
	
	HashMap<String, Object> getInvoiceListingTableGrid (HashMap<String, Object> params) throws SQLException, JSONException;

	Map<String, Object> getEnteredBillDetails(Map<String, Object> param) throws SQLException;

	List<Map<String, Object>> getInvoiceListing(Map<String, Object> param)
			throws SQLException;
	
	/**
	 * Returns Direct Premium Collection for a given invoice
	 * @param a HashMap containing table grid parameters 
	 * 		    plus issCd and premSeqNo
	 * @returns HashMap that contains list of Direct Premium Collections
	 * @throws  SQLException
	 */
	HashMap<String, Object> getRelatedDirectPremCollns(HashMap<String, Object> params) throws SQLException;
	
	List<Map<String, Object>> getPolicyInvoices(Map<String, Object> params) throws SQLException;
	
	String validateGIACS007PremSeqNo(Map<String, Object> params) throws SQLException, JSONException;
	
	Map<String, Object> setPremTaxTranType(Map<String, Object> params) throws SQLException;
	
	String checkIfInvoiceExists(Map<String, Object> params) throws SQLException;
	
	String getIncTagForAdvPremPayts(Map<String, Object> params) throws SQLException;
	
	String checkSpecialBill(Map<String, Object> params) throws SQLException;
	
	Map<String, Object> getDirectPremTotals(Map<String, Object> params) throws SQLException;
	
	Integer getNumberOfInst(Map<String, Object> params)throws SQLException;
	
	Map<String, Object> validatePolicy(HttpServletRequest request)throws SQLException;
	
	String checkPreviousInst(Map<String, Object> params) throws SQLException;
}
