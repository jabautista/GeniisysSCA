/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	GIACS017
 * Create Date	:	October 6, 2010
 ***************************************************/
package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.entity.GIACDirectClaimPayment;
import com.geniisys.gicl.entity.GICLAdvice;
import com.geniisys.gicl.entity.GICLClaims;

public interface GIACDirectClaimPaymentDAO {
	
	/**
	 * Get the Details of the Claim Id retrieved from advice Sequence Number
	 * @param claimId from advice Sequence
	 * @return Claim entity details
	 * @throws SQLException
	 */
	GICLClaims getClaimDetails(Integer claimId) throws SQLException;
	
	/**
	 * Computes/Calls the Disbursement
	 * Map mapContents ->
			 * vCheck
			 * transactionType
			 * gaccTransId
			 * claimId
			 * claimLossId
			 * adviceId
			 * inputVatAmount -
			 * withholdingTaxAmount -
			 * netDisbursementAmount -
			 * sumWithholdingAmount -
			 * sumDspNetAmount -
			 * sumInputAmount -
	 * @return the updated mapContents
	 * @throws SQLException
	 */
	Map<String, Object> computeAdviceDefaultAmount(Map<String, Object> params) throws SQLException;
	
	/**
	 * Search Advice Listing having :keyword. If keyword is blank,  return all advices
	 * @param moduleId
	 * @param keyword
	 * @return 
	 * @throws SQLException
	 */
	List<GICLAdvice> getAdviceSequenceListing(String moduleId, String keyword)throws SQLException;
	
	/**
	 * Save individual Direct Claim Payments passed by GIACDIrectClaimPaymentServiceDAO.saveDirectClaimPayments
	 * @param directClaimPayment
	 * @throws SQLException
	 */
	void saveDirectClaimPayment1(GIACDirectClaimPayment directClaimPayment) throws SQLException;
	
	/**
	 * Save all direct claim payments
	 * @param params
	 * @return return message String
	 * @throws SQLException
	 */
	void saveDirectClaimPayments(Map<String, Object> params) throws SQLException;
	
	/**
	 * Retrieve list of direct claim payments based on :gaccTranId
	 * @param gaccTranId
	 * @return List of Direct Claim Payments 
	 * @throws SQLException
	 */
	List<GIACDirectClaimPayment> getDirectClaimPaymentByGaccTranId(Integer gaccTranId) throws SQLException;
	
	/** 
	 * Execute Post Forms Commit functions for Direct Claim Payments
	 * @param PARAMETER MAP
	 * 	gaccTranId - Integer, transSource - String,	orFlag - String, gaccFundCd - String,
		gaccBranchCd - String, claimId - Integer, adviceId - Integer, payeeClassCd - String,
		payeeCd - Integer, convertRate - BigDecimal, issueCode - String, moduleName - String,
		generationType - String, itemNo - Integer, moduleId - Integer
	 * @return the same map, with [possibly]updated generationType/itemNo/moduleId
	 * @throws SQLException
	 */
	Map<String, Object> dcpPostFormsCommit (Map<String, Object> params)throws SQLException;
	
	Map<String, Object> getGDCPAmountSum (Integer gaccTranId) throws SQLException;
	
	Map<String, Object> getDCPFromClaim(Map<String, Object> params, String action) throws SQLException;
	
	Map<String, Object> getEnteredAdviceDetails(Map<String, Object> params) throws SQLException;
	
	List<Map<String, Object>> getDCPFromBatch(Map<String, Object> params) throws SQLException;
	
	List<Map<String, Object>> getListOfPayees(Map<String, Object> params) throws SQLException;
}