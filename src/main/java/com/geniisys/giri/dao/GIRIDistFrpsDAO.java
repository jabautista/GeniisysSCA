package com.geniisys.giri.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.giri.entity.GIRIDistFrps;

public interface GIRIDistFrpsDAO {
	
	List<GIRIDistFrps> getGIRIFrpsList (HashMap<String, Object>params)throws SQLException;
	List<Map<String, Object>> getDistFrpsWDistFrpsV(Map<String, Object> params) throws SQLException;
	
	List<HashMap<String, Object>> getGIRIWFrperils (HashMap<String, Object> params) throws SQLException;
	HashMap<String, Object> getWFrperilSums (HashMap<String, Object> params) throws SQLException;
	Map<String, Object> updateDistFrpsGiuts004(Map<String, Object> params) throws SQLException;
	Map<String, Object> getDistFrpsWDistFrpsV2(Map<String, Object> params) throws SQLException;
}
