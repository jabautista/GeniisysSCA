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
import java.util.Map;

import com.geniisys.gipi.entity.GIPIWOpenLiab;


/**
 * The Interface GIPIWOpenLiabDAO.
 */
public interface GIPIWOpenLiabDAO {

	/**
	 * Gets the w open liab.
	 * 
	 * @param parId the par id
	 * @return the w open liab
	 * @throws SQLException the sQL exception
	 */
	GIPIWOpenLiab getWOpenLiab(int parId) throws SQLException;
	GIPIWOpenLiab getWOpenLiab(Map<String, Object> params) throws SQLException;
	
	/**
	 * Save w open liab.
	 * 
	 * @param wopenLiab the wopen liab
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	//boolean saveWOpenLiab(GIPIWOpenLiab wopenLiab) throws SQLException;
	boolean saveLimitOfLiability(Map<String, Object> preparedParams) throws Exception;
	boolean deleteWOpenLiab(int parId, int geogCd) throws SQLException;
	
	HashMap<String, Object> getEndtLolVars(Integer parId) throws SQLException;
	String saveEndtLimitOfLiability(Map<String, Object> params) throws SQLException;
	Map<String, Object> getDefaultCurrency(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkRiskNote(Map<String, Object> params) throws SQLException;
	
	// methods for GIPIS173
	Map<String, Object> getDefaultCurrencyGIPIS173(Map<String, Object> params) throws SQLException;
	String saveEndtLolGIPIS173(Map<String, Object> params) throws SQLException;
	//Map<String, Object> saveEndtLolGIPIS173(Map<String, Object> params) throws SQLException;
	Map<String, Object> getRecFlagGIPIS173(Map<String, Object> params) throws SQLException;
}
