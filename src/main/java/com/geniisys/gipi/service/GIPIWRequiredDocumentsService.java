/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIWRequiredDocuments;


/**
 * The Interface GIPIWRequiredDocumentsService.
 */
public interface GIPIWRequiredDocumentsService {
	
	/**
	 * Gets the req docs list.
	 * 
	 * @param parId the par id
	 * @return the req docs list
	 * @throws SQLException the sQL exception
	 */
	List<GIPIWRequiredDocuments> getReqDocsList(Integer parId) throws SQLException;
	
	/**
	 * Save gipiw req docs.
	 * 
	 * @param params the params
	 * @throws SQLException the sQL exception
	 */
	void saveGIPIWReqDocs(Map<String, Object> params) throws SQLException;
	
	/**
	 * Save GIPIS req docs. To be used for JSOn/Tablegrid (agazarraga)
	 * created by agazarraga 5/11/2012 for tablegrid conversion [saving]
	 * @param params the params
	 * @throws SQLException the sQL exception
	 */
	void saveGIPISReqDocs(HttpServletRequest request, String userId)
			throws SQLException, JSONException;
	

}
