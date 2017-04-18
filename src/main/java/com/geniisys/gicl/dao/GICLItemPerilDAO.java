package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gicl.entity.GICLItemPeril;

public interface GICLItemPerilDAO {
	
	List<GICLItemPeril> getGiclItemPerilGrid(Map<String, Object> params) throws SQLException;
	void setGiclItemPeril(Map<String, Object> params) throws SQLException;
	void delGiclItemPeril(Map<String, Object> params) throws SQLException;
	List<GICLItemPeril> getGiclItemPerilGrid2(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkAggPeril (Map<String, Object> params) throws SQLException;
	String getGiclItemPerilDfltPayee(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkPerilStatus(Map<String, Object> params) throws SQLException;
	GICLItemPeril getGICLS024ItemPeril(Integer claimId) throws SQLException;
	Integer checkIfGroupGICLS024(Integer claimId) throws SQLException;
}
