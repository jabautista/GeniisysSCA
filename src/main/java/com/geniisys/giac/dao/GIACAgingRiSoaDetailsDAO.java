package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.giac.entity.GIACAgingRiSoaDetails;

public interface GIACAgingRiSoaDetailsDAO {

	/**
	 * Gets GIAC_AGING_RI_SOA_DETAILS records
	 * @param keyword
	 * @return
	 * @throws SQLException
	 */
	List<GIACAgingRiSoaDetails> getAgingRiSoaDetails(String keyword) throws SQLException;
}
