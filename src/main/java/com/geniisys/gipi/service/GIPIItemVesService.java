package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.HashMap;

import com.geniisys.gipi.entity.GIPIItemVes;

public interface GIPIItemVesService {
	
	HashMap<String, Object> getMarineHulls(HashMap<String, Object> params) throws SQLException;
	
	GIPIItemVes getItemVesInfo(HashMap<String, Object> params) throws SQLException;
	
}
