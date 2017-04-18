/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.entity.GIACDirectPremCollns;

/**
 * The Interface GIACDirectPremCollnsDAO.
 */
public interface GIACDirectPremCollnsDAO {
	/**
	 * Gets the map details.
	 * 
	 * @param iss_cd, prem seq no
	 * @return the map
	 * @throws SQLException the sQL exception
	 */
	Map<String, Object> validateBillNo(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets the map details.
	 * 
	 * @param iss_cd, prem seq no
	 * @return the map
	 * @throws SQLException the sQL exception
	 */
	Map<String, Object> validateOpenPolicy(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets the map details.
	 * 
	 * @param iss_cd, prem seq no
	 * @return the map
	 * @throws SQLException the sQL exception
	 */
	List<Map<String, Object>> getInvoiceListing(Map<String, Object> params) throws SQLException;
	
	List<Map<String, Object>> getInvoiceListingForPartial(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets the map details.
	 * 
	 * @return the map
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
	
	/**
	 * check if the invoice being paid is a special policy and
	 * check if the system accepts payment for special policy
	 * @throws SQLException the sQL exception
	 * added by alfie: 12.22.2010
	 */
	Map<String, Object> checkPremiumPaytForSpecial(Map<String, Object> param) throws SQLException;
	
	List<Map<String, Object>> getInvoiceListingTableGrid (HashMap<String, Object> params) throws SQLException;

	Map<String, Object> getEnteredBillDetails(Map<String, Object> param) throws SQLException;
	
	/**
	 * Returns Direct Premium Collection for a given invoice
	 * @param a HashMap containing table grid parameters 
	 * 		    plus issCd and premSeqNo
	 * @returns list of Direct Premium Collections
	 * @throws  SQLException
	 */
	List<GIACDirectPremCollns> getRelatedDirectPremCollns(HashMap<String,Object> params) throws SQLException;
	
	List<Map<String, Object>> getPolicyInvoices(Map<String, Object> params) throws SQLException;
	
	Map<String, Object> validateGIACS007PremSeqNo(Map<String, Object> params) throws SQLException;
	
	Map<String, Object> setPremTaxTranType(Map<String, Object> params) throws SQLException;
	
	String checkIfInvoiceExists(Map<String, Object> params) throws SQLException;
	
	String getIncTagForAdvPremPayts(Map<String, Object> params) throws SQLException;
	
	String checkSpecialBill(Map<String, Object> params) throws SQLException;
	
	Map<String, Object> getDirectPremTotals(Map<String, Object> params) throws SQLException;
	
	Integer getNumberOfInst(Map<String, Object>params) throws SQLException;
	
	Map<String, Object> validatePolicy(Map<String, Object> params) throws SQLException;
	
	String checkPreviousInst(Map<String, Object> params) throws SQLException;
}
