package com.geniisys.giis.service;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.ibm.disthub2.impl.matching.selector.ParseException;

public interface GIISPerilMaintenanceService {
	JSONObject  getPerilList(HttpServletRequest request) throws JSONException, SQLException, IOException;
	String savePeril(HttpServletRequest request, String userId) throws JSONException, SQLException, ParseException;
	String validateDeletePeril (HttpServletRequest request) throws SQLException;
	String perilIsExist (HttpServletRequest request)throws JSONException, SQLException, ParseException;
	String validatePerilSname (HttpServletRequest request)throws JSONException, SQLException, ParseException;
	String validatePerilName (HttpServletRequest request)throws JSONException, SQLException, ParseException;
	String saveTariff(HttpServletRequest request, String userId) throws JSONException, SQLException, ParseException;
	String validateDeleteTariff (HttpServletRequest request) throws SQLException;
	String saveWarrCla(HttpServletRequest request, String userId) throws JSONException, SQLException, ParseException;
	String validateDefaultTsi (HttpServletRequest request)throws JSONException, SQLException, ParseException;
	String getSublineCdName (HttpServletRequest request)throws JSONException, SQLException, ParseException;
	String getBasicPerilCdName (HttpServletRequest request)throws JSONException, SQLException, ParseException;
	String getZoneNameFiName (HttpServletRequest request)throws JSONException, SQLException, ParseException;
	String getZoneNameMcName (HttpServletRequest request)throws JSONException, SQLException, ParseException;
	String checkAvailableWarrcla (HttpServletRequest request)throws JSONException, SQLException, ParseException;
	String validateSublineName (HttpServletRequest request)throws JSONException, SQLException, ParseException;
	String validateFiList (HttpServletRequest request)throws JSONException, SQLException, ParseException;
	String validateMcList (HttpServletRequest request)throws JSONException, SQLException, ParseException;
}
