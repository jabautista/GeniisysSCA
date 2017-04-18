package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISTariffZoneDAO {
	void valAddRec(String recId) throws SQLException;
	void valDeleteRec(String recId) throws SQLException;
	void saveGiiss054(Map<String, Object> params) throws SQLException;
	Integer checkGiiss054UserAccess(String userId) throws SQLException;
}
