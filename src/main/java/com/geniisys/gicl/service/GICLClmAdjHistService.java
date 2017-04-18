package com.geniisys.gicl.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;

public interface GICLClmAdjHistService {

	String getGiclClmAdjHistExist(String claimId) throws SQLException;
	String getDateCancelled(HttpServletRequest request, GIISUser USER) throws SQLException;
	void getClmAdjHistListGrid(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	void getClmAdjHistListGrid2(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
}
