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

import com.geniisys.gipi.entity.GIPIWinvTax;




/**
 * The Interface GIPIWinvTaxDAO.
 */
public interface GIPIWinvTaxDAO {
	
	/**
	 * Gets the gIPI winv tax.
	 * 
	 * @param parId the par id
	 * @param itemGrp the item grp
	 * @return the gIPI winv tax
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIWinvTax> getGIPIWinvTax(int parId, int itemGrp) throws SQLException;

	/**
	 * Save gipi winv tax.
	 * 
	 * @param winvtax the winvtax
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean saveGIPIWinvTax(GIPIWinvTax winvtax) throws SQLException;
	
	/**
	 * Delete all gipi winv tax.
	 * 
	 * @param parId the par id
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean deleteAllGIPIWinvTax(int parId) throws SQLException;
	
	/**
	 * Checks if is exist.
	 * 
	 * @param parId the par id
	 * @return the map
	 * @throws SQLException the sQL exception
	 */
	public Map<String, String> isExist(Integer parId) throws SQLException;
	
	/** Created by: TONIO January 27, 2011
	 * Gets the gIPI winv tax.
	 * 
	 * @param parId the par id
	 * 
	 * @return the gIPI winv tax
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIWinvTax> getGIPIWinvTax2(int parId) throws SQLException;
	
}


