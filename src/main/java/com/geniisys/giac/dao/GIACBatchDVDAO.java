/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.giac.dao
	File Name: GIACBatchDVDAO.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Dec 8, 2011
	Description: 
*/


package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.entity.GIACBatchDV;

public interface GIACBatchDVDAO{
	List<GIACBatchDV> getSpecialCSRListing(Map<String, Object> params) throws SQLException; 
	void cancelGIACBatch(Map<String, Object>params) throws SQLException;
	Map<String, Object>getGIACS086AcctEntPostQuery(Map<String, Object>params)throws SQLException;
	Map<String, Object> getGIACS087AcctEntTotals(Map<String, Object>params)throws SQLException;	
}
