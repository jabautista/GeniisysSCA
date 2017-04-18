package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.gipi.entity.GIPIWBondBasic;

public interface GIPIWBondBasicService {
	
	GIPIWBondBasic getGIPIWBondBasic(Integer parId) throws SQLException;
	void saveBondPolicyData(Map<String, Object> params) throws SQLException;
	void saveEndtBondPolicyData(Map<String, Object>params)throws SQLException;
	GIPIWBondBasic getBondBasicNewRecord(Integer parId) throws SQLException;
	
	// shan 10.13.2014
	JSONObject showLandCarrierDtl(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void saveLandCarrierDtl(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddLandCarrierDtl(HttpServletRequest request) throws SQLException;
	Integer getMaxItemNoLandCarrierDtl(Integer parId) throws SQLException;
}
