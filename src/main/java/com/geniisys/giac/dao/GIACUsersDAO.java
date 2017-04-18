/**
 * 
 */
package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;

/**
 * @author steven
 *
 */
public interface GIACUsersDAO {
	void saveGiacs313(Map<String, Object> params) throws SQLException;
	void valDeleteRec(String recId) throws SQLException;
	void valAddRec(String recId) throws SQLException;
}
