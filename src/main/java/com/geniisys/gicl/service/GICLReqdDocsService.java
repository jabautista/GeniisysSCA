/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.service
	File Name: GICLReqdDocsService.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Aug 5, 2011
	Description: 
*/


package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.common.entity.GIISUser;

import atg.taglib.json.util.JSONException;


public interface GICLReqdDocsService {
	public void saveClaimDocs(Map<String, Object> params) throws SQLException, JSONException, Exception;
	public Map<String, Object> getPrePrintDetails(Map<String, Object> params) throws SQLException;
	public String validateClmReqDocs(HttpServletRequest request, GIISUser USER) throws SQLException;
}
