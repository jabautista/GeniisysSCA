package com.geniisys.giuts.service.impl;

import java.sql.SQLException;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONObject;

import com.geniisys.giuts.dao.ExtractExpiringCovernoteDAO;
import com.geniisys.giuts.service.ExtractExpiringCovernoteService;
import com.sun.org.apache.xerces.internal.impl.xpath.regex.ParseException;

public class ExtractExpiringCovernoteServiceImpl implements ExtractExpiringCovernoteService{
	
	private ExtractExpiringCovernoteDAO extractExpiringCovernoteDAO;

	public ExtractExpiringCovernoteDAO getExtractExpiringCovernoteDAO() {
		return extractExpiringCovernoteDAO;
	}


	public void setExtractExpiringCovernoteDAO(
			ExtractExpiringCovernoteDAO extractExpiringCovernoteDAO) {
		this.extractExpiringCovernoteDAO = extractExpiringCovernoteDAO;
	}
	
	@Override
	public String whenNewFormInstanceGIUTS031(HttpServletRequest request, String userId)
			throws SQLException {
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		JSONObject result = new JSONObject(this.extractExpiringCovernoteDAO.whenNewFormInstanceGIUTS031(params));
		return result.toString();
	}


	@Override
	public String extractGIUTS031(HttpServletRequest request, String userId)
			throws SQLException, ParseException {
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("paramType", request.getParameter("paramType"));
		params.put("fromDate", request.getParameter("fromDate")); 
		params.put("toDate", request.getParameter("toDate"));
		params.put("fromMonth", request.getParameter("fromMonth"));
		params.put("fromYear", request.getParameter("fromYear"));
		params.put("toMonth", request.getParameter("toMonth"));
		params.put("toYear", request.getParameter("toYear"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("credBranchParam", request.getParameter("credBranchParam"));
		JSONObject result = new JSONObject(this.getExtractExpiringCovernoteDAO().extractGIUTS031(params));
		return result.toString();
	}


	@Override
	public String validateExtractParameters(HttpServletRequest request,
			String userId) throws SQLException {
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		System.out.println("validateExtractParameters parameters :::::::::::::::::::::::::::: " + params);
		System.out.println(this.extractExpiringCovernoteDAO.validateExtractParameters(params));
		JSONObject result = new JSONObject(this.extractExpiringCovernoteDAO.validateExtractParameters(params));
		return result.toString();
	}

}
