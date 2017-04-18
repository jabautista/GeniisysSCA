package com.geniisys.common.service;

import java.sql.SQLException;
import java.util.Map;

public interface GIISEventModUserService {

	String validatePassingUser(Map<String, Object> params) throws SQLException;
	
}
