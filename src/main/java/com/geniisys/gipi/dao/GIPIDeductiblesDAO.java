package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import com.geniisys.gipi.entity.GIPIDeductibles;

public interface GIPIDeductiblesDAO {
	/**
	 * Retrieves the list of deductibles of a policy
	 * @param   policyId 
	 * @throws SQLException 
	 * @returns deductibles
	 */
	List<GIPIDeductibles> getDeductibles(HashMap<String,Object> params) throws SQLException;
	
	/**
	 * Retrieves the list of deductibles of a vehicle item
	 * @param   policyId,itemNo 
	 * @returns List of gipiDeductibles
	 * @throws  SQLException
	 */
	List<GIPIDeductibles> getItemDeductibles(HashMap<String,Object> params) throws SQLException;
	

}
