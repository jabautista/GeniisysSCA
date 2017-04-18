package com.geniisys.giis.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;

public interface GIISPerilClassService {
//	List<GIISPerilClass> getClassListing() throws SQLException, IOException;
//	List<GIISPerilClass> getPerilNameListing() throws SQLException, IOException;
	void savePerilClass(HttpServletRequest request, String userId) throws SQLException, JSONException, Exception;
	Map<String, Object> getPerilsPerClass(HttpServletRequest request, GIISUser USER) throws Exception;
	Map<String, Object> getPerilsPerClassDetails(HttpServletRequest request,GIISUser USER) throws Exception;
	String getAllPerilsPerClassDetails(HttpServletRequest request, String userId) throws SQLException, JSONException, Exception;
}
