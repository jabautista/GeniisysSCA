package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIACTrialBalanceDAO {
	
	String validateTransactionDate (Map<String, Object> params) throws SQLException;
	String checkTranOpen (Map<String, Object> params) throws SQLException;
	String checkDate (Map<String, Object> params) throws SQLException;
	void backUpGiacMonthlyTotals(String transactionDate, String userId) throws SQLException;
	void updateAcctransAe(String transactionDate, String updateActionOpt, String userId) throws SQLException;
	String genTrialBalance(String transactionDate, String userId) throws SQLException;
	
}
