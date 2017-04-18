package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;

public interface GICLAdvsPlaService {

	void getGiclAdvsPlaGrid(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	String cancelPLA(HttpServletRequest request, GIISUser USER) throws SQLException;
	String generatePLA(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	void updatePrintSwPla(HttpServletRequest request, GIISUser USER) throws SQLException;
	void updatePrintSwPla2(HttpServletRequest request, GIISUser USER) throws SQLException;
	String savePreliminaryLossAdv(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	HashMap<String, Object> getAllPlaDetails(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	
}
