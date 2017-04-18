package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;

public interface GICLAdvsFlaService{
	String generateFLA(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	Integer getAdvFlaId() throws SQLException;
	Map<String, Object> cancelFla(Map<String, Object> params) throws SQLException;
	void updateFla(Map<String, Object> params) throws SQLException;
	String validatePdFla(Map<String, Object> params) throws SQLException;
	void updateFlaPrintSw(Map<String, Object> params) throws SQLException;
}
