/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.service
	File Name: GICLEvalCslService.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Mar 2, 2012
	Description: 
*/


package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;

public interface GICLEvalCslService {
	Map<String, Object> getMcEvalCslTGList(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	Map<String, Object> getMcEvalCslDtlTGList (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	void generateCsl(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	String generateCslFromLossExp(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, Exception;
}
