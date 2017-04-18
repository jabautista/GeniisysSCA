package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

public interface GIACPdcReplaceService {

	Map<String, Object> getPdcRepDtls(Map<String, Object> params) throws SQLException, JSONException;
	void saveGIACPdcReplace(HttpServletRequest request, String userId) throws SQLException, JSONException;
	
}
