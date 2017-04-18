package com.geniisys.gipi.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

public interface GUEAttachService {
	
	void saveGUEAttachments(HttpServletRequest request, String userId) throws SQLException, JSONException;
	
}
