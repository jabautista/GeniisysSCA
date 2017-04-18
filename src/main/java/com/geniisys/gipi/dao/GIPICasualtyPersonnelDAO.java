package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import com.geniisys.gipi.entity.GIPICasualtyPersonnel;

public interface GIPICasualtyPersonnelDAO {
	/**
	 * Retrieves the personnel informations for a given casualty item
	 * @param   policyId,itemNo 
	 * @throws SQLException 
	 * @returns casualty personnel
	 */
	List<GIPICasualtyPersonnel> getCasualtyItemPersonnel(HashMap<String,Object> params) throws SQLException;
}
