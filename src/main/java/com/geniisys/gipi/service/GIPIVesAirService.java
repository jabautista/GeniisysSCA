package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.HashMap;

public interface GIPIVesAirService {
	/**
	 * Retrieves the list of cargo informations of a policy
	 * @param   policyId 
	 * @throws SQLException 
	 * @throws SQLException 
	 * @throws SQLException 
	 * @returns list of cargo informations
	 * @throws  SQLException
	 */
	HashMap<String, Object> getCargoInformations(HashMap<String, Object> params) throws SQLException;
}
