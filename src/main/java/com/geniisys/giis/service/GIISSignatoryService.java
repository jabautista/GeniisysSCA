package com.geniisys.giis.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

public interface GIISSignatoryService {
	String validateSignatoryReport(HttpServletRequest request) throws SQLException, JSONException;
	public void saveGIISSignatory(HttpServletRequest request, String userId) throws SQLException, JSONException;
	public void updateFilename(Map<String, Object> params) throws SQLException;
	String getGIISS116UsedSignatories(HttpServletRequest request) throws SQLException;
}
