/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.gipi.entity.GIPIQuotePrincipal;

public interface GIPIQuotePrincipalDAO {

	List<GIPIQuotePrincipal> getPrincipalList(Integer quoteId, String principalType) throws SQLException;
	List<GIPIQuotePrincipal> getPrincipalListForPackQuote (Integer packQuoteId, String principalType) throws SQLException;
}
