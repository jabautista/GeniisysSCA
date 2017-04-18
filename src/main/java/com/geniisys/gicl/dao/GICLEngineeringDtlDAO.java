package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GICLEngineeringDtlDAO {

	/**
	 * Loads all required items and records for Engineering Item Info page
	 * @param params
	 * @throws SQLException
	 */
	void loadEngineeringItemInfoItems(Map<String, Object> params) throws SQLException;
	
	/**
	 * Save Engineering Claim Item Info
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	Map<String, Object> saveClmItemEngineering(Map<String, Object> params) throws SQLException;
	
	/**
	 * Validate item no
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	Map<String, Object> validateClmItemNo(Map<String, Object> params) throws SQLException;
}
