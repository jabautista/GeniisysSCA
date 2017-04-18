package com.geniisys.gipi.service;

import java.sql.SQLException;

import com.geniisys.gipi.entity.GIPIWEndtText;

public interface GIPIWEndtTextService {
	String getEndtText(int parId) throws SQLException;
	GIPIWEndtText getGIPIWEndttext(Integer parId) throws SQLException;
	String CheckUpdateTaxEndtCancellation() throws SQLException;
}
