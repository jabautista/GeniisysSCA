package com.geniisys.gixx.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.gixx.dao.GIXXProdBudgetDAO;
import com.geniisys.gixx.service.GIXXProdBudgetService;

public class GIXXProdBudgetServiceImpl implements GIXXProdBudgetService{

	private GIXXProdBudgetDAO gixxProdBudgetDAO;

	public GIXXProdBudgetDAO getGixxProdBudgetDAO() {
		return gixxProdBudgetDAO;
	}

	public void setGixxProdBudgetDAO(GIXXProdBudgetDAO gixxProdBudgetDAO) {
		this.gixxProdBudgetDAO = gixxProdBudgetDAO;
	}

	@Override
	public Map<String, Object> extractBudgetProduction(HttpServletRequest request,
			String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("issCd", request.getParameter("issCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("dateParam", request.getParameter("dateParam"));
		params.put("issParam", request.getParameter("issParam"));
		params.put("specialPol", request.getParameter("specialPol"));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", userId);
		return this.getGixxProdBudgetDAO().extractBudgetProduction(params);
	}
	
}
