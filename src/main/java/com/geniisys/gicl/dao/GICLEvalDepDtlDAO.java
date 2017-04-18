/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.gicl.dao
	File Name: GICLEvalDepDtlDAO.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Apr 10, 2012
	Description: 
*/


package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GICLEvalDepDtlDAO {
	Map<String, Object> getDepPayeeDtls(Integer evalId)throws SQLException;
	Map<String, Object>checkDepVat(Map<String, Object>params)throws SQLException;
	void saveRepairDet(Map<String, Object>params)throws SQLException;
	String applyDepreciation(Map<String, Object>params) throws SQLException;
	
}
