/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.service
	File Name: GICLEvalLoaService.java
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

public interface GICLEvalLoaService {
	Map<String, Object> getMcEvalLoaTGLst(HttpServletRequest request, GIISUser USER) throws SQLException , JSONException;
	Map<String, Object> getMcEvalLoaDtlTGList(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	void generateLoa(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	String generateLoaFromLossExp(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, Exception; 
}
