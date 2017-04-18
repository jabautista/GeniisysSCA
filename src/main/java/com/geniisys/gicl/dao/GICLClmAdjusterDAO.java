package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gicl.entity.GICLClmAdjuster;

public interface GICLClmAdjusterDAO{
	
	List<Map<String, Object>> getClmAdjusterListing(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkBeforeDeleteAdj(Map<String, Object> params) throws SQLException;
	Map<String, Object> saveClmAdjuster(Map<String, Object> params) throws SQLException;
	List<GICLClmAdjuster> getLossExpAdjusterList(Integer claimId) throws SQLException;
	List<GICLClmAdjuster> getClmAdjusterList(Integer claimId) throws SQLException;
}
