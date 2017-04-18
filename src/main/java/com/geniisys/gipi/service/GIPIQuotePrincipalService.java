package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.gipi.entity.GIPIQuotePrincipal;

public interface GIPIQuotePrincipalService {

	List<GIPIQuotePrincipal> getPrincipalList(Integer quoteId, String principalType) throws SQLException;
	List<GIPIQuotePrincipal> getPrincipalListForPackQuote (Integer packQuoteId, String principalType) throws SQLException;
}
