/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.service
	File Name: GICLCargoDtlService.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Sep 28, 2011
	Description: 
*/


package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.text.ParseException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;

public interface GICLCargoDtlService {
	public void getGICLCargoDtlGrid(HttpServletRequest request, GIISUser USER)throws SQLException, JSONException;
	String validateClmItemNo(HttpServletRequest request, GIISUser USER)throws SQLException, JSONException, ParseException;
	String saveClmItemMarineCargo(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
}
