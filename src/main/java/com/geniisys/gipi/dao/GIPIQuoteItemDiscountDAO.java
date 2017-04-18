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

import com.geniisys.gipi.entity.GIPIQuoteItemDiscount;
import com.seer.framework.db.GenericDAO;


/**
 * The Interface GIPIQuoteItemDiscountDAO.
 */
public interface GIPIQuoteItemDiscountDAO extends GenericDAO<GIPIQuoteItemDiscount> {

	/**
	 * Gets the item discount list.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @return the item discount list
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIQuoteItemDiscount> getItemDiscountList(int quoteId) throws SQLException;
	
	/**
	 * Insert item discount.
	 * 
	 * @param itemDiscount the item discount
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean insertItemDiscount(GIPIQuoteItemDiscount itemDiscount) throws SQLException;
	
	/**
	 * Delete item discount.
	 * 
	 * @param itemDiscount the item discount
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean deleteItemDiscount(GIPIQuoteItemDiscount itemDiscount) throws SQLException;
	
}
