package com.geniisys.common.service;

import java.sql.SQLException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISReports;

public interface GIISReportsService {

	String getReportVersion(String reportId) throws SQLException;
	String getReportVersion(String reportId, String lineCd) throws SQLException;
	List<GIISReports> getReportsPerLineCd(String lineCd) throws SQLException;
	List<GIISReports> getReportsListing() throws SQLException;
	List<GIISReports> getReportsListing2(String lineCd) throws SQLException;
	String getReportDesname2(String reportId) throws SQLException;
	List<GIISReports> getGicls201Reports() throws SQLException;
	String validateReportId(String reportId) throws SQLException;
	
	// For GIISS090 - Reports Maintenance
	JSONObject showGiiss090(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGiiss090(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
}

