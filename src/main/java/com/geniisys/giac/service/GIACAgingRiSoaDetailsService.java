package com.geniisys.giac.service;

import java.sql.SQLException;

import com.geniisys.framework.util.PaginatedList;

public interface GIACAgingRiSoaDetailsService {

	/**
	 * Gets GIAC_AGING_RI_SOA_DETAILS records
	 * @param keyword
	 * @return
	 * @throws SQLException
	 */
	PaginatedList getAgingRiSoaDetails(String keyword) throws SQLException;
}
