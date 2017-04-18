package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import com.geniisys.gipi.entity.GIPIItmPerilGrouped;

public interface GIPIItmPerilGroupedDAO {
	
	List<GIPIItmPerilGrouped> getItmPerilGroupedList(HashMap<String,Object> params) throws SQLException;
	List<GIPIItmPerilGrouped> getPolItmPerils(Integer parId) throws SQLException;
}
