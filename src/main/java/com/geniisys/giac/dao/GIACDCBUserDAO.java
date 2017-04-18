/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.giac.entity.GIACDCBUser;

public interface GIACDCBUserDAO {

	GIACDCBUser getDCBCashierCd(String fundCd, String branchCd, String userId) throws SQLException; 

	GIACDCBUser getValidUSerInfo(String fundCd, String branchCd, String userId) throws SQLException;
	
	String checkIfDcbUserExists(String userId) throws SQLException;
	
	//shan 12.09.2013
	void saveGiacs319(Map<String, Object> params) throws SQLException;
	void valDeleteRec(Map<String, Object> params) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;
}
