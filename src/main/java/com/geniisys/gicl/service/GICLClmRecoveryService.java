package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

public interface GICLClmRecoveryService {

	void getGiclClmRecoveryGrid(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	void getGiclClmRecoveryPayorGrid(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	void getGiclClmRecoveryHistGrid(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	void getGiclClmRecoveryGrid2(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	String saveRecoveryInfo(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	String genRecHistNo(HttpServletRequest request, GIISUser USER) throws SQLException;
	String checkRecoveredAmtPerRecovery(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	void writeOffRecovery(HttpServletRequest request, GIISUser USER) throws SQLException;
	void cancelRecovery(HttpServletRequest request, GIISUser USER) throws SQLException;
	void closeRecovery(HttpServletRequest request, GIISUser USER) throws SQLException;
	void getClmRecoveryDistInfoGrid(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	JSONObject validatePrint(HttpServletRequest request) throws SQLException;
	void updateDemandLetterDates(HttpServletRequest request, String userId) throws SQLException;
	Map<String, Object> getGicls025Variables(Integer claimId) throws SQLException;	
}
