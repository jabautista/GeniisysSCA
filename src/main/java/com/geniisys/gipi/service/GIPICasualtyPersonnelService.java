package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.HashMap;

public interface GIPICasualtyPersonnelService {
	
	/**
	 * Retrieves the personnel informations for a given casualty item
	 * @param   policyId,itemNo 
	 * @throws SQLException 
	 * @returns casualty personnel
	 */
	HashMap<String, Object> getCasualtyItemPersonnel(HashMap<String, Object> params) throws SQLException;
}
