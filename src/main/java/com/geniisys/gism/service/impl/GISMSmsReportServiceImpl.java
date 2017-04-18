package com.geniisys.gism.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.gism.dao.GISMSmsReportDAO;
import com.geniisys.gism.service.GISMSmsReportService;

public class GISMSmsReportServiceImpl implements GISMSmsReportService{
	
	private GISMSmsReportDAO gismSmsReportDAO;

	@Override
	public Map<String, Object> populateSmsReportPrint(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("user", request.getParameter("user"));
		return this.getGismSmsReportDAO().populateSmsReportPrint(params);
	}

	public GISMSmsReportDAO getGismSmsReportDAO() {
		return gismSmsReportDAO;
	}

	public void setGismSmsReportDAO(GISMSmsReportDAO gismSmsReportDAO) {
		this.gismSmsReportDAO = gismSmsReportDAO;
	}

	@Override
	public Map<String, Object> validateGisms012User(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("user", request.getParameter("user"));
		return gismSmsReportDAO.validateGisms012User(params);
	}

}
