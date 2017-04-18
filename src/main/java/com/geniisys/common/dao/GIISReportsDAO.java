package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISReports;

public interface GIISReportsDAO {

	String getReportVersion(String reportId) throws SQLException;
	String getReportVersion(Map<String, Object> params) throws SQLException;
	List<GIISReports> getReportsPerLineCd(String lineCd) throws SQLException;
	List<GIISReports> getReportsListing() throws SQLException;
	List<GIISReports> getReportsListing2(String lineCd) throws SQLException;
	String getReportDesname2(String reportId) throws SQLException;
	List<GIISReports> getGicls201Reports() throws SQLException;	//shan 03.18.2013
	String validateReportId(String reportId) throws SQLException; //shan 06.18.2013
	
	// for GIISS090 - Reports Maintenance
	void saveGiiss090(Map<String, Object> params) throws SQLException;
	void valDeleteRec(String recId) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;
}
