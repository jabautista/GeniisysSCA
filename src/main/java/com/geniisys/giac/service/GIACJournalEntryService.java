package com.geniisys.giac.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

/**
 * @author steven
 * @date 03.18.2013
 */
public interface GIACJournalEntryService {

	JSONObject getJournalListing(HttpServletRequest request, String userId)throws SQLException,JSONException;

	void getJournalEntries(HttpServletRequest request, String userId)throws SQLException,JSONException;

	List<Map<String, Object>> setGiacAcctrans(HttpServletRequest request, GIISUser USER)throws SQLException,JSONException, Exception;

	JSONObject getJVTranType(HttpServletRequest request)throws SQLException,JSONException;

	String validateTranDate(HttpServletRequest request)throws SQLException, ParseException;

	Map<String, Object> printOpt(HttpServletRequest request)throws SQLException,JSONException;

	String checkUserPerIssCdAcctg(HttpServletRequest request, GIISUser USER) throws SQLException;

	String checkCommPayts(HttpServletRequest request) throws SQLException;

	List<Map<String, Object>>saveCancelOpt(HttpServletRequest request, GIISUser USER) throws SQLException, Exception;

	String getDetailModule(HttpServletRequest request) throws SQLException;

	List<Map<String, Object>> showDVInfo(HttpServletRequest request)throws SQLException, Exception;
	
	String validateJVCancel(HttpServletRequest request) throws SQLException, Exception;//added by John Daniel SR-5182
}
