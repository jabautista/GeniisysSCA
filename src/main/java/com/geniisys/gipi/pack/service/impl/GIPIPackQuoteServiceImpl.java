package com.geniisys.gipi.pack.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.pack.dao.GIPIPackQuoteDAO;
import com.geniisys.gipi.pack.entity.GIPIPackQuote;
import com.geniisys.gipi.pack.service.GIPIPackQuoteService;
import com.seer.framework.util.StringFormatter;

public class GIPIPackQuoteServiceImpl implements GIPIPackQuoteService {
 
	private GIPIPackQuoteDAO gipiPackQuoteDAO;
	
	private static Logger log = Logger.getLogger(GIPIPackQuoteServiceImpl.class);
	public void setGipiPackQuoteDAO(GIPIPackQuoteDAO gipiPackQuoteDAO) {
		this.gipiPackQuoteDAO = gipiPackQuoteDAO;
	}
	public GIPIPackQuoteDAO getGipiPackQuoteDAO() {
		return gipiPackQuoteDAO;
	}
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getQuoteListFromIssCd(String lineCd,String issCd, String keyWord, int pageNo, String userId) throws SQLException {
		List<GIPIPackQuote> list = this.getGipiPackQuoteDAO().getQuoteListFromIssCd(lineCd,issCd, keyWord, userId);
		PaginatedList result = new PaginatedList (list, ApplicationWideParameters.PAGE_SIZE);
		result.gotoPage(pageNo);
		return result;
		
	}
	@Override
	public void updateGipiPackQuote(int quoteId) throws SQLException {
		this.getGipiPackQuoteDAO().updateGipiPackQuote(quoteId);
	}
	@Override
	public void returnPackParToQuotation(Map<String, Object>params)
			throws SQLException {
		this.getGipiPackQuoteDAO().returnPackParToQuotation(params);
	}
	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getPackQuotationListing(
			HashMap<String, Object> params) throws SQLException ,JSONException, ParseException{
		// prepare the table grid
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		params.put("filter", this.prepareQuoteListDetailFilter((String) params.get("filter")));
		System.out.println("from:"+grid.getStartRow());
		System.out.println("from:"+grid.getEndRow());
		// get the main pack quote list
		List<GIPIPackQuote> packQuoteList = getGipiPackQuoteDAO().getPackQuotationListing(params);
		System.out.println("pack quotation listing length: "+packQuoteList.size());
		params.put("rows", new JSONArray((List<GIPIQuote>)StringFormatter.escapeHTMLInList(packQuoteList)));
		grid.setNoOfPages(packQuoteList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}
	private Map<String, Object> prepareQuoteListDetailFilter(String filter) throws JSONException, ParseException{
		//GIPIPackQuote quoteList = new GIPIPackQuote();
		JSONObject jsonQuoteListFilter = null;
		//SimpleDateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		Map<String, Object> quoteFilter = new HashMap<String, Object>();
		
		if(null == filter){
			System.out.println("Filter is null");
			jsonQuoteListFilter = new JSONObject();
		}else{
			jsonQuoteListFilter = new JSONObject(filter);
		}
		quoteFilter.put("quoteNo", jsonQuoteListFilter.isNull("quoteNo") ? "%%" : ""+jsonQuoteListFilter.getString("quoteNo").toUpperCase());
		quoteFilter.put("assdName", jsonQuoteListFilter.isNull("assdName") ? "%%" : ""+jsonQuoteListFilter.getString("assdName").toUpperCase());
		quoteFilter.put("inceptDate", jsonQuoteListFilter.isNull("inceptDate")? null : jsonQuoteListFilter.getString("inceptDate").toUpperCase());
		quoteFilter.put("expiryDate", jsonQuoteListFilter.isNull("expiryDate") ? null : jsonQuoteListFilter.getString("expiryDate").toUpperCase());
		quoteFilter.put("validDate", jsonQuoteListFilter.isNull("validDate") ? null : jsonQuoteListFilter.getString("validDate").toUpperCase());
		quoteFilter.put("userId", jsonQuoteListFilter.isNull("userId") ? "%%" : jsonQuoteListFilter.getString("userId").toUpperCase());
		quoteFilter.put("issCd", jsonQuoteListFilter.isNull("issCd") ? "%%" : jsonQuoteListFilter.getString("issCd").toUpperCase());
		quoteFilter.put("quotationYy", jsonQuoteListFilter.isNull("quotationYy") ? null : jsonQuoteListFilter.getString("quotationYy").toUpperCase());
		quoteFilter.put("quotationNo", jsonQuoteListFilter.isNull("quotationNo") ? null : jsonQuoteListFilter.getString("quotationNo").toUpperCase());
		quoteFilter.put("proposalNo", jsonQuoteListFilter.isNull("proposalNo") ? null : jsonQuoteListFilter.getString("proposalNo").toUpperCase());
		quoteFilter.put("sublineCd", jsonQuoteListFilter.isNull("sublineCd") ? "%%" : jsonQuoteListFilter.getString("sublineCd").toUpperCase());
		/*
		quoteList.setQuoteNo(jsonQuoteListFilter.isNull("quoteNo") ? "%%"		   		:	jsonQuoteListFilter.getString("quoteNo").toUpperCase());
		quoteList.setAssdName(jsonQuoteListFilter.isNull("assdName") ? "%%"		:	jsonQuoteListFilter.getString("assdName").toUpperCase());
		quoteList.setInceptDate(jsonQuoteListFilter.isNull("inceptDate") ? null		    :	df.parse(jsonQuoteListFilter.getString("inceptDate")));
		quoteList.setExpiryDate(jsonQuoteListFilter.isNull("expiryDate") ? null		    :	df.parse(jsonQuoteListFilter.getString("expiryDate")));
		quoteList.setValidDate(jsonQuoteListFilter.isNull("validDate") ? null				:	df.parse(jsonQuoteListFilter.getString("validDate")));
		quoteList.setUserId(jsonQuoteListFilter.isNull("userId") ? "%%"		       		:	jsonQuoteListFilter.getString("userId").toUpperCase());
		quoteList.setIssCd(jsonQuoteListFilter.isNull("issCd") ? "%%"		       		    : 	jsonQuoteListFilter.getString("issCd").toUpperCase());
		quoteList.setQuotationYy(jsonQuoteListFilter.isNull("quotationYy") ? null	   	:	jsonQuoteListFilter.getInt("quotationYy"));
		quoteList.setQuotationNo(jsonQuoteListFilter.isNull("quotationNo") ? null	   	:	jsonQuoteListFilter.getInt("quotationNo"));
		quoteList.setProposalNo(jsonQuoteListFilter.isNull("proposalNo") ? null	   	:	jsonQuoteListFilter.getInt("proposalNo"));
		quoteList.setSublineCd(jsonQuoteListFilter.isNull("sublineCd") ? "%%"		       		    : 	jsonQuoteListFilter.getString("sublineCd").toUpperCase());*/
		return quoteFilter;
	}
	@Override
	public GIPIPackQuote getGIPIPackDetails(Integer packQuoteId)
			throws SQLException {
		return this.gipiPackQuoteDAO.getGIPIPacKQuoteDetails(packQuoteId);
	}
	@Override
	public GIPIPackQuote saveGipiPackQuote(GIPIPackQuote gipiPackQuote)
			throws SQLException {
		if (gipiPackQuote.getPackQuoteId() == 0) {
			gipiPackQuote.setPackQuoteId(this.gipiPackQuoteDAO.getNewPackQuoteId());
			log.info("Generated Pack Quote Id: "+gipiPackQuote.getPackQuoteId());
		}
		
		return this.gipiPackQuoteDAO.saveGipiPackQuote(gipiPackQuote);
	}
	@Override
	public void deletePackQuotation(Map<String, Object> params)
			throws SQLException {
		this.gipiPackQuoteDAO.deletePackQuotation(params);
	}
	@Override
	public void denyPackQuotation(Map<String, Object> params)
			throws SQLException {
		this.gipiPackQuoteDAO.denyPackQuotation(params);
	}
	@Override
	public String copyPackQuotation(Map<String, Object> params)
			throws SQLException {
		return this.gipiPackQuoteDAO.copyPackQuotation(params);
	}
	@Override
	public String duplicatePackQuotation(Map<String, Object> params)
			throws SQLException {
		return this.gipiPackQuoteDAO.duplicatePackQuotation(params);
	}
	@Override
	public Map<String, Object> generatePackBankRefNo(Map<String, Object> params)
			throws SQLException {
		return this.gipiPackQuoteDAO.generatePackBankRefNo(params);
	}
	@Override
	public String getExistMessagePack(Map<String, Object> params)
			throws SQLException {
		return gipiPackQuoteDAO.getExistMessagePack(params);
	}
	@Override
	public String checkOra2010Sw() throws SQLException {
		return gipiPackQuoteDAO.checkOra2010Sw();
	}
}