package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.entity.GIACAcctEntries;
import com.geniisys.giac.entity.GIACChartOfAccts;

public interface GIACAcctEntriesDAO {
	
	//List<GIACAcctEntries> getAcctEntries(int gaccTranId) throws SQLException;
	List<GIACAcctEntries> getAcctEntries(Map<String, Object> params) throws SQLException;
	List<GIACChartOfAccts> getGlAcctsListing(Map<String, Object> acctEntry) throws SQLException;
	List<GIACChartOfAccts> getAllChartOfAccts() throws SQLException;
	void saveAcctEntries(Map<String, Object> params) throws SQLException;
	void delAcctEntries(Map<String, Object> params) throws SQLException;
	Map<String, Object> closeTransaction(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkManualAcctEntry(Map<String, Object> params) throws SQLException;
	String checkGIACS060GLTrans (Map<String, Object> params) throws SQLException;
	
}
