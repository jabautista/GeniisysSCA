/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.service
	File Name: BatchService.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Dec 20, 2011
	Description: 
*/


package com.geniisys.gicl.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.entity.GIISUser;


public interface BatchService {
	String generateAe(HttpServletRequest request, GIISUser user)throws SQLException, JSONException;
	String approveBatchCsr(JSONObject objParams, GIISUser USER)throws SQLException, Exception;
	String postRecovery(JSONObject objParams, GIISUser USER) throws SQLException, Exception;
}
