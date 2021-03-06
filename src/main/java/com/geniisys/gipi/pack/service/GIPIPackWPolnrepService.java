package com.geniisys.gipi.pack.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.pack.entity.GIPIPackWPolnrep;

public interface GIPIPackWPolnrepService {
	
	/**
	 *  Gets the list of gipiPackWPolnrep
	 *  @param packParId - the packParId
	 *  @return List of gipiPackWPolnrep
	 *  @throws SQLException the SQL exception 
	 */
	
	List<GIPIPackWPolnrep> getGipiPackPolnrep (Integer packParId) throws SQLException;
	
	/**
	 * Checks if record/s exist in GIPI_PACK_WPOLNREP.
	 * @param packParId - packParId value
	 * @return Map
	 * @throws SQLException - the SQL Exception 
	 */
	 
	Map<String, String>  isGipiPackWPolnrepExist (Integer packParId) throws SQLException;
	
	/**
	 * Checks policy for renewal or replacement.
	 * @param gipiPackWPolnrep - the gipiPackWPolnrep 
	 * @param polFlag - the pol flag
	 * @return String - the message  
	 * @throws SQLException 
	 * @throws SQLException the SQL Exception
	 */
	String checkPackPolicyForRenewal(GIPIPackWPolnrep gipiPackWPolnrep, String polFlag) throws SQLException;

}
