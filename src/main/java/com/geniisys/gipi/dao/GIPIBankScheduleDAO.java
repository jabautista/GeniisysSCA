package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import com.geniisys.gipi.entity.GIPIBankSchedule;

public interface GIPIBankScheduleDAO {

	/**
	 * Retrieves the list of bank collection of a policy
	 * @param   policyId 
	 * @throws SQLException 
	 * @returns list of bank collection
	 * @throws  SQLException
	 */
	List<GIPIBankSchedule> getBankCollections(HashMap<String,Object> params) throws SQLException;
	
}
