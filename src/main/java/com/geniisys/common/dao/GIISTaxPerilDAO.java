/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISTaxPeril;

public interface GIISTaxPerilDAO {
	
	/**
	 * Retrieve the list of invoice tax codes and their required perils 
	 * @param issCd
	 * @param lineCd
	 * @return list of GIISTaxPerils of :issCd and :lineCd
	 * @throws SQLException
	 */
	List<GIISTaxPeril> getRequiredTaxPerils(String issCd, String lineCd) throws SQLException;
	void saveGiiss028TaxPeril(Map<String, Object> params) throws SQLException;
	
}