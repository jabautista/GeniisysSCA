/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.dao
	File Name: GICLReqdDocsDAO.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Aug 5, 2011
	Description: 
*/


package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

import atg.taglib.json.util.JSONException;


public interface GICLReqdDocsDAO {
	/*List<GICLReqdDocs> getDocumentTableGridListing(Map<String, Object>params) throws SQLException;*/
	void saveClaimDocs(Map<String, Object>params) throws SQLException, JSONException, Exception;
	Map<String, Object> getPrePrintDetails(Map<String, Object>params)throws SQLException;
	String validateClmReqDocs(Map<String, Object> params) throws SQLException;
}
