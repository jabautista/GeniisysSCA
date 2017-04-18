package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;


public interface GIACUserFunctionsDAO {

	/**
	 * Checks if user has specified function cd. Used to check the menu to be disabled in accounting.
	 * @param functionCd
	 * @param moduleName
	 * @param userId
	 * @return
	 * @throws SQLException
	 */
	String checkIfUserHasFunction(String functionCd, String moduleName, String userId) throws SQLException;
	
	String checkOverdueUser(Map<String, Object> params) throws SQLException;
	
	String checkIfUserHasFunction3(Map<String, Object> params) throws SQLException;
	
	//shan 12.16.2013
	String getScrnRepName(Integer moduleId) throws SQLException;
	Integer getUserFunctionsSeq() throws SQLException;
	void saveGiacs315(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkUserFunctionValidity(Map<String, Object> params) throws SQLException;
	/*void valDeleteRec(Map<String, Object> params) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;*/
}
