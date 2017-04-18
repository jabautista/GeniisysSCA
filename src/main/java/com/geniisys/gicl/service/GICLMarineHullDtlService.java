package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.text.ParseException;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.common.entity.GIISUser;

import org.json.JSONException;

public interface GICLMarineHullDtlService {
	
	void getGiclMarineHullDtlGrid(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	String validateClmItemNo(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	String saveClmItemMarineHull(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	//void getPersonnelGrid(HttpServletRequest request, GIISUser USER) throws SQLException,JSONException, ParseException;
	
}
