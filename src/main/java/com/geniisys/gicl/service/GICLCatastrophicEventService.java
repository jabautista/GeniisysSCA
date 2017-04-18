/*created by: john dolon 9.9.2013*/

package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

public interface GICLCatastrophicEventService {
	//Inquiry 9.9.2013
	JSONObject showCatastrophicEventInquiry(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	Map<String, Object> validateGicls057Line(HttpServletRequest request) throws SQLException;
	Map<String, Object> validateGicls057Catastrophy(HttpServletRequest request) throws SQLException;
	Map<String, Object> validateGicls057Branch(HttpServletRequest request) throws SQLException;
	
	// GICLS200
	Map<String, Object> getUserParams(String userId) throws SQLException;
	Integer extractOsPdPerCat(HttpServletRequest request, String userId) throws SQLException;
	JSONObject valExtOsPdClmRecBefPrint(String userId) throws SQLException;
	
	JSONObject getGICLS056CatastrophicEvent(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject getGICLS056Details(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject getGICLS056ClaimList(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject getGICLS056ClaimListFi(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	void gicls056UpdateDetails(HttpServletRequest request, GIISUser USER) throws SQLException, Exception;
	void saveGicls056(HttpServletRequest request, String userId) throws SQLException, JSONException;
	String gicls056ValDelete(HttpServletRequest request) throws SQLException;
	void gicls056UpdateDetailsAll(HttpServletRequest request, String userId) throws SQLException;
	void gicls056RemoveAll(HttpServletRequest request, String userId) throws SQLException;
	void gicls056ValAddRec(HttpServletRequest request) throws SQLException;
	String gicls056GetClaimNos(HttpServletRequest request, String userId) throws SQLException;;
	String gicls056GetClaimNosList(HttpServletRequest request, String userId) throws SQLException;
	String gicls056GetClaimNosListFi(HttpServletRequest request, String userId) throws SQLException;
	JSONObject gicls056GetDspAmt(HttpServletRequest request, String userId) throws SQLException;
}
