package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIInspData;

public interface GIPIInspDataDAO {

	List<GIPIInspData> getGipiInspData1(String keyword) throws SQLException;
	List<GIPIInspData> getInspDataItemInfo(Integer inspNo) throws SQLException;
	void saveGipiInspData(Map<String, Object> inspDataMap, String user) throws Exception;
	String getBlockId(Map<String, Object> params) throws SQLException;
	Integer generateInspNo() throws SQLException;
	GIPIInspData getInspOtherDtls(Map<String, Object> otherParams) throws SQLException;
	/*List<GIPIInspData> getGipiInspData1TableGrid(Map<String, Object> params) throws SQLException;*/ //remove by steven 9.20.2013
	List<GIPIInspData> getQuoteInpsList(Map<String, Object>params) throws SQLException;
	void saveInspectionAttachments(Map<String, Object>params,String userId) throws SQLException, JSONException;
	String saveInspectionToPAR(Map<String, Object> params) throws SQLException, Exception;
	void saveWarrAndClauses(Map<String, Object> inspDataMap, String user) throws Exception;
	void saveInspectionInformation(Map<String, Object> params, String user) throws Exception;  //added by john 3.21.2016 SR#5470
	List<Map<String, Object>> getAttachments(Map<String, Object> params) throws SQLException;
	
	List<Map<String, Object>> getAttachmentByPar(String parId) throws SQLException;
	void updateFileName3(Map<String, Object> params) throws SQLException;
}
