package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIACReinstatedOrDAO {
	
	String reinstateOr(Map<String, Object> params) throws SQLException;
}
