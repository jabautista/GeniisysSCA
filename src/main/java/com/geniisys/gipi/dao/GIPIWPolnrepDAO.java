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

import com.geniisys.gipi.entity.GIPIWPolnrep;


/**
 * The Interface GIPIWPolnrepDAO.
 */
public interface GIPIWPolnrepDAO {

	/**
	 * Gets the w polnrep.
	 * 
	 * @param parId the par id
	 * @return the w polnrep
	 * @throws SQLException the sQL exception
	 */
	List<GIPIWPolnrep> getWPolnrep(int parId) throws SQLException;
	
	/**
	 * Delete w polnreps.
	 * 
	 * @param parId the par id
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	boolean deleteWPolnreps(int parId) throws SQLException;
	
	/**
	 * Save w polnrep.
	 * 
	 * @param wpolnrep the wpolnrep
	 * @param polFlag the pol flag
	 * @return the map
	 * @throws SQLException the sQL exception
	 */
	Map<String, Object> saveWPolnrep(GIPIWPolnrep wpolnrep, String polFlag) throws SQLException;
	
	/**
	 * Check policy for renewal.
	 * 
	 * @param wpolnrep the wpolnrep
	 * @param polFlag the pol flag
	 * @return the map
	 * @throws SQLException the sQL exception
	 */
	Map<String, Object> checkPolicyForRenewal(GIPIWPolnrep wpolnrep, String polFlag) throws SQLException;
	
	/**
	 * Checks if is exist.
	 * 
	 * @param parId the par id
	 * @return the map
	 * @throws SQLException the sQL exception
	 */
	Map<String, String> isExist(Integer parId) throws SQLException;
	
	List<GIPIWPolnrep> getWPolnrep2(Integer parId) throws SQLException;
}
