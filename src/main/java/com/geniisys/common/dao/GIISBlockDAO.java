package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface GIISBlockDAO {
	List<Map<String, Object>> getDistrictLovGICLS010(Map<String, Object> params) throws SQLException; 
	List<Map<String, Object>> getBlockLovGICLS010(Map<String, Object> params) throws SQLException; 
	void valDeleteRecRisk(Map<String, Object> params) throws SQLException;
	void valAddRecRisk(Map<String, Object> params) throws SQLException;
	void saveRiskDetails(Map<String, Object> params) throws SQLException;
	void valAddRecBlock(Map<String, Object> params) throws SQLException;
	void valDeleteRecBlock(Map<String, Object> params) throws SQLException;
	void saveGiiss007(Map<String, Object> params) throws SQLException;
	void valDeleteRecProvince(Map<String, Object> params) throws SQLException;
	void valDeleteRecCity(Map<String, Object> params) throws SQLException;
	void valDeleteRecDistrict(Map<String, Object> params) throws SQLException;
	void valAddRecDistrict(Map<String, Object> params) throws SQLException;
}
