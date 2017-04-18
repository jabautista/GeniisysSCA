package com.geniisys.giac.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

public interface GIACTrialBalanceService {
	
	String validateTransactionDate(HttpServletRequest request) throws SQLException;
	String checkTranOpen (HttpServletRequest request) throws SQLException;
	String checkDate (HttpServletRequest request) throws SQLException;
	void backUpGiacMonthlyTotals(String transactionDate, String userId) throws SQLException;
	void updateAcctransAe(String transactionDate, String updateActionOpt, String userId) throws SQLException;
	String genTrialBalance (String transactionDate, String userId) throws SQLException;
}
