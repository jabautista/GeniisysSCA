package com.geniisys.gixx.service;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.entity.GIXXItemVes;

public interface GIXXItemVesService {

	public GIXXItemVes getGIXXItemVesInfo(Map<String, Object> params) throws SQLException;
	
}
