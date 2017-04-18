package com.geniisys.giri.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.common.entity.GIISUser;

public interface GIRIGenerateRIReportsService {
	
	// Gets the default currency for GIRIS051 (Generate RI Reports - Binder Tab)
	public int getDefaultCurrency() throws SQLException;
	public Map<String, Object> validateBndRnwl(Map<String, Object> params) throws SQLException;
	public Map<String, Object> checkRiReportsBinderRecord(HttpServletRequest request) throws SQLException;
	public int checkBinderReplaced(Map<String, Object> params) throws SQLException;
	public int checkBinderNegated(Map<String, Object> params) throws SQLException;
	public Map<String, Object> updateGIRIBinder(Map<String, Object> params) throws SQLException;
	public Map<String, Object> updateGIRIGroupBinder(Map<String, Object> params) throws SQLException;
	public void insertBinderPerilPrintHist(Map<String, Object> params)throws SQLException;
	public Map<String, Object> getGIRIR121FnlBinderId(Map<String, Object> params) throws SQLException;
	
	public Integer getReinsurerCd(String riName) throws SQLException;
	public String checkOARPrintDate(HttpServletRequest request) throws SQLException, ParseException;
	public void updateOARPrintDate(HttpServletRequest request) throws SQLException, ParseException;
	
	public Map<String, Object> validateRiSname(HttpServletRequest request) throws SQLException;
	public Integer getExtractInwTran(HttpServletRequest request, GIISUser user) throws SQLException;
	public void deleteGiixInwTran(HttpServletRequest request, GIISUser user) throws SQLException;
	
	public String validateRiTypeDesc(String riTypeDesc) throws SQLException;
	
	public Map<String, Object> getReciprocityDetails1(GIISUser USER) throws SQLException;
	public Map<String, Object> getReciprocityDetails2(GIISUser USER) throws SQLException;
	public Map<String, Object> getReciprocityInitialValues(GIISUser USER) throws SQLException;
	public Integer getReciprocityRiCd(HttpServletRequest request, GIISUser user) throws SQLException, ParseException;
	public Map<String, Object> extractReciprocity(HttpServletRequest request) throws SQLException;
	public Integer getExtractedReciprocity(HttpServletRequest request, GIISUser user) throws SQLException, ParseException;
	public String updateFacAmts(HttpServletRequest request, GIISUser USER) throws SQLException;
}
