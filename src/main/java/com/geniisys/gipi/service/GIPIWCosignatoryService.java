package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIWCosignatory;

public interface GIPIWCosignatoryService {
	
	List<GIPIWCosignatory> getGIPIWCosignatory(Integer parId) throws SQLException;
	void deleteGIPIWCosignatory(Integer parId, Integer cosignId) throws SQLException;
	void insertGIPIWCosignatory(Map<String, Object> wCosignatory) throws SQLException;
	void saveGIPIWCosignatoryPageChanges(Map<String, Object> params) throws SQLException;
	
}
