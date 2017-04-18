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

import com.geniisys.gipi.entity.GIPIWRequiredDocuments;


/**
 * The Interface GIPIWRequiredDocumentsDAO.
 */
public interface GIPIWRequiredDocumentsDAO {
	
	/**
	 * Gets the req docs list.
	 * 
	 * @param parId the par id
	 * @return the req docs list
	 * @throws SQLException the sQL exception
	 */
	List<GIPIWRequiredDocuments> getReqDocsList(Integer parId) throws SQLException;
	
	/**
	 * Delete w req doc.
	 * 
	 * @param parId the par id
	 * @param docCd the doc cd
	 * @throws SQLException the sQL exception
	 */
	void deleteWReqDoc(Integer parId, String docCd) throws SQLException;
	
	/**
	 * Insert w req doc.
	 * 
	 * @param params the params
	 * @throws SQLException the sQL exception
	 */
	void insertWReqDoc(Map<String, Object> params) throws SQLException;
	//void insertWReqDoc(GIPIWRequiredDocuments gipiWReqDocs) throws SQLException;
	
	void saveGIPIWReqDocs(Map<String, Object> params) throws SQLException;
	//created by agazarraga 5/11/2012 for tablegrid conversion [saving]
	void saveGIPISReqDocs(Map<String, List<GIPIWRequiredDocuments>> params) throws SQLException;

}
