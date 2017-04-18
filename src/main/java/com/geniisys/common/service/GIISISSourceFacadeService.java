/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISISSource;
import com.geniisys.common.entity.GIISUser;


/**
 * The Interface GIISISSourceFacadeService.
 */
public interface GIISISSourceFacadeService {
	
	/**
	 * Gets the issue source all list.
	 * 
	 * @return the issue source all list
	 * @throws SQLException the sQL exception
	 */
	public List<GIISISSource> getIssueSourceAllList() throws SQLException;
	
	/**
	 * Gets the default iss cd.
	 * 
	 * @param riSwitch the ri switch
	 * @param userId the user id
	 * @return the default iss cd
	 * @throws SQLException the sQL exception
	 */
	public String getDefaultIssCd(String riSwitch, String userId) throws SQLException;
	
	Map<String, Object> validatePolIssCd(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateIssCd(Map<String, Object> params) throws SQLException;
	List<GIISISSource> validateIssCdGiexs006(Map<String, Object> params) throws SQLException;
	
	List<GIISISSource> getIssueSourceListing(Map<String, Object> params) throws SQLException;
	List<GIISISSource> getAllIssueSourceListing(Map<String, Object> params) throws SQLException;
	List<GIISISSource> getIssueSourceListingLOV(Map<String, Object> params) throws SQLException;

	String getIssNameGicls201(HttpServletRequest request, String userId) throws SQLException;
	
	String getIssCdForBatchPosting (GIISUser USER) throws SQLException;
	
	// shan 11.05.2013
	JSONObject showGiiss004(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGiiss004(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	JSONObject showGiiss004Place(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeletePlaceRec(HttpServletRequest request) throws SQLException;
	void saveGiiss004Place(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddPlaceRec(HttpServletRequest request) throws SQLException;
	JSONObject getAllIssuePlaces(HttpServletRequest request, String userId) throws SQLException, JSONException;
	String getAcctIssCdList() throws SQLException;
}
