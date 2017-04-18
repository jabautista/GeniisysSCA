package com.geniisys.giac.service;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

public interface GIACGeneralLedgerReportService {

	Map<String, Object> getGiacs503NewFormInstance() throws SQLException;
	Map<String, Object> postGiacs503SL(Map<String, Object> params) throws SQLException, Exception;
	Integer validateGiacs503BeforePrint(Map<String, Object> params) throws SQLException;
	String extractGiacs501 (HttpServletRequest request, GIISUser USER) throws SQLException, ParseException;
	String validatePayeeCdGiacs110(HttpServletRequest request) throws SQLException;
	String validateTaxCdGiacs110(HttpServletRequest request) throws SQLException;
	String validatePayeeNoGiacs110(HttpServletRequest request) throws SQLException;
	String extractMotherAccounts (HttpServletRequest request, GIISUser USER) throws SQLException, ParseException;
	String extractMotherAccountsDetail (HttpServletRequest request, GIISUser USER) throws SQLException, ParseException;
	JSONObject showBIRAlphalist(HttpServletRequest request) throws SQLException, JSONException;
	String checkExtractGIACS115(HttpServletRequest request, GIISUser USER) throws SQLException;
	String extractGIACS115(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	String generateCSVGIACS115(HttpServletRequest request, GIISUser USER) throws SQLException, IOException;
}
