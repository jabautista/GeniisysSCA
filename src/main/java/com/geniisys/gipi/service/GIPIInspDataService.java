package com.geniisys.gipi.service;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.PaginatedList;
import com.geniisys.gipi.entity.GIPIInspData;

public interface GIPIInspDataService {

	PaginatedList getGipiInspData1(Map<String, Object> params) throws SQLException;
	List<GIPIInspData> getInspDataItemInfo(Integer inspNo) throws SQLException;
	void saveGipiInspData(String inspDataParams, String user) throws Exception;
	String getBlockId(Map<String, Object> params) throws SQLException;
	Integer generateInspNo() throws SQLException;
	GIPIInspData getInspOtherDtls(Map<String, Object> otherParams) throws SQLException;
	/*HashMap<String, Object> getGipiInspData1TableGrid(HashMap<String, Object> params) throws SQLException, JSONException;*/ //remove by steven 9.20.2013
	HashMap<String, Object> getQuoteInpsList(HashMap<String, Object>params) throws SQLException, JSONException;
	void saveInspectionAttachments(HttpServletRequest request, String userId) throws SQLException, JSONException;
	String saveInspectionToPAR(Map<String, Object> params) throws SQLException, Exception;
	JSONObject getGipiInspData1TableGrid2(HttpServletRequest request)throws SQLException, JSONException, ParseException;
	void saveWarrAndClauses(HttpServletRequest request, String user) throws Exception;
	void saveInspectionInformation(HttpServletRequest request, String user) throws Exception; //added by john 3.21.2016 SR#5470
	JSONObject showInspectionReport(HttpServletRequest request, String user) throws Exception; //added by john 4.20.2016 SR#5470
	Integer getAttachmentTotalSize(Map<String, Object> params) throws SQLException, IOException;
	
	String copyAttachments(Map<String, Object> params) throws SQLException, IOException;
}
