package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.entity.GIACChartOfAccts;

public interface GIACChartOfAcctsDAO {
	
	List<GIACChartOfAccts> getAccountCodeDtls(Map<String, Object> params) throws SQLException;
	List<GIACChartOfAccts> getAccountCodeDtls2(String keyword) throws SQLException;
	List<GIACChartOfAccts> getAllChartOfAccts() throws SQLException;
	List<GIACChartOfAccts> getAccountCodes(Map<String, Object> params) throws SQLException;
	
	String checkGiacs311UserFunction(String userId) throws SQLException;
	Map<String, Object> getChildChartOfAccts(Map<String, Object> params) throws SQLException;
	String getGlMotherAcct(Map<String, Object> params) throws SQLException;
	String getIncrementedLevel(Map<String, Object> params) throws SQLException;
	void saveGiacs311(Map<String, Object> params) throws SQLException;
	void valUpdateRec(String recId) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;
	void valDelRec(String recId) throws SQLException;
}
