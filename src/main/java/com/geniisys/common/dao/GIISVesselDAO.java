package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISVesselDAO {

	void saveGiiss049(Map<String, Object> params) throws SQLException;
	String valDeleteRec(String recId) throws SQLException;
	void valAddRec(String recId) throws SQLException;
	Map<String, Object> validateAirTypeCd(Map<String, Object> params) throws SQLException;
	
	void saveGiiss050(Map<String, Object> params) throws SQLException;
	void valDeleteRecGiiss050(String recId) throws SQLException;
	void valAddRecGiiss050(String recId) throws SQLException;
	
	void saveGiiss039(Map<String, Object> params) throws SQLException;
	void valDeleteRecGiiss039(String vesselCd) throws SQLException;
	void valAddRecGiiss039(String vesselCd) throws SQLException;
}
