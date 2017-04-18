/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.common.service
	File Name: GIISPrincipalSignatoryService.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: May 24, 2011
	Description: 
*/


package com.geniisys.common.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISAssured;
import com.geniisys.common.entity.GIISPrincipalRes;
import com.geniisys.common.entity.GIISUser;

public interface GIISPrincipalSignatoryService {
//	HashMap<String, Object> getPrincipalSignatories(HashMap<String, Object>params)throws SQLException, JSONException;
	JSONObject getPrincipalSignatories(HttpServletRequest request, String userId)throws SQLException, JSONException;
	GIISPrincipalRes getAssuredPrincipalResInfo(int assdNo) throws SQLException; 
	String validatePrincipalORCoSignorId(Map<String, Object>params)throws SQLException;
	String validateCTCNo(String ctcNo) throws SQLException ;
	String validateCTCNo2(HttpServletRequest request) throws SQLException ;
	void savePrincipalSignatory(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	GIISAssured getInitialAssdNo()throws SQLException;
	List<Integer> getPrinSignatoryIDList(Integer assdNo) throws SQLException;
	JSONObject getGiiss022Principal(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject showAllGiiss022(HttpServletRequest request, String userId) throws SQLException, JSONException;
}
