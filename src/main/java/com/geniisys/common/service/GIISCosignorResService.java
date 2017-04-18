/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.common.service
	File Name: GIISCosignorResService.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: May 25, 2011
	Description: 
*/


package com.geniisys.common.service;

import java.sql.SQLException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISCosignorResService {
	JSONObject getCosignorRes(HttpServletRequest request, String userId) throws SQLException, JSONException;
	List<Integer> getCoSignatoryIDList(Integer assdNo) throws SQLException;
}
