package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import com.geniisys.gipi.entity.GIPIItemVes;

public interface GIPIItemVesDAO {

	List<GIPIItemVes> getMarineHulls(HashMap<String,Object> params) throws SQLException;
	
	GIPIItemVes getItemVesInfo(HashMap<String,Object> params) throws SQLException;
	
}
