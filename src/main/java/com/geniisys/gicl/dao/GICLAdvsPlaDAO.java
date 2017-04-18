package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gicl.entity.GICLAdvsPla;

public interface GICLAdvsPlaDAO {

	String cancelPLA(Map<String, Object> params) throws SQLException;
	String generatePLA(Map<String, Object> params) throws SQLException;
	void updatePrintSwPla(Map<String, Object> params) throws SQLException;
	void updatePrintSwPla2(Map<String, Object> params) throws SQLException;
	String savePreliminaryLossAdv(Map<String, Object> params) throws SQLException;
	List<GICLAdvsPla> getAllPlaDetails(Map<String, Object> params) throws SQLException;
	
}
