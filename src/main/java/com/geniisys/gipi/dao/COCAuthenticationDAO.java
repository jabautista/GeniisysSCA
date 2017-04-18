package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.Map;

public interface COCAuthenticationDAO {

	Boolean registerCOCs(Map<String, Object> params) throws SQLException, Exception;
	
}
