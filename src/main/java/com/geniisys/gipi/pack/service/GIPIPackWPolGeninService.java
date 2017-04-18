package com.geniisys.gipi.pack.service;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gipi.pack.entity.GIPIPackWPolGenin;

public interface GIPIPackWPolGeninService {
	
	/**
	 * Gets record details from GIPIPackWPolGenin with the given pack_par_id.
	 * 
	 * @param packParId - the packParId
	 * @return GIPIPackWPolGenin
	 * @throws SQLException the SQL exception
	 */
	GIPIPackWPolGenin getGipiPackWPolGenin (Integer packParId) throws SQLException;
	void copyPackWPolGeninGiuts008a(Map<String, Object> params) throws SQLException;
	
}
