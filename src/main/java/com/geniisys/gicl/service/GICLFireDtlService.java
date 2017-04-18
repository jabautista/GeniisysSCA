package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.text.ParseException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;

public interface GICLFireDtlService {

	void getGiclFireDtlGrid(HttpServletRequest request, GIISUser USER, ApplicationContext APPLICATION_CONTEXT) throws SQLException, JSONException;
	String validateClmItemNo(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	String saveClmItemFire(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	String getGiclFireDtlExist(String claimId) throws SQLException;

}
