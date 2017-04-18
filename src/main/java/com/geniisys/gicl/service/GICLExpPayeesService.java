package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.util.Map;

public interface GICLExpPayeesService {
	
	String checkGiclExpPayeesExist(Map<String, Object> params) throws SQLException;
}
