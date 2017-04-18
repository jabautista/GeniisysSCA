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

import com.geniisys.gipi.entity.GIPIQuotePolicyBasicDiscount;
import com.seer.framework.db.GenericDAO;


/**
 * The Interface GIPIQuotePolicyBasicDiscountDAO.
 */
public interface GIPIQuotePolicyBasicDiscountDAO extends GenericDAO<GIPIQuotePolicyBasicDiscount> {
	
	/**
	 * Gets the policy discount list.
	 * 
	 * @param quoteId the quote id
	 * @return the policy discount list
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIQuotePolicyBasicDiscount> getPolicyDiscountList(int quoteId) throws SQLException;
	
	/**
	 * Insert policy discount.
	 * 
	 * @param polDiscount the pol discount
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean insertPolicyDiscount(GIPIQuotePolicyBasicDiscount polDiscount) throws SQLException;
	
	/**
	 * Delete policy discount.
	 * 
	 * @param polDiscount the pol discount
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean deletePolicyDiscount(GIPIQuotePolicyBasicDiscount polDiscount) throws SQLException;

}
