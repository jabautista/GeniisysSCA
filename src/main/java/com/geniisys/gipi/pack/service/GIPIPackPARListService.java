package com.geniisys.gipi.pack.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.framework.util.JSONArrayList;
import com.geniisys.gipi.pack.entity.GIPIPackPARList;

public interface GIPIPackPARListService {
	//PaginatedList getGipiPackParList(String lineCd, int pageNo, String keyword) throws SQLException;
	JSONArrayList getGipiPackParList(String lineCd, int pageNo, String keyword, String userId) throws SQLException;
	//PaginatedList getGipiEndtPackParList(String lineCd, int pageNo, String keyword) throws SQLException;
	JSONArrayList getGipiEndtPackParList(String lineCd, int pageNo, String keyword, String userId) throws SQLException;
	Map<String, Object> checkRITablesBeforeDeletion (Integer packParId) throws SQLException;
	void updatePackParRemarks(JSONArray updatedRows) throws SQLException, JSONException;
	void deletePackPar(Map<String, Object> params) throws SQLException, Exception;
	void cancelPackPar(Map<String, Object> params) throws SQLException, Exception;
	GIPIPackPARList saveGIPIPackPar(GIPIPackPARList gipipackpar) throws SQLException;
	GIPIPackPARList saveGIPIPackPar(Map<String, Object> params)throws SQLException;
	GIPIPackPARList getGIPIPackParDetails(Integer packParId) throws SQLException;
	void updatePackStatusFromQuote(Integer quoteId, Integer parStatus) throws SQLException;
	String checkPackParQuote(Integer packParId) throws SQLException;
	String checkIfLineSublineExist(Map<String, Object> params) throws SQLException;
	void createParListWPack(Map<String, Object> params) throws SQLException;
	
	HashMap<String, Object> getGipiPackParListing(HashMap<String, Object> params) throws SQLException, JSONException;
	Map<String, Object> saveRIPackPar(Map<String, Object> params, String userId) throws SQLException, JSONException, ParseException, Exception;
	Integer generatePackParIdGiuts008a() throws SQLException;
	HashMap<String, Object> getPackParListGiuts008a(Integer packPolicyId) throws SQLException;
	void insertPackParListGiuts008a(Map<String, Object> params) throws SQLException;
	String getPackSharePercentage(Integer packParId) throws SQLException;
	String checkGipis095PackPeril(HttpServletRequest request) throws SQLException;
}
