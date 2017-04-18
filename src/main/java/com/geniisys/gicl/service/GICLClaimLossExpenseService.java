/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	rencela
 * Create Date	:	Nov 11, 2010
 ***************************************************/
package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gicl.entity.GICLClaimLossExpense;

public interface GICLClaimLossExpenseService {
	
	/**
	 * Retrieve the claim loss expense using :claimId, : claimLossExpense
	 * @param claimId
	 * @param claimLossId
	 * @return the claimLossExpense
	 * @throws SQLException
	 */
	GICLClaimLossExpense getClaimLossExpense(Integer claimId, Integer claimLossId) throws SQLException;
	
	/**
	 * Retrieve A DCP's Claim Loss Expense, checking transType in the process
	 * @param transType
	 * @param lineCd
	 * @param adviceId
	 * @param claimId
	 * @param claimLossId
	 * @return the Claim Loss Expense
	 * @throws SQLException
	 */
	GICLClaimLossExpense getClaimLossExpenseByTransType(Integer transType, String lineCd, Integer adviceId, Integer claimId, Integer claimLossId) throws SQLException;
	
	String getClmHistInfo(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	
	Map<String, Object> getSettlementHist(HttpServletRequest request, GIISUser USER)throws SQLException, JSONException;
	
	Integer getNextClmLossIdValue(Integer claimId) throws SQLException;
	
	void saveLossExpenseHistory(HttpServletRequest request, GIISUser USER) throws SQLException, Exception;
	
	String validateHistSeqNo(Map<String, Object> params) throws SQLException;
	
	void cancelHistory(HttpServletRequest request, GIISUser USER) throws SQLException, Exception;
	
	void clearHistory(HttpServletRequest request, GIISUser USER) throws SQLException, Exception;
	
	String copyHistory(HttpServletRequest request, GIISUser USER) throws SQLException, Exception;

	void checkHistoryNumber(HttpServletRequest request) throws SQLException;//kenneth 06162015 SR3616
	
}
