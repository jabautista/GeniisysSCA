package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.entity.GIACSlLists;

public interface GIACSlListsDAO {

	/**
	 * Gets the list of GIAC_SL_LISTS records with specified whtax id 
	 * @param whtaxId
	 * @param keyword
	 * @return
	 * @throws SQLException
	 */
	List<GIACSlLists> getSlListingByWhtaxId(Integer whtaxId, String keyword) throws SQLException;
	
	// shan 12.19.2013
	String getSapIntegrationSw() throws SQLException;
	void saveGiacs309(Map<String, Object> params) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;
}
