package com.geniisys.common.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIACBankBookTranService {
	JSONObject showGiacs324(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	void saveGiacs324(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valBookTranCd(HttpServletRequest request) throws SQLException;
}
