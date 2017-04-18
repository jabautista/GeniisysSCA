package com.geniisys.giac.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.giac.entity.GIACSoaRepExt;
import com.geniisys.giac.entity.GIACSoaRepExtParam;

public interface GIACCreditAndCollectionReportsService {

	GIACSoaRepExtParam getDefualtSOAParams(String userId) throws SQLException, Exception;
	GIACSoaRepExtParam getExtractDate(Map<String, Object> params) throws SQLException, Exception;
	Map<String, Object> getSOARepDtls(HttpServletRequest request, String userId) throws SQLException, Exception;
	String breakdownTaxPayments(HttpServletRequest request, String userId) throws SQLException, Exception;
	GIACSoaRepExtParam setDefaultDates(HttpServletRequest request, String userId) throws SQLException; // done after extraction
	String getSOARemarks() throws SQLException;
	
	//String saveCollectionLetterParams(HttpServletRequest request, String userId) throws SQLException, JSONException, Exception;
	List<GIACSoaRepExt> saveCollectionLetterParams(HttpServletRequest request, String userId) throws SQLException, JSONException, Exception;
	List<GIACSoaRepExt> selectAllRecords(Map<String, Object> params) throws SQLException;
	
	String processIntmOrAssd(Map<String, Object> params) throws SQLException;
	/*List<GIACSoaRepExt> processIntmOrAssd2(Map<String, Object> params) throws SQLException, Exception;*/
	String processIntmOrAssd2(Map<String, Object> params) throws SQLException, Exception;
	
	List<GIACSoaRepExt> fetchParameters(HttpServletRequest request,	String userId) throws SQLException, JSONException;
	String checkUserDate(String userId) throws SQLException;
	
	
	//added by kenneth L. for aging of collections 07.02.2013
	String extractAgingOfCollections (String userId) throws SQLException;
	String inserToAgingExt (HttpServletRequest request, GIISUser USER) throws SQLException, ParseException;

	String giacs329ValidateDateParams(HttpServletRequest request, GIISUser USER) throws SQLException, Exception;
	Map<String, Object> extractGIACS329(HttpServletRequest request, GIISUser uSER) throws SQLException, Exception;
	void checkExistingReport(String reportId) throws SQLException, Exception;
	String giacs480ValidateDateParams(HttpServletRequest request, GIISUser USER) throws SQLException, Exception;
	Map<String, Object> extractGIACS480(HttpServletRequest request, GIISUser uSER) throws SQLException, Exception;
	
	String whenNewFormInstanceGIACS329(GIISUser USER) throws SQLException, Exception;
	
	Map<String, Object> getLastExtractParam(String userId) throws SQLException;

	String whenNewFormInstanceGIACS480(GIISUser USER) throws SQLException, Exception;
	
	String checkUserChildRecords (HttpServletRequest request, GIISUser USER) throws SQLException;
	
	String prepareFilterIntmAssd(HttpServletRequest request) throws SQLException, JSONException;	// start SR-4050 : shan 06.19.2015
	
	Integer addToCollection(Map<String, Object> params) throws SQLException;
	
	String getCollElement(Integer index) throws SQLException;
	
	void deleteCollElement(Integer index) throws SQLException;	// end SR-4050 : shan 06.19.2015
}
