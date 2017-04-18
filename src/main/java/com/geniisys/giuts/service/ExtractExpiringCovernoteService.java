package com.geniisys.giuts.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import com.sun.org.apache.xerces.internal.impl.xpath.regex.ParseException;

public interface ExtractExpiringCovernoteService {
	
	String whenNewFormInstanceGIUTS031(HttpServletRequest request, String userId) throws SQLException;
	String extractGIUTS031(HttpServletRequest request, String userId) throws SQLException, ParseException;
	String validateExtractParameters(HttpServletRequest request, String userId) throws SQLException;
}
