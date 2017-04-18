package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gicl.entity.GICLReserveDs;

public interface GICLReserveDsDAO {
	
	/**
	 * 
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	public String saveReserveDs(GICLReserveDs giclReserveDs) throws SQLException;
	Map<String, Object> validateXolDeduc(Map<String, Object> params) throws SQLException;
	Map<String, Object> continueXolDeduc(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkXOLAmtLimits(Map<String, Object> params) throws SQLException;
	Map<String, Object> updateShrLossResGICLS024(Map<String, Object> params) throws SQLException;
	Map<String, Object> updateShrPctGICLS024(Map<String, Object> params) throws SQLException;
	Map<String, Object> updateShrExpResGICLS024(Map<String, Object> params) throws SQLException;
}
