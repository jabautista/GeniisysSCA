package com.geniisys.giri.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIRIGenerateRIReportsDAO {
	// Gets the default currency for GIRIS051 (Generate RI Reports - Binder Tab)
	public int getDefaultCurrency() throws SQLException;
	public Map<String, Object> validateBndRnwl(Map<String, Object> params) throws SQLException;
	public Map<String, Object> checkRiReportsBinderRecord(Map<String, Object> params) throws SQLException;
	public int checkRiReportsBinderReplaced(Map<String, Object> params) throws SQLException;
	public int checkRiReportsBinderNegated(Map<String, Object> params) throws SQLException;
	public Map<String, Object> updateGIRIBinder(Map<String, Object> params) throws SQLException;
	public Map<String, Object> updateGIRIGroupBinder(Map<String, Object> params) throws SQLException;
	public void insertBinderPerilPrintHist(Map<String, Object> params) throws SQLException;
	public Map<String, Object> getGIRIR121FnlBinderId(Map<String, Object> params) throws SQLException;
	
	public Integer getReinsurerCd(String riName) throws SQLException;
	public String checkOARPrintDate(Map<String, Object> params) throws SQLException;
	public void updateOARPrintDate(Map<String, Object> params) throws SQLException;
	
	public Map<String, Object> validateRiSname(Map<String, Object> params) throws SQLException;
	public Integer getExtractInwTran(Map<String, Object> params) throws SQLException;
	public void deleteGiixInwTran(Map<String, Object> params) throws SQLException;
	
	public String validateRiTypeDesc(String riTypeDesc) throws SQLException;
	
	public Map<String, Object> getReciprocityDetails1(Map<String, Object> params) throws SQLException;
	public Map<String, Object> getReciprocityDetails2(Map<String, Object> params) throws SQLException;
	public Map<String, Object> getReciprocityInitialValues(Map<String, Object> params) throws SQLException;
	public Integer getReciprocityRiCd(Map<String, Object> params) throws SQLException;
	public Map<String, Object> extractReciprocity(Map<String, Object> params) throws SQLException;
	public Integer getExtractedReciprocity(Map<String, Object> params) throws SQLException;
	public String updateAprem(Map<String, Object> params) throws SQLException;
	public void updateCprem(Map<String, Object> params) throws SQLException;
	
}
