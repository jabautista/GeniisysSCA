package com.geniisys.gipi.pack.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.framework.util.PaginatedList;
import com.geniisys.gipi.pack.entity.GIPIPackQuote;

public interface GIPIPackQuoteService {
	PaginatedList getQuoteListFromIssCd(String lineCd,String issCd, String keyWord, int pageNo, String userId) throws SQLException;
	void updateGipiPackQuote(int quoteId) throws SQLException;
	void returnPackParToQuotation(Map<String, Object>params) throws SQLException;
	HashMap<String, Object> getPackQuotationListing(HashMap<String, Object>params)throws SQLException,JSONException, ParseException;
	GIPIPackQuote getGIPIPackDetails(Integer packQuoteId) throws SQLException;
	GIPIPackQuote saveGipiPackQuote(GIPIPackQuote gipiPackQuote) throws SQLException;
	void deletePackQuotation (Map<String, Object>params)throws SQLException;
	void denyPackQuotation (Map<String, Object>params)throws SQLException;
	String copyPackQuotation (Map<String, Object>params)throws SQLException;
	String duplicatePackQuotation (Map<String, Object>params)throws SQLException;
	Map<String, Object> generatePackBankRefNo(Map<String, Object>params)throws SQLException;
	public String getExistMessagePack(Map<String, Object> params) throws SQLException;
	String checkOra2010Sw() throws SQLException;
}
