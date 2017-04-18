/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service.impl;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringEscapeUtils;
import org.jfree.util.Log;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIQuoteDAO;
import com.geniisys.gipi.entity.GIPIQuotation;
import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.entity.GIPIQuotePictures;
import com.geniisys.gipi.service.GIPIQuoteFacadeService;
import com.seer.framework.util.StringFormatter;

/**
 * The Class GIPIQuoteFacadeServiceImpl.
 */
public class GIPIQuoteFacadeServiceImpl implements GIPIQuoteFacadeService{
	
	/** The gipi quote dao. */
	private GIPIQuoteDAO gipiQuoteDAO;

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteFacadeService#getGIPIQuotationListing(java.lang.String, java.lang.String)
	 */
	@Override
	public List<GIPIQuote> getGIPIQuotationListing(String userId, String lineCd) {		
		return gipiQuoteDAO.getGIPIQuotationList(userId, lineCd);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteFacadeService#getQuotationDetailsByQuoteId(int)
	 */
	@Override
	public GIPIQuote getQuotationDetailsByQuoteId(int quoteId)
			throws SQLException {
		return gipiQuoteDAO.getQuotationDetailsByQuoteId(quoteId);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteFacadeService#saveGIPIQuoteDetails(com.geniisys.gipi.entity.GIPIQuote)
	 */
	public Integer saveGIPIQuoteDetails(GIPIQuote gipiQuote) throws SQLException {
		if (gipiQuote.getQuoteId() == 0) {
			GIPIQuote id = this.getQuoteIdSequence();
			gipiQuote.setQuoteId(id.getQuoteId());
		}
		this.gipiQuoteDAO.saveGIPIQuoteDetails(gipiQuote);
		return gipiQuote.getQuoteId();
	}
	
	/**
	 * Gets the gipi quote dao.
	 * 
	 * @return the gipi quote dao
	 */
	public GIPIQuoteDAO getGipiQuoteDAO() {
		return gipiQuoteDAO;
	}

	/**
	 * Sets the gipi quote dao.
	 * 
	 * @param gipiQuoteDAO the new gipi quote dao
	 */
	public void setGipiQuoteDAO(GIPIQuoteDAO gipiQuoteDAO) {
		this.gipiQuoteDAO = gipiQuoteDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteFacadeService#getQuoteIdByParams(com.geniisys.gipi.entity.GIPIQuote)
	 */
	@Override
	public GIPIQuote getQuoteIdByParams(GIPIQuote gipiQuote)
			throws SQLException {
		return this.getGipiQuoteDAO().getQuoteIdByParams(gipiQuote);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteFacadeService#copyQuotation(int)
	 */
	@Override
	public Integer copyQuotation(GIPIQuote quote) throws SQLException {
		this.getGipiQuoteDAO().copyQuotation(quote);
		return this.getGipiQuoteDAO().getCopiedQuoteId(quote.getQuoteId());
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteFacadeService#deleteQuotation(int)
	 */
	@Override
	public void deleteQuotation(int quoteId) throws SQLException {
		gipiQuoteDAO.deleteQuotation(quoteId);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteFacadeService#denyQuotation(int)
	 */
	@Override
	public void denyQuotation(int quoteId) throws SQLException {
		gipiQuoteDAO.denyQuotation(quoteId);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteFacadeService#duplicateQuotation(int)
	 */
	@Override
	public Integer duplicateQuotation(GIPIQuote quote) throws SQLException {
		this.getGipiQuoteDAO().duplicateQuotation(quote);
		return this.getGipiQuoteDAO().getCopiedQuoteId(quote.getQuoteId());
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteFacadeService#getQuoteIdSequence()
	 */
	@Override
	public GIPIQuote getQuoteIdSequence() throws SQLException {
		return this.getGipiQuoteDAO().getQuoteIdSequence();
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteFacadeService#getQuotationListing(java.lang.String, java.lang.String)
	 */
	@Override
	public PaginatedList getQuotationListing(String userId, String lineCd) {
		List<GIPIQuote> list = this.getGipiQuoteDAO().getGIPIQuotationList(userId, lineCd);
		PaginatedList result = new PaginatedList(list, ApplicationWideParameters.PAGE_SIZE);
		return result;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteFacadeService#getCopiedQuoteId(int)
	 */
	@Override
	public void getCopiedQuoteId(int quoteId) throws SQLException {
		this.getGipiQuoteDAO().getCopiedQuoteId(quoteId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteFacadeService#reassignQuotation(java.lang.String, int)
	 */
	@Override
	public void reassignQuotation(String userId, int quoteId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("quoteId", quoteId);
		params.put("userId", userId);
		
		this.getGipiQuoteDAO().reassignQuotation(params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteFacadeService#getQuoteListStatus(java.util.Map)
	 */
	@Override
	public PaginatedList getQuoteListStatus(Map<String, Object> params)
			throws SQLException {
		List<GIPIQuotation> quotationStatus = this.getGipiQuoteDAO().getQuoteListStatus(params);
		PaginatedList result = new PaginatedList(quotationStatus, ApplicationWideParameters.PAGE_SIZE);
		return result;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteFacadeService#getQuoteListFromIssCd(java.lang.String, java.lang.String, int)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getQuoteListFromIssCd(String issCd, String lineCd, String keyWord, String userId, int pageNo) throws SQLException {
		List<GIPIQuotation> list = this.getGipiQuoteDAO().getQuoteListFromIssCd(issCd, lineCd, userId, keyWord);
		PaginatedList result = new PaginatedList(list, ApplicationWideParameters.PAGE_SIZE);
		result.gotoPage(pageNo);
		return result;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteFacadeService#saveQuoteToParUpdates(int, java.lang.Integer, java.lang.String, java.lang.String)
	 */
	@Override
	public void saveQuoteToParUpdates(int quoteId, Integer assdNo,
			String lineCd, String issCd) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("quoteId", quoteId);
		params.put("lineCd", lineCd);
		params.put("assdNo", assdNo);
		params.put("issCd", issCd);
		this.getGipiQuoteDAO().saveQuoteToParUpdates(params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteFacadeService#updateStatus(java.util.Map)
	 */
	@Override
	public void updateStatus(Map<String, Object> params) throws SQLException {
		this.getGipiQuoteDAO().updateStatus(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteFacadeService#updateQuotePremAmt(int, java.math.BigDecimal)
	 */
	@Override
	public void updateQuotePremAmt(int quoteId, BigDecimal premAmt)	throws SQLException {
		this.getGipiQuoteDAO().updateQuotePremAmt(quoteId, premAmt);
		
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteFacadeService#getDistinctReasonCds()
	 */
	@Override
	public List<GIPIQuote> getDistinctReasonCds() throws SQLException {
		return this.getGipiQuoteDAO().getDistinctReasonCds();
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteFacadeService#updateStatusFromPar(int)
	 */
	@Override
	public void updateStatusFromPar(int quoteId) throws SQLException {
		this.getGipiQuoteDAO().updateStatusFromPar(quoteId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteFacadeService#updateReasonCd(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public void updateReasonCd(Integer quoteId, Integer reasonCd) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("quoteId", quoteId);
		params.put("reasonCd", reasonCd);
		this.getGipiQuoteDAO().updateReasonCd(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteFacadeService#getExistMessage(java.lang.String, java.lang.Integer)
	 */
	@Override
	public String getExistMessage(String lineCd, Integer assdNo, String assdName, String quoteId) // edited by irwin
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", lineCd);
		params.put("assdNo", assdNo == 0 ? null :assdNo );
		params.put("assdName", assdName); // andrew - 05.18.2011
		params.put("quoteId", quoteId); // apollo cruz - 12.08.2014
		return this.getGipiQuoteDAO().getExistMessage(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteFacadeService#getExistingQuotesPolsListing(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getExistingQuotesPolsListing(Map<String, Object> params)
			throws SQLException, JSONException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIPIQuote> list = this.getGipiQuoteDAO().getExistingQuotesPolsListing(params);
		params.put("rows", new JSONArray((List<GIPIQuote>) StringFormatter.replaceQuotesInList(list)));
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteFacadeService#getFilterQuoteListing(java.util.Map)
	 */
	@Override
	public PaginatedList getFilterQuoteListing(Map<String, Object> params) throws SQLException {
		Log.info("getFilterQuoteListing");
		List<GIPIQuote> list = this.getGipiQuoteDAO().getFilterQuoteListing(params);
		PaginatedList searchResult = new PaginatedList(list, ApplicationWideParameters.PAGE_SIZE);
		return searchResult;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteFacadeService#getQuotationListing(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getQuotationListing(Map<String, Object> params)
			throws SQLException{
		/**
			List<GIPIQuote> list = this.getGipiQuoteDAO().getGIPIQuotationList(userId, lineCd);
			PaginatedList result = new PaginatedList(list, ApplicationWideParameters.PAGE_SIZE);
			return result;
		 */
		Log.info("getFilterQuoteListing");
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIPIQuote> list = this.getGipiQuoteDAO().getFilterQuoteListing(params);
		System.out.println("dev: LIST LENGTH ==== " + list.size());
		String lineCd = params.get("lineCd").toString();
		String userId = params.get("userId").toString();
		System.out.println("lineCd = " + lineCd + " --- userId = " + userId);
		list = this.getGipiQuoteDAO().getGIPIQuotationList(userId, lineCd);
		
		System.out.println("DEV: LIST LENGTH ==== " + list.size());
		if(list.size()>0){
			try{
				for(GIPIQuote quote: list){
					System.out.println("quote - [" + quote.getQuoteNo() + "] [" + quote.getQuotationNo() + "]");
					System.out.println("quote - assuredName: " + quote.getAssdName());
				}
			}catch (Exception e) {
				e.printStackTrace();				
			}
		}
		params.put("rows", new JSONArray((List<GIPIQuote>)StringFormatter.replaceQuotesInList(list)));
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteFacadeService#checkAssdName(java.lang.String)
	 */
	@Override
	public Map<String, Object> checkAssdName(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("assdName", request.getParameter("assdName").replaceAll("�", ""));
		params.put("assdNo", (request.getParameter("assdNo") != null || request.getParameter("assdNo") != "") ? request.getParameter("assdNo").toString() : "0");
		return this.gipiQuoteDAO.checkAssdName(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteFacadeService#getGIPIQuoteListing(java.util.HashMap)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getGIPIQuoteListing(
			HashMap<String, Object> params) throws SQLException, JSONException, ParseException {
		System.out.println("serviceimpl1");
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		params.put("filter", this.prepareQuoteListDetailFilter((String) params.get("filter")));
		List<GIPIQuote> list = this.getGipiQuoteDAO().getGIPIQuoteListing(params);
		params.put("rows", new JSONArray((List<GIPIQuote>)StringFormatter.escapeHTMLInList(list)));  
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
		
	}
	
	/**
	 * 
	 * @param filter
	 * @return
	 * @throws JSONException
	 * @throws ParseException
	 */
	private Map<String, Object> prepareQuoteListDetailFilter(String filter) throws JSONException, ParseException{
		Map<String, Object> quoteFilter = new HashMap<String, Object>();
		JSONObject jsonQuoteListFilter = null;
		//SimpleDateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		
		if(null == filter){
			System.out.println("Filter is null");
			jsonQuoteListFilter = new JSONObject();
		}else{
			jsonQuoteListFilter = new JSONObject(filter);
		}
		quoteFilter.put("quoteNo", jsonQuoteListFilter.isNull("quoteNo") ? "%%" : jsonQuoteListFilter.getString("quoteNo").toUpperCase());//removed "%" by pjsantos 10/19/2016, GENQA 5786
		//quoteFilter.put("assdName", jsonQuoteListFilter.isNull("assdName") ? "%%" : "%"+jsonQuoteListFilter.getString("assdName").toUpperCase());
		quoteFilter.put("assdName", jsonQuoteListFilter.isNull("assdName") ? "%%" : ""+jsonQuoteListFilter.getString("assdName").toUpperCase()); // removed "%" Patrick - 02.10.2012
		quoteFilter.put("inceptDate", jsonQuoteListFilter.isNull("inceptDate")? null : jsonQuoteListFilter.getString("inceptDate").toUpperCase());
		quoteFilter.put("expiryDate", jsonQuoteListFilter.isNull("expiryDate") ? null : jsonQuoteListFilter.getString("expiryDate").toUpperCase());
		quoteFilter.put("validDate", jsonQuoteListFilter.isNull("validDate") ? null : jsonQuoteListFilter.getString("validDate").toUpperCase());
		quoteFilter.put("userId", jsonQuoteListFilter.isNull("userId") ? "%%" : jsonQuoteListFilter.getString("userId").toUpperCase());// removed "%" Steven - 03.08.2012
		quoteFilter.put("issCd", jsonQuoteListFilter.isNull("issCd") ? "%%" : jsonQuoteListFilter.getString("issCd").toUpperCase());
		quoteFilter.put("quotationYy", jsonQuoteListFilter.isNull("quotationYy") ? null : jsonQuoteListFilter.getString("quotationYy").toUpperCase());//removed "%" by pjsantos 10/19/2016, GENQA 5786
		quoteFilter.put("quotationNo", jsonQuoteListFilter.isNull("quotationNo") ? null : jsonQuoteListFilter.getString("quotationNo").toUpperCase());
		quoteFilter.put("proposalNo", jsonQuoteListFilter.isNull("proposalNo") ? null : jsonQuoteListFilter.getString("proposalNo").toUpperCase());
		quoteFilter.put("sublineCd", jsonQuoteListFilter.isNull("sublineCd") ? "%%" : jsonQuoteListFilter.getString("sublineCd").toUpperCase());

		return quoteFilter;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteFacadeService#reassignQuoatation2(java.lang.String)
	 */
	@Override
	public void reassignQuoatation2(String params) throws SQLException,
			JSONException {
		JSONObject objParams = new JSONObject(params);
		JSONArray objQuotes = new JSONArray(objParams.getString("setRows"));
		JSONObject objQuote = null;
		List<GIPIQuote> quoteList = new ArrayList<GIPIQuote>();
		List<GIPIQuote> packageQuoteList = new ArrayList<GIPIQuote>();
		GIPIQuote gipiQuote = null;
		
		/*for(int i=0, length=objQuotes.length(); i < length; i++){
			objQuote = objQuotes.getJSONObject(i);
			gipiQuote = new GIPIQuote();
			gipiQuote.setQuoteId(objQuote.isNull("quoteId") ? null : objQuote.getInt("quoteId"));
			gipiQuote.setUserId(objQuote.isNull("userId") ? null : objQuote.getString("userId"));
			gipiQuote.setRemarks(objQuote.isNull("remarks") ? null : StringEscapeUtils.unescapeHtml(objQuote.getString("remarks"))); //marco			
			quoteList.add(gipiQuote);
		}*/

		/* marco - modified to include package quotations */
		for(int i=0, length=objQuotes.length(); i < length; i++){
			objQuote = objQuotes.getJSONObject(i);
			gipiQuote = new GIPIQuote();
			//package
			if(objQuote.getString("packPolFlag").toUpperCase().equals("Y")){
				gipiQuote.setQuoteId(objQuote.isNull("quoteId") ? null : objQuote.getInt("quoteId"));
				gipiQuote.setUserId(objQuote.isNull("userId") ? null : objQuote.getString("userId"));
				gipiQuote.setRemarks(objQuote.isNull("remarks") || objQuote.getString("remarks").equals("") ? null : StringEscapeUtils.unescapeHtml(objQuote.getString("remarks")));	
				gipiQuote.setPackQuoteId(objQuote.isNull("packQuoteId") ? null : objQuote.getInt("packQuoteId"));
				packageQuoteList.add(gipiQuote);
			}
			//single
			else {
				gipiQuote.setQuoteId(objQuote.isNull("quoteId") ? null : objQuote.getInt("quoteId"));
				gipiQuote.setUserId(objQuote.isNull("userId") ? null : objQuote.getString("userId"));
				gipiQuote.setRemarks(objQuote.isNull("remarks") || objQuote.getString("remarks").equals("")  ? null : StringEscapeUtils.unescapeHtml(objQuote.getString("remarks")));
				quoteList.add(gipiQuote);
			}		
		}
		
		if(quoteList.size() > 0){
			this.getGipiQuoteDAO().reassignQuotation2(quoteList);
		}
		if(packageQuoteList.size() > 0){
			this.getGipiQuoteDAO().reassignPackageQuotation(packageQuoteList);
		}
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteFacadeService#getQuotationByPackQuoteId(java.util.Map)
	 */
	public List<GIPIQuote> getQuotationByPackQuoteId(Map<String, Object> params)
			throws SQLException {
		List<GIPIQuote> packQuotations =  this.gipiQuoteDAO.getQuotationByPackQuoteId(params);
		for (GIPIQuote gipiQuote2 : packQuotations) { //added by steven 11/5/2012
			if (gipiQuote2.getRemarks() instanceof String && gipiQuote2.getRemarks() != null && (gipiQuote2.getRemarks().toString().contains("\"") || gipiQuote2.getRemarks().toString().contains("'") || gipiQuote2.getRemarks().toString().contains(">") || gipiQuote2.getRemarks().toString().contains("<") || gipiQuote2.getRemarks().toString().contains("&") || gipiQuote2.getRemarks().toString().contains("\u00f1") || gipiQuote2.getRemarks().toString().contains("\u00D1") || gipiQuote2.getRemarks().toString().contains("\\") || gipiQuote2.getRemarks().toString().contains("\r\n") || gipiQuote2.getRemarks().toString().contains("\n"))) {
				gipiQuote2.setRemarks(StringFormatter.escapeBackslash(StringFormatter.replaceTildes(StringFormatter.replaceQuotes(StringFormatter.escapeHTML(gipiQuote2.getRemarks())))));
			}
			if (gipiQuote2.getSublineName() instanceof String && gipiQuote2.getSublineName() != null && (gipiQuote2.getSublineName().toString().contains("\"") || gipiQuote2.getSublineName().toString().contains("'") || gipiQuote2.getSublineName().toString().contains(">") || gipiQuote2.getSublineName().toString().contains("<") || gipiQuote2.getSublineName().toString().contains("&") || gipiQuote2.getSublineName().toString().contains("\u00f1") || gipiQuote2.getSublineName().toString().contains("\u00D1") || gipiQuote2.getSublineName().toString().contains("\\") || gipiQuote2.getSublineName().toString().contains("\r\n") || gipiQuote2.getSublineName().toString().contains("\n"))) {
				gipiQuote2.setSublineName(StringFormatter.escapeBackslash(StringFormatter.replaceTildes(StringFormatter.replaceQuotes(StringFormatter.escapeHTML(gipiQuote2.getSublineName())))));
			}//added by christian 03/13/2013
		}
		return packQuotations;
	}
	
	@Override
	public JSONObject getQuotationByPackQuoteIdJson(HttpServletRequest request, String userId)
			throws SQLException, JSONException, ParseException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("ACTION", "getQuotationByPackQuoteId2");		
		param.put("packQuoteId", request.getParameter("packQuoteId"));
		param.put("userId", userId);
		Map<String, Object> recList = StringFormatter.escapeHTMLInMap((TableGridUtil.getTableGrid(request, param)));
		return new JSONObject(recList);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteFacadeService#savePackLineSubline(java.util.Map)
	 */
	@Override
	public void savePackLineSubline(Map<String, Object> params)
			throws SQLException, JSONException {
		this.gipiQuoteDAO.savePackLineSubline(params);
		
	}

	@Override
	public String checkIfGIPIQuoteItemExsist(int quoteId) throws SQLException {
		return this.gipiQuoteDAO.checkIfGIPIQuoteItemExsist(quoteId);
	}


	@Override
	public void saveQuoteInspectionDetails(Map<String, Object> params)
			throws SQLException {
		this.getGipiQuoteDAO().saveQuoteInspectionDetails(params);
	}

	@Override
	public Map<String, Object> generateQuoteBankRefNo(Map<String, Object> params)
			throws SQLException {
		return this.getGipiQuoteDAO().generateQuoteBankRefNo(params);
	}


	@Override
	public List<GIPIQuote> getGipiPackQuoteList(Integer packQuoteId)
			throws SQLException {
		return this.gipiQuoteDAO.getGipiPackQuoteList(packQuoteId);
	}

	@Override
	public List<GIPIQuote> getIncludedLinesOfPackQuote(Integer packQuoteId)
			throws SQLException {
		return this.getGipiQuoteDAO().getIncludedLinesOfPackQuote(packQuoteId);
	}

	@Override
	public List<GIPIQuote> getPackQuoteListForCarrierInfo(Integer packQuoteId)
			throws SQLException {
		return this.getGipiQuoteDAO().getPackQuoteListForCarrierInfo(packQuoteId);
	}

	@Override
	public List<GIPIQuote> getPackQuoteListForENInfo(Integer packQuoteId)
			throws SQLException {
		return this.getGipiQuoteDAO().getPackQuoteListForENInfo(packQuoteId);
	}
	/**
	 * @author rey
	 * @throws ParseException 
	 * @date 07-13-2011
	 * 
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getGIPIQuoteList(Map<String, Object> params) throws SQLException, JSONException, ParseException { 
		TableGridUtil grid=new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
	
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		GIISUser user = (GIISUser) params.get("USER");
		//params.put("userId",user.getUserId());
		params.put("userId",user.getUserId()); //added by steven 11/7/2012
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("lineCd", request.getParameter("lineCd"));		
		params.put("filter", this.prepareQuotationStatusFilter(params));
		System.out.println("Param : " + params.toString());
		List<GIPIQuotation> list = this.getGipiQuoteDAO().getQuotationListStatus(params);
		params.put("rows", new JSONArray((List<GIPIQuotation>)StringFormatter.escapeHTMLInList(list)));
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		params.remove("filter"); // SR 12216
		params.remove("request"); // SR 12216
		return params;
	}
	/**
	 * @author rey
	 * @date 07-13-2011
	 * @param params
	 * @return quotationList
	 * @throws JSONException
	 * @throws ParseException 
	 */
	private GIPIQuote prepareQuotationStatusFilter(Map<String, Object> params) throws JSONException, ParseException {
		String filter = (String) params.get("filter");
		GIPIQuote quotationList = new GIPIQuote();
		JSONObject jsonQuotationListFilter = null;
		if (null == filter){
			jsonQuotationListFilter = new JSONObject();
		}else{
			jsonQuotationListFilter = new JSONObject(filter);
		}
		
			//try {
				quotationList.setAssdName(jsonQuotationListFilter.isNull("assdName") ? null : jsonQuotationListFilter.getString("assdName"));
				quotationList.setAssdNo(jsonQuotationListFilter.isNull("assdNo") ? null : jsonQuotationListFilter.getInt("assdNo"));	
				quotationList.setStatus(jsonQuotationListFilter.isNull("status") ? null : jsonQuotationListFilter.getString("status"));	
				quotationList.setUserId(jsonQuotationListFilter.isNull("userId") ? null : jsonQuotationListFilter.getString("userId"));
				quotationList.setSublineCd(jsonQuotationListFilter.isNull("sublineCd") ? null : jsonQuotationListFilter.getString("sublineCd").toUpperCase());//steven 3.8.2012
				quotationList.setQuotationNo(jsonQuotationListFilter.isNull("quoteNo") ? null : jsonQuotationListFilter.getInt("quoteNo"));
				quotationList.setIssCd(jsonQuotationListFilter.isNull("issCd") ? null : jsonQuotationListFilter.getString("issCd"));
				quotationList.setQuoteNo(jsonQuotationListFilter.isNull("quotationNo") ? null : jsonQuotationListFilter.getString("quotationNo"));
				quotationList.setProposalNo(jsonQuotationListFilter.isNull("proposalNo") ? null : jsonQuotationListFilter.getInt("proposalNo"));
				quotationList.setQuotationYy(jsonQuotationListFilter.isNull("quotationYy") ? null : jsonQuotationListFilter.getInt("quotationYy"));
				quotationList.setUserId(jsonQuotationListFilter.isNull("userId") ? null : jsonQuotationListFilter.getString("userId"));
				params.put("fromDate", jsonQuotationListFilter.isNull("fromDate") ? null : jsonQuotationListFilter.getString("fromDate"));
				params.put("toDate", jsonQuotationListFilter.isNull("toDate") ? null : jsonQuotationListFilter.getString("toDate"));
				params.put("expiryDate", jsonQuotationListFilter.isNull("expiryDate") ? null : jsonQuotationListFilter.getString("expiryDate"));
				params.put("inceptDate", jsonQuotationListFilter.isNull("inceptDate") ? null : jsonQuotationListFilter.getString("inceptDate"));
				params.put("assdName", jsonQuotationListFilter.isNull("assdName") ? null : jsonQuotationListFilter.getString("assdName"));
			/*	SimpleDateFormat formatter = new SimpleDateFormat("MM-dd-yyyy");
				quotationList.setExpiryDate(jsonQuotationListFilter.isNull("expiryDate") ? null : formatter.parse(jsonQuotationListFilter.getString("expiryDate")));
				quotationList.setInceptDate(jsonQuotationListFilter.isNull("inceptDate") ? null : formatter.parse(jsonQuotationListFilter.getString("inceptDate")));
			} catch (ParseException e) {
				ExceptionHandler.logException(e);
				throw e;				
			} commented by: Nica 06.05.2012*/
		return quotationList;
	}

	@Override
	public Integer copyQuotation2(Map<String, Object> params)
			throws SQLException, Exception {
		return this.getGipiQuoteDAO().copyQuotation2(params);
	}

	@Override
	public Integer duplicateQuotation2(Map<String, Object> params)
			throws SQLException, Exception {
		return this.getGipiQuoteDAO().duplicateQuotation2(params);
	}

	@Override
	public com.geniisys.quote.entity.GIPIQuote getQuotationInfoByQuoteId(
			Integer quoteId) throws SQLException {
		return this.getGipiQuoteDAO().getQuotationInfoByQuoteId(quoteId);
	}

	@Override
	public Integer checkIfInspExists(Integer assdNo) throws SQLException {
		return this.getGipiQuoteDAO().checkIfInspExists(assdNo);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getReassignQuoteListing(Map<String, Object> params) throws SQLException, JSONException, ParseException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		params.put("filter", this.prepareQuoteListDetailFilter((String) params.get("filter")));
		List<GIPIQuote> list = this.getGipiQuoteDAO().getReassignQuoteListing(params);
		params.put("rows", new JSONArray((List<GIPIQuote>)StringFormatter.escapeHTMLInList(list)));  
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	@Override
	public String saveQuoteInspectionDetails2(HttpServletRequest request,
			String userId) throws SQLException {
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("appUser", userId);
		params.put("quoteId", request.getParameter("quoteId"));
		params.put("inspNo", request.getParameter("inspNo"));
		return this.getGipiQuoteDAO().saveQuoteInspectionDetails2(params);
	}

	@Override
	public void deleteQuotation2(Map<String, Object> params)
			throws SQLException {
		this.getGipiQuoteDAO().deleteQuotation2(params);
	}
	
	public String copyAttachments(Map<String, Object> params) throws SQLException, IOException {
		String message = "";
		String lineCd = params.get("lineCd").toString();
		String quoteId = params.get("quoteId").toString();
		String quoteNo = params.get("quoteNo").toString();
		String inspNo = params.get("inspNo").toString();
		String mediaPathMK = params.get("mediaPathMK").toString().replaceAll("\\\\", "/");
		String mediaPathINSP = params.get("mediaPathINSP").toString().replaceAll("\\\\", "/");
		//String mediaPathINSPRegEx = mediaPathINSP + "/" + inspNo;
		//String quoteNoReplace = "/" + lineCd + "/" + quoteNo;
		String fileSrc = "";
		String fileDes = "";
		
		List<GIPIQuotePictures> attachmentList = this.getGipiQuoteDAO().getAttachmentByQuote(quoteId);
		
		for (GIPIQuotePictures attachment : attachmentList) {
			fileSrc = attachment.getFileName().replaceAll("\\\\", "/");
			//fileDes = mediaPathMK + fileSrc.replaceAll(mediaPathINSPRegEx, quoteNoReplace);
			
			String fileName = attachment.getFileName();
			String realFileName = fileName.substring(fileName.lastIndexOf("/") + 1);
			
			fileDes = mediaPathMK + "/" + lineCd + "/" + quoteNo + "/" + attachment.getItemNo().toString() + "/" + realFileName;
			
			// update file path
			Map<String, Object> params2 = new HashMap<String, Object>();
			params2.put("quoteId", quoteId);
			params2.put("itemNo", Integer.toString(attachment.getItemNo()));
			params2.put("oldFileName", fileSrc);
			params2.put("newFileName", fileDes);
			
			this.getGipiQuoteDAO().updateFileName2(params2);
			
			try {
				File src = new File(fileSrc);
				File des = new File(fileDes);
				
				System.out.println("Copying " + fileSrc + " to " + fileDes + " ...");
				FileUtils.copyFile(src, des); // copy physical file
			} catch (IOException e) {
				continue; // if source file not exists, continue to next file
			}
		}
		
		message = "SUCCESS";
		return message;
	}
}