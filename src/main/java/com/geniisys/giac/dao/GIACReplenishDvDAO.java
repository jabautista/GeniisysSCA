/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.giac.dao
	File Name: GIACReplenishDvDAO.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Nov 8, 2012
	Description: 
*/


package com.geniisys.giac.dao;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.Map;

public interface GIACReplenishDvDAO {
	Map<String, Object> getRfDetailAmounts(Map<String, Object> params)throws SQLException;
	void saveRfDetail(Map<String, Object> params)throws SQLException;
	Map<String, Object> getGIACS016AcctEntPostQuery(Map<String, Object>params) throws SQLException;
	void saveReplenishmentMasterRecord(Map<String, Object> params) throws SQLException;
	void saveReplenishment(Map<String, Object> params)throws SQLException;
	Map<String, Object> getCurrReplenishmentId (Map<String, Object> params) throws SQLException;
	String checkReplenishmentPaytReq(Map<String, Object> params) throws SQLException;	// shan 10.09.2014
	BigDecimal getRevolvingFund(Map<String, Object> params) throws SQLException; // shan 10.10.2014
}
