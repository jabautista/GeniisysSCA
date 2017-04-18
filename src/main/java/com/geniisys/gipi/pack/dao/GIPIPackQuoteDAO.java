package com.geniisys.gipi.pack.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.pack.entity.GIPIPackQuote;

public interface GIPIPackQuoteDAO {
	List<GIPIPackQuote> getQuoteListFromIssCd(String lineCd,String issCd, String keyWord, String userId) throws SQLException;
	void updateGipiPackQuote(int quoteId) throws SQLException;
	void returnPackParToQuotation(Map<String, Object>params) throws SQLException;
	List<GIPIPackQuote> getPackQuotationListing(Map<String, Object>params) throws SQLException;
	GIPIPackQuote getGIPIPacKQuoteDetails(Integer packQuoteId) throws SQLException;
	Integer getNewPackQuoteId() throws SQLException;
	GIPIPackQuote saveGipiPackQuote(GIPIPackQuote gipiPackQuote) throws SQLException;
	void deletePackQuotation(Map<String, Object>params)throws SQLException;
	void denyPackQuotation (Map<String, Object>params)throws SQLException;
	String copyPackQuotation(Map<String, Object>params)throws SQLException;
	String duplicatePackQuotation(Map<String, Object>params)throws SQLException;
	Map<String, Object> generatePackBankRefNo(Map<String, Object>params) throws SQLException;
	public String getExistMessagePack(Map<String, Object> params) throws SQLException;
	String checkOra2010Sw() throws SQLException;
}
