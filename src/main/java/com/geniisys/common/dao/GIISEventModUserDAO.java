package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISEventModUserDAO {

	String validatePassingUser(Map<String, Object> params) throws SQLException;
	
}
