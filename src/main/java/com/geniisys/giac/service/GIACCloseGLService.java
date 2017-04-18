package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

public interface GIACCloseGLService {

	void showCloseGL(HttpServletRequest request, String userId)throws SQLException,JSONException;

	Map<String, Object> closeGenLedger(HttpServletRequest request, String userId)throws SQLException, Exception;

	Map<String, Object> closeGenLedgerConfirmation(HttpServletRequest request,String userId)throws SQLException, Exception;
}
