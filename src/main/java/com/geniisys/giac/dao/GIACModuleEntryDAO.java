/**
 * 
 */
package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIACModuleEntryDAO {
	void saveGiacs321(Map<String, Object> params) throws SQLException;
	void valDeleteRec(String recId) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;
}
