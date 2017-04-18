package com.geniisys.gixx.service;

import java.sql.SQLException;
import java.util.Map;

public interface GIXXPolwcService {
	
	public Map<String, Object> getGIXXRelatedWcInfo(Map<String, Object> params) throws SQLException;
}
