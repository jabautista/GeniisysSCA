package com.geniisys.giri.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.giri.entity.GIRIBinder;

public interface GIRIBinderService {

	Map<String, Object> getPostedDtls(Map<String, Object> params) throws SQLException;
	void updateGiriBinderGiris026(String params, String userId) throws SQLException, JSONException, ParseException;
	String checkIfBinderExists(String parId) throws SQLException;
	void updateRevSwRevDate(String parId) throws SQLException, Exception;
	List<GIRIBinder> getBinderDetails(Map<String, Object> params) throws SQLException;
	public void updateBinderPrintDateCnt(Integer fnlBinderId) throws SQLException;
	List<Integer> getFnlBinderId(Map<String, Object> params) throws SQLException;
	void updateAcceptanceInfo(Map<String, Object> params) throws SQLException, JSONException, ParseException;
	List<Map<String, Object>> getBinders(Integer policyId) throws SQLException;
	String updateBinderStatusGIUTS012(HttpServletRequest request, String userId) throws SQLException, ParseException;
	JSONObject getRIPlacements(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> getPolicyFrps(HttpServletRequest request, String userId) throws SQLException;
	JSONObject getBinderPerils(HttpServletRequest request) throws SQLException, JSONException;
	Map<String, Object> getBinder(HttpServletRequest request, String userId) throws SQLException;
	JSONObject getOutwardRiList(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject showPolWithPremPayments(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject showGiris055(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject getDistPerilOverlayDtls(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject showInwardRIMenu(HttpServletRequest request, String userId) throws SQLException, JSONException;
	String checkBinderAccess(HttpServletRequest request, String userId) throws SQLException;
	void checkRIPlacementAccess(HttpServletRequest request, String userId) throws SQLException; //benjo 07.20.2015 UCPBGEN-SR-19626
}
