/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIWOpenPolicy;


/**
 * The Interface GIPIWOpenPolicyService.
 */
public interface GIPIWOpenPolicyService {
	
	/**
	 * Save open policy details.
	 * 
	 * @param gipiWOpenPolicy the gipi w open policy
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	void saveOpenPolicyDetails(Map<String, Object> params)throws SQLException;
	
	/**
	 * Gets the w open policy.
	 * 
	 * @param parId the par id
	 * @return the w open policy
	 * @throws SQLException the sQL exception
	 */
	GIPIWOpenPolicy getWOpenPolicy(Integer parId) throws SQLException;
	
	/**
	 * Checks if is exist.
	 * 
	 * @param parId the par id
	 * @return the map
	 * @throws SQLException the sQL exception
	 */
	Map<String, String> isExist(Integer parId) throws SQLException;
	Map<String, Object> validatePolicyDate(Map<String, Object> params) throws SQLException;
}
