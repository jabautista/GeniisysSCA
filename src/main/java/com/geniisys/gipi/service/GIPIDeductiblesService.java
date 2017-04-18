package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.HashMap;

public interface GIPIDeductiblesService {
	/**
	 * Retrieves the list of deductibles of a policy
	 * @param   policyId 
	 * @returns deductibles
	 * @throws  SQLException
	 */
	HashMap<String, Object> getDeductibles(HashMap<String, Object> params) throws SQLException;
	
	/**
	 * Retrieves the list of deductibles of a policy
	 * @param   HashMap with policyId,itemNumber 
	 * @returns table grid Hashmap with list of deductibles inside
	 * @throws  SQLException
	 */
	HashMap<String, Object> getItemDeductibles(HashMap<String, Object> params) throws SQLException;
	

}
