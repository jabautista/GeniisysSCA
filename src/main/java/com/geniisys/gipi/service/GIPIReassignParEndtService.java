package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

public interface GIPIReassignParEndtService {

	JSONObject getReassignParEndtListing(HttpServletRequest request,String userId) throws SQLException,JSONException;
	String checkUser(HttpServletRequest request, String userId)throws SQLException;
	List<Map<String, Object>> saveReassignParEndt(HttpServletRequest request, GIISUser USER)throws SQLException,JSONException;
}
