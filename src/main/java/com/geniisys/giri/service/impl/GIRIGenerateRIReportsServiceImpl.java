package com.geniisys.giri.service.impl;

import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.giri.dao.GIRIGenerateRIReportsDAO;
import com.geniisys.giri.service.GIRIGenerateRIReportsService;

public class GIRIGenerateRIReportsServiceImpl implements GIRIGenerateRIReportsService{

	private GIRIGenerateRIReportsDAO giriGenerateRIReportsDAO;
	
	public GIRIGenerateRIReportsDAO getGiriGenerateRIReportsDAO() {
		return giriGenerateRIReportsDAO;
	}
	public void setGiriGenerateRIReportsDAO(GIRIGenerateRIReportsDAO giriGenerateRIReportsDAO) {
		this.giriGenerateRIReportsDAO = giriGenerateRIReportsDAO;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giri.service.GIRIGenerateRIReportsService#getDefaultCurrency()
	 */
	@Override
	public int getDefaultCurrency() throws SQLException {
		return getGiriGenerateRIReportsDAO().getDefaultCurrency();
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giri.service.GIRIGenerateRIReportsService#validateBndRnwl(java.util.Map)
	 */
	@Override
	public Map<String, Object> validateBndRnwl(Map<String, Object> params) throws SQLException {
		return this.giriGenerateRIReportsDAO.validateBndRnwl(params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giri.service.GIRIGenerateRIReportsService#checkRiReportsBinderRecords(javax.servlet.http.HttpServletRequest)
	 */
	@Override
	public Map<String, Object> checkRiReportsBinderRecord(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("binderYy", Integer.parseInt(request.getParameter("binderYy")));
		params.put("binderSeqNo", Integer.parseInt(request.getParameter("binderSeqNo")));
		params.put("isLineCd", request.getParameter("isLineCd"));
		params.put("remarksSw", request.getParameter("remarksSw"));
		params.put("localCurr", Integer.parseInt(request.getParameter("localCurr")));
		
		return this.giriGenerateRIReportsDAO.checkRiReportsBinderRecord(params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giri.service.GIRIGenerateRIReportsService#checkBinderReplaced(java.util.Map)
	 */
	@Override
	public int checkBinderReplaced(Map<String, Object> params) throws SQLException {
		return this.giriGenerateRIReportsDAO.checkRiReportsBinderReplaced(params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giri.service.GIRIGenerateRIReportsService#checkBinderNegated(java.util.Map)
	 */
	@Override
	public int checkBinderNegated(Map<String, Object> params) throws SQLException {
		return this.getGiriGenerateRIReportsDAO().checkRiReportsBinderNegated(params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giri.service.GIRIGenerateRIReportsService#updateBinderPrintedDateCount(java.util.Map)
	 */
	@Override
	public Map<String, Object> updateGIRIBinder(Map<String, Object> params) throws SQLException {
		return this.getGiriGenerateRIReportsDAO().updateGIRIBinder(params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giri.service.GIRIGenerateRIReportsService#updateGIRIGroupBinder(java.util.Map)
	 */
	@Override
	public Map<String, Object> updateGIRIGroupBinder(Map<String, Object> params) throws SQLException {
		return this.giriGenerateRIReportsDAO.updateGIRIGroupBinder(params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giri.service.GIRIGenerateRIReportsService#insertBinderPerilPrintHist(java.util.Map)
	 */
	@Override
	public void insertBinderPerilPrintHist(Map<String, Object> params) throws SQLException {
		this.giriGenerateRIReportsDAO.insertBinderPerilPrintHist(params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giri.service.GIRIGenerateRIReportsService#getGIRIR121FnlBinderId(java.util.Map)
	 */
	@Override
	public Map<String, Object> getGIRIR121FnlBinderId(Map<String, Object> params) throws SQLException {
		return this.giriGenerateRIReportsDAO.getGIRIR121FnlBinderId(params);
	}
	
	@Override
	public Integer getReinsurerCd(String riName) throws SQLException {
		return this.giriGenerateRIReportsDAO.getReinsurerCd(riName);
	}
	
	@Override
	public String checkOARPrintDate(HttpServletRequest request) throws SQLException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("riCd", request.getParameter("riCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("asOfDate", new java.text.SimpleDateFormat("MM-dd-yyyy").parse(request.getParameter("asOfDate")));
		params.put("moreThan", Integer.parseInt(request.getParameter("moreThan")));
		params.put("lessThan", Integer.parseInt(request.getParameter("lessThan")));
		System.out.println("checkOARPrintDate : " + params.toString());
		
		return this.giriGenerateRIReportsDAO.checkOARPrintDate(params);
	}
	
	@Override
	public void updateOARPrintDate(HttpServletRequest request) throws SQLException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("riCd", request.getParameter("riCd"));
		params.put("lineCd", request.getParameter("lineCd"));		
		params.put("asOfDate", new java.text.SimpleDateFormat("MM-dd-yyyy").parse(request.getParameter("asOfDate")));
		params.put("moreThan", Integer.parseInt(request.getParameter("moreThan")));
		params.put("lessThan", Integer.parseInt(request.getParameter("lessThan")));
		params.put("printChk", request.getParameter("printChk"));
		
		this.giriGenerateRIReportsDAO.updateOARPrintDate(params);
	}
	@Override
	public Map<String, Object> validateRiSname(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("riSname", request.getParameter("riSname"));
		
		return giriGenerateRIReportsDAO.validateRiSname(params);
	}
	
	@Override
	public void deleteGiixInwTran(HttpServletRequest request, GIISUser user) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("extractId", Integer.parseInt(request.getParameter("extractId")));
		params.put("userId", user.getUserId());
		System.out.println(params.toString());
		
		giriGenerateRIReportsDAO.deleteGiixInwTran(params);
	}
	
	@Override
	public Integer getExtractInwTran(HttpServletRequest request, GIISUser user) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("riCd", request.getParameter("riCd"));
		params.put("expiryMonth", request.getParameter("expiryMonth"));
		params.put("expiryYear",request.getParameter("expiryYear"));
		params.put("acceptMonth", request.getParameter("acceptMonth"));
		params.put("acceptYear", request.getParameter("acceptYear"));
		params.put("userId", user.getUserId());
		
		return this.giriGenerateRIReportsDAO.getExtractInwTran(params);
	}
	@Override
	public String validateRiTypeDesc(String riTypeDesc) throws SQLException {
		return this.giriGenerateRIReportsDAO.validateRiTypeDesc(riTypeDesc);
	}
	
	public Map<String, Object> getReciprocityDetails1(GIISUser USER) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		
		return this.giriGenerateRIReportsDAO.getReciprocityDetails1(params);
	}
	
	public Map<String, Object> getReciprocityDetails2(GIISUser USER) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		
		return this.giriGenerateRIReportsDAO.getReciprocityDetails2(params);
	}
	
	public Map<String, Object> getReciprocityInitialValues(GIISUser USER) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		
		return this.giriGenerateRIReportsDAO.getReciprocityInitialValues(params);
	}
		
	@Override
	public Integer getReciprocityRiCd(HttpServletRequest request, GIISUser user) throws SQLException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		Date fromDate = request.getParameter("fromDate").equals("")? null : df.parse(request.getParameter("fromDate"));
		Date toDate = request.getParameter("toDate").equals("")? null : df.parse(request.getParameter("toDate"));
		
		params.put("fromDate", fromDate);
		params.put("toDate", toDate);
		params.put("inwardParam", request.getParameter("inwardParam"));
		params.put("outwardParam", request.getParameter("outwardParam"));
		params.put("userId", user.getUserId());
		
		System.out.println(params.toString());
		return this.giriGenerateRIReportsDAO.getReciprocityRiCd(params);
	}
	
	@Override
	public Map<String, Object> extractReciprocity(HttpServletRequest request) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		/*DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		Date fromDate = request.getParameter("fromDate").equals("")? null : df.parse(request.getParameter("fromDate"));
		Date toDate = request.getParameter("toDate").equals("")? null : df.parse(request.getParameter("toDate"));*/
		
		params.put("riCd", request.getParameter("riCd"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("inwardParam", request.getParameter("inwardParam"));
		params.put("outwardParam", request.getParameter("outwardParam"));
		
		return this.giriGenerateRIReportsDAO.extractReciprocity(params);
	}
	
	@Override
	public Integer getExtractedReciprocity(HttpServletRequest request, GIISUser user) throws SQLException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		Date fromDate = request.getParameter("fromDate").equals("")? null : df.parse(request.getParameter("fromDate"));
		Date toDate = request.getParameter("toDate").equals("")? null : df.parse(request.getParameter("toDate"));
		
		params.put("fromDate", fromDate);
		params.put("toDate", toDate);
		params.put("inwardParam", request.getParameter("inwardParam"));
		params.put("outwardParam", request.getParameter("outwardParam"));
		params.put("userId", user.getUserId());
		
		System.out.println(params.toString());
		return this.giriGenerateRIReportsDAO.getExtractedReciprocity(params);
	}
	
	@Override
	public String updateFacAmts(HttpServletRequest request, GIISUser USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("riCd", request.getParameter("riCd"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("inwardParam", request.getParameter("inwardParam"));
		params.put("outwardParam", request.getParameter("outwardParam"));
		params.put("localCurr", request.getParameter("localCurr"));
		params.put("userId", USER.getUserId());
		
		String message = this.giriGenerateRIReportsDAO.updateAprem(params);
		this.giriGenerateRIReportsDAO.updateCprem(params);
		
		return message;
	}

}
