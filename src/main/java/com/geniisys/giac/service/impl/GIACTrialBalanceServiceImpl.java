package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.giac.dao.GIACTrialBalanceDAO;
import com.geniisys.giac.service.GIACTrialBalanceService;

public class GIACTrialBalanceServiceImpl implements GIACTrialBalanceService{
	
	private GIACTrialBalanceDAO giacTrialBalanceDAO;
	
	public GIACTrialBalanceDAO getGiacTrialBalanceDAO() {
		return giacTrialBalanceDAO;
	}

	public void setGiacTrialBalanceDAO(GIACTrialBalanceDAO giacTrialBalanceDAO) {
		this.giacTrialBalanceDAO = giacTrialBalanceDAO;
	}
	
	@Override
	public String validateTransactionDate(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("transactionDate", request.getParameter("transactionDate"));
		return this.getGiacTrialBalanceDAO().validateTransactionDate(params);
	}

	@Override
	public String checkTranOpen(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("transactionDate", request.getParameter("transactionDate"));
		params.put("includeMonths", request.getParameter("includeMonths"));
		params.put("includeYears", request.getParameter("includeYears"));
		return this.getGiacTrialBalanceDAO().checkTranOpen(params);
	}

	@Override
	public String checkDate(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("transactionDate", request.getParameter("transactionDate"));
		return this.getGiacTrialBalanceDAO().checkDate(params);
	}

	@Override
	public void backUpGiacMonthlyTotals(String transactionDate, String userId)
			throws SQLException {
		this.getGiacTrialBalanceDAO().backUpGiacMonthlyTotals(transactionDate, userId);
	}

	@Override
	public void updateAcctransAe(String transactionDate,
			String updateActionOpt, String userId) throws SQLException {
		this.getGiacTrialBalanceDAO().updateAcctransAe(transactionDate, updateActionOpt, userId);
	}

	@Override
	public String genTrialBalance(String transactionDate, String userId) throws SQLException {
		return this.getGiacTrialBalanceDAO().genTrialBalance(transactionDate, userId);
	}



}
