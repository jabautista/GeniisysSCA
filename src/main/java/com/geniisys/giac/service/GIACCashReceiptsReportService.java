package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

public interface GIACCashReceiptsReportService {

	String getDailyCollectionRecord(HttpServletRequest request, GIISUser USER)throws SQLException, JSONException;
	// GIACS093
	public String validateGIACS093BranchCd(String branchCd, String userId) throws SQLException;
	public JSONObject populateGiacPdc(HttpServletRequest request, String userId) throws SQLException;

	String validateGIACS281BankAcctCd(HttpServletRequest request) throws SQLException;
	Map<String, Object> getLastExtractParam(String userId) throws SQLException; //john 10.9.2014

	
	//GIACS078
	public JSONObject getGIACS078InitialValues(String userId) throws SQLException;
	public String validateIntmNo(Integer intmNo) throws SQLException;
	public String extractGiacs078Records(HttpServletRequest request, String userId) throws SQLException;
	public Integer countGiacs078ExtractedRecords(HttpServletRequest request, String userId) throws SQLException;

}
