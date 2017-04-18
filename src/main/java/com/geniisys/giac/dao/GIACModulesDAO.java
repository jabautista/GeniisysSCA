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

/**
 * The Interface GIACModulesDAO.
 */
public interface GIACModulesDAO {
	
	/**
	 * Validates user module function.
	 * @param userid, moduleaccess, modulename
	 * @return String
	 * @throws SQLException the sQL exception
	 */
	String validateUserFunc(Map<String, Object> param) throws SQLException;
	String validateUserFunc2(Map<String, Object> params) throws SQLException;
	String validateUserFunc3(Map<String, Object> params) throws SQLException;
	void saveGiacs317(Map<String, Object> params) throws SQLException;
	String valDeleteRec(Integer moduleId) throws SQLException;
	void valAddRec(Map<String, Object> param) throws SQLException;
	Map<String, Object> validateGiacs317ScreenRepTag(Map<String, Object> params) throws SQLException;

}
