package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.framework.util.PaginatedList;
import com.geniisys.giac.entity.GIACAcctEntries;
import com.geniisys.giac.entity.GIACChartOfAccts;


public interface GIACAcctEntriesService {
	
	//List<GIACAcctEntries> getAcctEntries(int gaccTranId) throws SQLException;
	List<GIACAcctEntries> getAcctEntries(Map<String, Object> params) throws SQLException;
	PaginatedList getGlAcctListing(String acctObj, int pageNo, String keyWord) throws SQLException, JSONException;
	void saveGIACAcctEntries(String param, int gaccTranId, String userId) throws SQLException, JSONException;
	void deleteGIACAcctEntries(String param) throws SQLException, JSONException;
	Map<String, Object> closeTransaction(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkManualAcctEntry(Map<String, Object> params) throws SQLException;
	Map<String, Object> getGIACS086AcctEntriesTableGrid(HttpServletRequest request, String userId)throws SQLException, JSONException;
	GIACChartOfAccts retrieveGLAccount(String strParam) throws SQLException, JSONException;
	String checkGIACS060GLTrans(HttpServletRequest request) throws SQLException;
}
