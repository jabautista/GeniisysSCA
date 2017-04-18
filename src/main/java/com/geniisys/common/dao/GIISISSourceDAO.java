/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISISSource;


/**
 * The Interface GIISISSourceDAO.
 */
public interface GIISISSourceDAO {
	
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
	
	Map<String, Object> getIssNameGicls201(Map<String, Object> params) throws SQLException;
	
	String getIssCdForBatchPosting(Map<String, Object> params) throws SQLException;
	
	// shan 11.05.2013
	void saveGiiss004(Map<String, Object> params) throws SQLException;
	void valDeleteRec(Map<String, Object> params) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;	
	void saveGiiss004Place(Map<String, Object> params) throws SQLException;
	void valDeletePlaceRec(Map<String, Object> params) throws SQLException;
	void valAddPlaceRec(Map<String, Object> params) throws SQLException;
	String getAcctIssCdList() throws SQLException;
}
