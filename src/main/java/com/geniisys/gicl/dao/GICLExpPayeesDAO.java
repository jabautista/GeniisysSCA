package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GICLExpPayeesDAO {
	
	String checkGiclExpPayeesExist(Map<String, Object> params) throws SQLException;
}
