package com.geniisys.giis.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

public interface GIISPostingLimitService {

	JSONObject getPostingLimits (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	String validateCopyUser (HttpServletRequest request) throws SQLException;
	String validateCopyBranch (HttpServletRequest request) throws SQLException;
	String validateLineName (HttpServletRequest request) throws SQLException;
	void savePostingLimits(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void saveCopyToAnotherUser(HttpServletRequest request, String userId) throws SQLException, JSONException; //added userId by Gzelle 05.23.2013 - SR13166
}
