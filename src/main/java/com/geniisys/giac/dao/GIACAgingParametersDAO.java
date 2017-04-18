/**
 * 
 */
package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIACAgingParametersDAO {
	void saveGiacs310(Map<String, Object> params) throws SQLException;
	void copyRecords(Map<String, Object> params) throws SQLException;
}
