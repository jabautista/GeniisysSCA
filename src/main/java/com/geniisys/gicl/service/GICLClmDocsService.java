/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.giac.service
	File Name: GICLClmDocsService.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Aug 9, 2011
	Description: 
*/


package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.gicl.entity.GICLClmDocs;

public interface GICLClmDocsService {
	
	public List<GICLClmDocs> getClmDocsList(Map<String, Object> params)throws SQLException;
	JSONObject showGicls110(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void saveGicls110(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteRec(HttpServletRequest request, String userId) throws SQLException;
}
