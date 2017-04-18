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

import com.geniisys.gipi.entity.GIPIQuoteItemPerilDiscount;
import com.seer.framework.db.GenericDAO;


/**
 * The Interface GIPIQuoteItemPerilDiscountDAO.
 */
public interface GIPIQuoteItemPerilDiscountDAO extends GenericDAO<GIPIQuoteItemPerilDiscount>{
	
	/**
	 * Gets the item peril discount list.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @param perilCd the peril cd
	 * @return the item peril discount list
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIQuoteItemPerilDiscount> getItemPerilDiscountList(int quoteId) throws SQLException;
	
	/**
	 * Insert item peril discount.
	 * 
	 * @param perilDiscount the peril discount
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean insertItemPerilDiscount(GIPIQuoteItemPerilDiscount perilDiscount) throws SQLException;
	
	/**
	 * Delete item peril discount.
	 * 
	 * @param perilDiscount the peril discount
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean deleteItemPerilDiscount(GIPIQuoteItemPerilDiscount perilDiscount) throws SQLException;

}
