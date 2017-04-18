package com.geniisys.giuts.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;


public interface UpdateUtilitiesService {

	/* for GIPIS162 - Update Booking Tag */
	Integer getNextBookingYear() throws SQLException;
	Integer checkBookingYear(Integer bookingYear) throws SQLException;
	String generateBookingMonths(Map<String, Object> params) throws SQLException;
	String updateGiisBookingMonth(Map<String, Object> params) throws SQLException;
	String chkBookingMthYear(Map<String, Object> params) throws SQLException;
	List<String> getCurrentWcCdList(Map<String, Object> params) throws SQLException;
	JSONObject getGIUTS029ItemList(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject giuts029NewFormInstance() throws SQLException, JSONException;
	JSONObject getGiuts029AttachmentList(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void giuts029SaveChanges(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject getGiuts027PolicyItemList(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void saveGipis047BondUpdate(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, Exception;
	JSONObject getGIPIS156History(HttpServletRequest request) throws SQLException, JSONException, ParseException;
	JSONObject getGIPIS156BancaHistory(HttpServletRequest request) throws SQLException, JSONException, ParseException;
	void updateGIPIS156(HttpServletRequest request, GIISUser USER) throws SQLException, Exception;
	String validateGIPIS156AreaCd(HttpServletRequest request) throws SQLException;
	JSONObject validateGIPIS156BancBranchCd(HttpServletRequest request) throws SQLException, JSONException, ParseException;
	
	//for update initial general endorsement info
	Map<String, Object> getGeneralInitialInfo (HttpServletRequest request) throws SQLException, JSONException, ParseException;
	Map<String, Object> getGeneralInitialPackInfo (HttpServletRequest request) throws SQLException, JSONException, ParseException;
	Map<String, Object> getEndtInfo (HttpServletRequest request) throws SQLException, JSONException, ParseException;
	String saveGenInfo (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	String saveInitialInfo (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	String saveGenPackInfo (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	String saveInitialPackInfo (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	String saveEndtText (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	String validatePackage (HttpServletRequest request) throws SQLException;
	
	// SR-21812 JET JUN-27-2016
	Map<String, Object> getPackGeneralInitialInfo (HttpServletRequest request) throws SQLException, JSONException, ParseException;
	Map<String, Object> getPackEndtInfo (HttpServletRequest request) throws SQLException, JSONException, ParseException;
	String savePackGenInfo (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	String savePackInitInfo (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	String savePackEndtText (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	
	//added by john dolon 9.27.2013
	JSONObject showUpdateMVFileNo(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	void saveGipis032MVFileNoUpdate(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, Exception;
	
	//shan 09.30.2013
	List<String> getGipis155BlockId(HttpServletRequest request) throws SQLException;
	String saveFireItems(HttpServletRequest request, String userId) throws SQLException, Exception;
	
	//shan 10.08.2013
	JSONObject getInvoiceListGiuts025(HttpServletRequest request) throws SQLException, JSONException;
	void saveGiuts025(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, Exception; //added user by robert SR 5165 11.05.15
	void valAddGiuts029(HttpServletRequest request) throws SQLException;
}
