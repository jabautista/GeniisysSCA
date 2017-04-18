/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	rencela
 * Create Date	:	Nov 11, 2010
 ***************************************************/
package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gicl.entity.GICLClaimLossExpense;

public interface GICLClaimLossExpenseDAO {
	
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
	
	/**
	 * 
	 * @param claimLossExpense
	 * @throws SQLException
	 */
	void setClaimLossExpense(GICLClaimLossExpense claimLossExpense) throws SQLException;
	
	Integer getNextClmLossIdValue(Integer claimId) throws SQLException;
	
	void saveLossExpenseHistory(Map<String, Object> params) throws SQLException, Exception;
	
	String validateHistSeqNo(Map<String, Object> params) throws SQLException;
	
	void cancelHistory(Map<String, Object> params) throws SQLException, Exception;
	
	void clearHistory(Map<String, Object> params) throws SQLException, Exception;
	
	String copyHistory(Map<String, Object> params) throws SQLException, Exception;
	
	void checkHistoryNumber(Map<String, Object> params) throws SQLException; //Kenneth 06162015 SR 3616
	
}
