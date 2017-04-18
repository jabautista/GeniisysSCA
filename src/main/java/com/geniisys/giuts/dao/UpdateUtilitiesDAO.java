package com.geniisys.giuts.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;
import org.json.JSONObject;


public interface UpdateUtilitiesDAO {

	/* for GIPIS162 - Update Booking Tag */
	Integer getNextBookingYear() throws SQLException;
	Integer checkBookingYear(Integer bookingYear) throws SQLException;
	String generateBookingMonths(Map<String, Object> params) throws SQLException;
	String updateGiisBookingMonths(Map<String, Object> params) throws SQLException;
	String chkBookingMthYear(Map<String, Object> params) throws SQLException;
	List<String> getCurrentWcCdList(Map<String, Object> params) throws SQLException;
	void giuts029NewFormInstance(Map<String, Object> params) throws SQLException;
	void giuts029SaveChanges(Map<String, Object> params) throws SQLException;
	void saveGipis047BondUpdate(Map<String, Object> params) throws SQLException, Exception;
	void updateGIPIS156(Map<String, Object> params) throws SQLException, Exception;
	String validateGIPIS156AreaCd(String areaCd) throws SQLException;
	JSONObject validateGIPIS156BancBranchCd(String areaCd, String branchCd) throws SQLException, JSONException;

	//for update initial general endorsement info
	Map<String, Object> getGeneralInitialInfo(Map<String, Object> params) throws SQLException;
	Map<String, Object> getGeneralInitialPackInfo(Map<String, Object> params) throws SQLException;
	Map<String, Object> getEndtInfo(Map<String, Object> params) throws SQLException;
	String saveGenInfo(Map<String, Object> params) throws SQLException;
	String saveInitialInfo(Map<String, Object> params) throws SQLException;
	String saveGenPackInfo(Map<String, Object> params) throws SQLException;
	String saveInitialPackInfo(Map<String, Object> params) throws SQLException;
	String saveEndtText(Map<String, Object> params) throws SQLException;
	String validatePackage(Integer packPolicyId) throws SQLException;
	
	// SR-21812 JET JUN-27-2016
	Map<String, Object> getPackGeneralInitialInfo(Map<String, Object> params) throws SQLException;
	Map<String, Object> getPackEndtInfo(Map<String, Object> params) throws SQLException;
	String savePackGenInfo(Map<String, Object> params) throws SQLException;
	String savePackInitInfo(Map<String, Object> params) throws SQLException;
	String savePackEndtText(Map<String, Object> params) throws SQLException;
	
	//added by john dolon 9.27.2013
	void saveGipis032MVFileNoUpdate(Map<String, Object> params) throws SQLException, Exception;
	
	// shan 09.30.2013
	List<String> getGipis155BlockId(Map<String, Object> params) throws SQLException;
	String saveFireItems(Map<String, Object> params, String userId) throws SQLException, Exception;
	
	// shan 10.09.2013
	void saveGiuts025(Map<String, Object> params) throws SQLException, Exception;
	void valAddGiuts029(Map<String, Object> params) throws SQLException;
}
