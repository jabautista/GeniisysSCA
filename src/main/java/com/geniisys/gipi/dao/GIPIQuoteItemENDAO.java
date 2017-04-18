/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.entity.GIPIQuoteItemEN;


/**
 * The Interface GIPIQuoteItemENDAO.
 */
public interface GIPIQuoteItemENDAO {

	/**
	 * Gets the gIPI quote item en details.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @return the gIPI quote item en details
	 * @throws SQLException the sQL exception
	 */
	GIPIQuoteItemEN getGIPIQuoteItemENDetails(int quoteId, int itemNo) throws SQLException;
	
	/**
	 * Gets the gIPI quote item ENs.
	 * 
	 * @param quoteId the quote id
	 * @return the gIPI quote item ENs
	 * @throws SQLException the sQL exception
	 */
	List<GIPIQuoteItemEN> getGIPIQuoteItemENs(int quoteId) throws SQLException;
	
	/**
	 * Save gipi quote item en.
	 * 
	 * @param quoteItemEN the quote item en
	 * @throws SQLException the sQL exception
	 */
	void saveGIPIQuoteItemEN(GIPIQuoteItemEN quoteItemEN) throws SQLException;
	
	/**
	 * Delete gipi quote item en.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @throws SQLException the sQL exception
	 */
	public void deleteGIPIQuoteItemEN(int quoteId, int itemNo) throws SQLException;
	
	void saveGIPIQuoteItemEN(GIPIQuoteItemEN quoteItemEN, Map<String, Object> parameters) throws SQLException;
	
	public List<GIPIQuoteItemEN> getQuoteENDetailsForPackQuotation(List<GIPIQuote> enQuoteList) throws SQLException;
	
	public void saveGIPIQuoteENDetailsForPackQuote(Map<String, Object> listParams) throws SQLException;
	
}
