package com.geniisys.giac.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

public interface GIACPaytRequestsDtlService {

	//modified from void to JSONObject; shan 08.29.2013 for GIACS070
	JSONObject getGiacPaytRequestsDtl(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;

}
