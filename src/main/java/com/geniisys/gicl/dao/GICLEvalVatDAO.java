/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.gicl.dao
	File Name: GICLEvalVatDAO.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Apr 12, 2012
	Description: 
*/


package com.geniisys.gicl.dao;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.Map;

public interface GICLEvalVatDAO {
	Map<String, Object>validateEvalCom (Map<String, Object>params)throws SQLException;
	Map<String, Object>validateEvalPartLabor (Map<String, Object>params)throws SQLException;
	Map<String, Object> validateLessDepreciation(Map<String, Object>params)throws SQLException;
	Map<String, Object> validateLessDeductibles(Map<String, Object>params)throws SQLException;
	String checkEnableCreateVat(Integer evalId) throws SQLException;
	void saveVatDetail(Map<String, Object>params) throws SQLException;
	BigDecimal createVatDetails(Map<String, Object>params)  throws SQLException;
	String checkGiclEvalVatExist(Map<String, Object> params) throws SQLException, Exception;
}
