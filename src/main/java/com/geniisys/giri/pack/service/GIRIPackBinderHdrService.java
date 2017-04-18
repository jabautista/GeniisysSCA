package com.geniisys.giri.pack.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;

public interface GIRIPackBinderHdrService {

	void getGiriPackbinderHdrGrid(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	String savePackageBinderHdr(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;

}
