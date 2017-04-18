/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.giac.entity.GIACTaxCollns;

public interface GIACTaxCollnsService {

	List<GIACTaxCollns> getTaxCollnsListing(Integer gaccTranId) throws SQLException;
}
