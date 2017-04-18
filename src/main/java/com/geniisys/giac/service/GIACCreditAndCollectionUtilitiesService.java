/**
 * 
 */
package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

/**
 * @author steven
 *
 */
public interface GIACCreditAndCollectionUtilitiesService {
	
	JSONObject showCancelledPolicies(HttpServletRequest request, GIISUser USER)throws SQLException, JSONException;

	JSONObject showEndorsement(HttpServletRequest request, GIISUser USER)throws SQLException, JSONException;

	List<Map<String, Object>> getAllCancelledPol(HttpServletRequest request, GIISUser USER)throws SQLException, Exception;

	void processCancelledPol(HttpServletRequest request, GIISUser USER)throws SQLException, Exception;

	void ageBills(HttpServletRequest request, String userId) throws SQLException, Exception;
	
	JSONArray getPoliciesForReverseByParam(HttpServletRequest request, String userId) throws SQLException, JSONException;	// FGIC SR-4266 : shan 05.21.2015
	
	void reverseProcessedPolicies(HttpServletRequest request, String userId) throws SQLException, Exception;	// FGIC SR-4266 : shan 05.21.2015
}
