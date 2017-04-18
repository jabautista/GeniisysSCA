/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	GIACS017
 * Create Date	:	Oct 4, 2010
 ***************************************************/
package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.springframework.context.ApplicationContext;

import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.giac.entity.GIACDirectClaimPayment;
import com.geniisys.gicl.entity.GICLClaims;

/**
 * 
 * @author rencela
 * @version 1.0
 */
public interface GIACDirectClaimPaymentService{
	
	/**
	 * Create an arraylist of GIACDirectClaimPayment objects.
	 * @param rows
	 * @param userId
	 * @return list of direct claim payment objects
	 * @throws JSONException
	 */
	List<GIACDirectClaimPayment> prepareDirectClaimPaymentJSON(JSONArray rows, String userId) throws JSONException;
	
	/**
	 * Get the Details of the Claim Id retrieved from advice Sequence Number
	 * @param claimId from advice Sequence
	 * @return Claim entity details
	 * @throws SQLException
	 */
	GICLClaims getClaimDetails(Integer claimId) throws SQLException;
	
	/**
	 * Computes the :inputVatAmount, :withholdingTaxAmount, :netDisbursementAmount
	 * @param Map containing the FF
	 * 			vCheck - IN OUT
	 * 			gaccTranId - IN
	 * 			claimId - IN
	 *	 		claimLossId - IN
	 * 			adviceId - IN
	 * 			inputVatAmount of the row
	 * 			withholdingTaxAmount of the row
	 * 			netDisbursementAmount of the row
	 * @return the same parameters, with updated values for
	 * @throws SQLException
	 */
	Map<String, Object> computeAdviceDefaultAmount(Map<String, Object> params) throws SQLException;
	
	/**
	 * Get Advice Sequence Listing based on keyword
	 * @param params
	 * @param pageNo
	 * @return
	 * @throws SQLException
	 */
	PaginatedList getAdviceSequenceListing(String moduleId, String keyword, Integer pageNo) throws SQLException; 
	
	/**
	 * Execute preInsert
	 * @throws SQLException
	 * @throws JSONException 
	 */
	void saveDirectClaimPayments(HttpServletRequest request, String userId) throws SQLException, JSONException;
	
	/**
	 * Retrieve list of direct claim payments based on :gaccTranId
	 * @param gaccTranId
	 * @return List of Direct Claim Payments 
	 * @throws SQLException
	 */
	List<GIACDirectClaimPayment> getDirectClaimPaymentByGaccTranId(Integer gaccTranId) throws SQLException;
	
	/**
	 * Retrieve list of direct claim payments based on :gaccTranId AND get their Claim Loss
	 * @param gaccTranId
	 * @return List of Direct Claim Payments 
	 * @throws SQLException
	 */
	List<GIACDirectClaimPayment> getDirectClaimPaymentByGaccTranId(ApplicationContext applicationContext, Integer gaccTranId) throws SQLException;
	
	/** 
	 * Execute Post Forms Commit functions for Direct Claim Payments
	 * @param params
	 * @return the same map, with [possibly]updated generationType/itemNo/moduleId
	 * @throws SQLException
	 */
	Map<String, Object> dcpPostFormsCommit (Map<String, Object> params)throws SQLException;
	
	public void showClaimAdviceModal(HttpServletRequest request, String userId)  throws SQLException, JSONException;
	
	void newFormInstanceGIACS017 (HttpServletRequest request, GIACParameterFacadeService giacParameterService, LOVHelper helper, String userId) throws SQLException, JSONException;
	
	void getGICLDirectClaimPaytTG (HttpServletRequest request) throws SQLException, JSONException;
	
	List<Map<String, Object>> getDCPFromAdvice(String param, String userId) throws SQLException, JSONException;
	
	void showBatchClaimModal(HttpServletRequest request, String userId) throws SQLException, JSONException;
	
	Map<String, Object> getEnteredAdviceDetails(HttpServletRequest request, String userId) throws SQLException;
	
	List<Map<String, Object>> getDCPFromBatch(String param, String userId) throws SQLException, JSONException;
	
	List<Map<String, Object>> getListOfPayees(HttpServletRequest request) throws SQLException, JSONException;
}