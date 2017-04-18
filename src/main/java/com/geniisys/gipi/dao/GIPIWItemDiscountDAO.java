/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIWItemDiscount;


/**
 * The Interface GIPIWItemDiscountDAO.
 */
public interface GIPIWItemDiscountDAO {

	/**
	 * Gets the gipi w item discount.
	 * 
	 * @param parId the par id
	 * @return the gipi w item discount
	 * @throws SQLException the sQL exception
	 */
	List<GIPIWItemDiscount> getGipiWItemDiscount(Integer parId) throws SQLException;
	
	/**
	 * Gets the orig item prem.
	 * 
	 * @param parId the par id
	 * @param itemNo the item no
	 * @return the orig item prem
	 * @throws SQLException the sQL exception
	 */
	Map<String, String> getOrigItemPrem(Integer parId, String itemNo) throws SQLException;
	
	/**
	 * Gets the net item prem.
	 * 
	 * @param parId the par id
	 * @param itemNo the item no
	 * @return the net item prem
	 * @throws SQLException the sQL exception
	 */
	Map<String, String> getNetItemPrem(Integer parId, String itemNo, HashMap<String, Object> mainParams) throws SQLException;
	
}
