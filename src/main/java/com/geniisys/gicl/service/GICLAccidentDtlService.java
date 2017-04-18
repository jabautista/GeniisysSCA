/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.service
	File Name: GICLAccidentDtlService.java
	Author: Computer Professional Inc
	Created By: Belle
	Created Date: 11.29.2011
*/

package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;

public interface GICLAccidentDtlService {
	public void getGICLAccidentDtlGrid(HttpServletRequest request, GIISUser USER)throws SQLException, JSONException;
	public void getBeneficiaryDtlGrid(HttpServletRequest request, GIISUser USER)throws SQLException, JSONException;
	String validateClmItemNo(HttpServletRequest request, GIISUser USER)throws SQLException, JSONException, ParseException;
	String saveClmItemAccident(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	public void getClmAvailmentsGrid(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	public String getGroupedItemTitle(Map<String, Integer> params) throws SQLException;
	//String getAcBaseAmount(Integer param) throws SQLException;	//changed by kenneth SR20950 11.12.2015
	String getAcBaseAmount(HttpServletRequest request) throws SQLException;
}
