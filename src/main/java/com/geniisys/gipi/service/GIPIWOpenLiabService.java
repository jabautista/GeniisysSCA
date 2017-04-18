/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIWOpenLiab;


/**
 * The Interface GIPIWOpenLiabService.
 */
public interface GIPIWOpenLiabService {

	/**
	 * Gets the w open liab.
	 * 
	 * @param parId the par id
	 * @return the w open liab
	 * @throws SQLException the sQL exception
	 */
	GIPIWOpenLiab getWOpenLiab(int parId) throws SQLException;
	GIPIWOpenLiab getWOpenLiab(int parId, String lineCd) throws SQLException;
	
	/**
	 * Save w open liab.
	 * 
	 * @param params the params
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	//boolean saveWOpenLiab(Map<String, Object> params) throws SQLException;
	boolean saveLimitOfLiability(Map<String, Object> params) throws Exception;
	boolean deleteWOpenLiab(int parId, int geogCd) throws SQLException;
	
	HashMap<String, Object> getEndtLolVars(Integer parId) throws SQLException;
	String saveEndtLimitOfLiability(HttpServletRequest request, String userId) throws JSONException, SQLException;
	Map<String, Object> getDefaultCurrency(HttpServletRequest request) throws SQLException;
	Map<String, Object> checkRiskNote(HttpServletRequest request) throws SQLException;
	
	// methods for GIPIS173
	Map<String, Object> getDefaultCurrencyGIPIS173(HttpServletRequest request) throws SQLException;
	String saveEndtLolGIPIS173(HttpServletRequest request, String userId) throws JSONException, SQLException;
	//Map<String, Object> saveEndtLolGIPIS173(HttpServletRequest request, String userId) throws JSONException, SQLException;
	Map<String, Object> getRecFlagGIPIS173(HttpServletRequest request) throws SQLException;
}
