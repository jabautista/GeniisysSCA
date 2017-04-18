/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.gipi.dao;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.Date;
import java.util.List;

import com.geniisys.gipi.entity.GIPIQuoteItemPeril;
import com.geniisys.gipi.entity.GIPIQuoteItemPerilSummary;
import com.seer.framework.db.GenericDAO;


/**
 * The Interface GIPIQuoteItemPerilDAO.
 */
public interface GIPIQuoteItemPerilDAO extends GenericDAO<GIPIQuoteItemPeril>{

	/**
	 * Gets the gIPI quote item peril summary list.
	 * 
	 * @param quoteId the quote id
	 * @return the gIPI quote item peril summary list
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIQuoteItemPerilSummary> getGIPIQuoteItemPerilSummaryList(int quoteId) throws SQLException;
	
	/**
	 * Sets the gIPI quote item peril.
	 * 
	 * @param quoteItemPeril the new gIPI quote item peril
	 * @throws SQLException the sQL exception
	 */
	public void setGIPIQuoteItemPeril(GIPIQuoteItemPeril quoteItemPeril) throws SQLException;
	
	/**
	 * Save gipi quote item peril.
	 * 
	 * @param quoteItemPeril the quote item peril
	 * @throws SQLException the sQL exception
	 */
	public void saveGIPIQuoteItemPeril(GIPIQuoteItemPeril quoteItemPeril) throws SQLException; // whofeih
	
	/**
	 * Del gipi quote item peril.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @param perilCd the peril cd
	 * @throws SQLException the sQL exception
	 */
	public void delGIPIQuoteItemPeril(int quoteId, int itemNo, int perilCd) throws SQLException;
	
	/**
	 * Delete gipi quote item all perils.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @throws SQLException the sQL exception
	 */
	void deleteGIPIQuoteItemAllPerils(int quoteId, int itemNo) throws SQLException;
	
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
	
	public void updateItemPerilPremAmt(int quoteId, int itemNo, int perilCd, BigDecimal premAmt) throws SQLException;
	
	public List<GIPIQuoteItemPerilSummary> getGIPIQuoteItemPerilSummaryListForPack(Integer packQuoteId) throws SQLException;
}
