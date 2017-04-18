package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import com.geniisys.gipi.entity.GIPIVesAir;

public interface GIPIVesAirDAO {
	/**
	 * Retrieves the list of cargo informations of a policy
	 * @param   policyId 
	 * @throws SQLException 
	 * @throws SQLException 
	 * @returns list of cargo informations
	 * @throws  SQLException
	 */
	List<GIPIVesAir> getCargoInformations(HashMap<String,Object> params) throws SQLException;
}
