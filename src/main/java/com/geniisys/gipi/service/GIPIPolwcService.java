package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

public interface GIPIPolwcService {
	
	/**
	 * Returns Warr and Clauses for a given Policy
	 * @param   a HashMap containing table grid parameters and policyId
	 * @returns HashMap with list of warr and clauses
	 * @throws  SQLException   
	 */
	HashMap<String, Object> getRelatedWcInfo(HashMap<String, Object> params) throws SQLException;
	String validateWarrCla(HttpServletRequest request) throws SQLException;
	public void saveGIPIPolWCTableGrid(HttpServletRequest request, String userId) throws Exception; //added by Edison 10.18.2012
	
}
