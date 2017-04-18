package com.geniisys.gicl.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

public interface GICLFunctionOverrideService {
	
	public JSONObject getGICLFunctionOverrideRecords(HttpServletRequest request, GIISUser user, String ACTION) throws SQLException, JSONException;
	public void updateFunctionOverride(HttpServletRequest request, String userId) throws SQLException, JSONException;

}
