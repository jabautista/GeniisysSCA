/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.gipi.service;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.Date;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.gipi.entity.GIPIQuoteItemPeril;
import com.geniisys.gipi.entity.GIPIQuoteItemPerilSummary;

/**
 * The Interface GIPIQuoteItemPerilFacadeService.
 */
public interface GIPIQuoteItemPerilFacadeService {
	
	/**
	 * Gets the quote item peril summary list.
	 * 
	 * @param quoteId the quote id
	 * @return the quote item peril summary list
	 */
	public List<GIPIQuoteItemPerilSummary> getQuoteItemPerilSummaryList(int quoteId);
	
	/**
	 * Save quote item peril.
	 * 
	 * @param quoteItemPeril the quote item peril
	 * @return true, if successful
	 */
	public boolean saveQuoteItemPeril(GIPIQuoteItemPeril quoteItemPeril);
	
	/**
	 * Save gipi quote item peril.
	 * @author whofeih
	 * @param quoteItemPeril the quote item peril
	 * @throws SQLException the sQL exception
	 */
	public void saveGIPIQuoteItemPeril(GIPIQuoteItemPeril quoteItemPeril) throws SQLException;

	/**
	 * Delete quote item peril.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @param perilCd the peril cd
	 * @return true, if successful
	 */
	public boolean deleteQuoteItemPeril(int quoteId, int itemNo, int perilCd);
	
	/**
	 * Delete gipi quote item all perils.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @throws SQLException the sQL exception
	 */
	void deleteGIPIQuoteItemAllPerils(int quoteId, int itemNo) throws SQLException;
	
	/**
	 * Gets the paginated quote item peril summary list.
	 * 
	 * @param pageNo the page no
	 * @param quoteId the quote id
	 * @return the paginated quote item peril summary list
	 */
	public PaginatedList getPaginatedQuoteItemPerilSummaryList(Integer pageNo, int quoteId);
	
	/**
	 * Gets the paginated quote item peril summary list.
	 * 
	 * @param pageNo the page no
	 * @param list the list
	 * @return the paginated quote item peril summary list
	 */
	public PaginatedList getPaginatedQuoteItemPerilSummaryList(Integer pageNo, List<GIPIQuoteItemPerilSummary> list);
	
	/**
	 * Gets the last page.
	 * 
	 * @param list the list
	 * @return the last page
	 */
	public int getLastPage(List<GIPIQuoteItemPerilSummary> list);
	
	/**
	 * Compute premium amount.
	 * 
	 * @param prorateFlag the prorate flag
	 * @param inceptionDate the inception date
	 * @param expiryDate the expiry date
	 * @param premiumRate the premium rate
	 * @param tsiAmount the tsi amount
	 * @return the big decimal
	 * @throws SQLException the sQL exception
	 */
	public BigDecimal computePremiumAmount(String prorateFlag,  Date inceptionDate, Date expiryDate, BigDecimal premiumRate,BigDecimal tsiAmount) 
							throws SQLException; // royencela
	
	/**
	 * Make gipiQuoteItemPerilSummary list from :row
	 * @param jsonArray rows from View
	 * @param USER
	 * @return list of gipiQuoteItemPerilSummary
	 * @throws JSONException
	 */
	public List<GIPIQuoteItemPerilSummary> prepareItemPerilSummaryJSON(JSONArray row, GIISUser USER) 
			throws JSONException;
	
	public void updateItemPerilPremAmt(int quoteId, int itemNo, int perilCd, BigDecimal premAmt) throws SQLException;
	
	public List<GIPIQuoteItemPerilSummary> getGIPIQuoteItemPerilSummaryListForPack(Integer packQuoteId) throws SQLException;
}
