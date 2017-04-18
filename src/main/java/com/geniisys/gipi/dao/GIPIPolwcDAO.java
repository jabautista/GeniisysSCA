package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIPolwc;

public interface GIPIPolwcDAO {
	
	/**
	 * Returns Warr and Clauses for a given Policy
	 * @param   a HashMap containing table grid parameters and policyId
	 * @returns list of warr and clauses
	 * @throws  SQLException
	 */
	List<GIPIPolwc> getRelatedWcInfo(Map<String, Object> params) throws SQLException;
	String validateWarrCla (Map<String, Object> params) throws SQLException;
	public void saveGIPIPolWCTableGrid(Map<String, Object> parameters) throws SQLException; //added by Edison 10.18.2012
	public void deleteGIPIPolWCTableGrid(Map<String, Object> parameters) throws SQLException; //added by Edison 10.18.2012
	
}
