package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACTrialBalanceDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACTrialBalanceDAOImpl implements GIACTrialBalanceDAO{
	
	private Logger log = Logger.getLogger(GIACTrialBalanceDAOImpl.class);
	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public String validateTransactionDate(Map<String, Object> params)
			throws SQLException {
		log.info("validating transaction date..." + params);
		return (String) this.getSqlMapClient().queryForObject("validateTransactionDate", params);
	}

	@Override
	public String checkTranOpen(Map<String, Object> params) throws SQLException {
		log.info("checking if there are open transactions..." + params);
		return (String) this.getSqlMapClient().queryForObject("checkTranOpen", params);
	}

	@Override
	public String checkDate(Map<String, Object> params) throws SQLException {
		log.info("validating date if gl is closed or trial balance is closed or date is an additional run..." + params);
		return (String) this.getSqlMapClient().queryForObject("checkDate", params);
	}

	@Override
	public void backUpGiacMonthlyTotals(String transactionDate, String userId) throws SQLException {
		try {
			
			HashMap<String ,Object> myMap = new HashMap<String ,Object>();
			myMap.put("transactionDate", transactionDate);
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().delete("delGiacMonthlyTotalsBackUp");
			
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().insert("insGiacMonthlyTotalsBackUp", myMap);
			
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
			System.out.println("DAO - GIAC_MONTHLY_TOTALS_BACKUP saved...");
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
			System.out.println("Record/s are committed!");
		}	
	}

	@Override
	public void updateAcctransAe(String transactionDate,
			String updateActionOpt, String userId) throws SQLException {
		
		try {
			HashMap<String ,Object> myMap = new HashMap<String ,Object>();
			myMap.put("transactionDate", transactionDate);
			myMap.put("updateActionOpt", updateActionOpt);
			myMap.put("userId", userId);
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("updateAcctransAe", myMap);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
			System.out.println("DAO - Update on GIAC_ACCTRANS/GIAC_ACCT_ENTRY is commited...");
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
			System.out.println("Record/s are committed!");
		}	
	}

	@Override
	public String genTrialBalance(String transactionDate, String userId) throws SQLException {
		String noOfRecords;
		HashMap<String ,Object> myMap = new HashMap<String ,Object>();
		myMap.put("transactionDate", transactionDate);
		myMap.put("userId", userId);
		
		noOfRecords = (String) this.getSqlMapClient().queryForObject("getNoOfRecords", myMap);
		
		this.getSqlMapClient().startTransaction();
		this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
		this.getSqlMapClient().startBatch();
		
		this.getSqlMapClient().delete("delGiacMonthlyTotals", myMap);
		this.getSqlMapClient().executeBatch();
		
		this.getSqlMapClient().insert("insGiacMonthlyTotals", myMap);
		
		this.getSqlMapClient().executeBatch();
		
		this.getSqlMapClient().getCurrentConnection().commit();
		System.out.println("DAO - GIAC_MONTHLY_TOTALS saved...");
		
		return noOfRecords;
	}


}
