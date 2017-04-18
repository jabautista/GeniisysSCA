package com.geniisys.gipi.dao;

import java.sql.SQLException;

import com.geniisys.gipi.entity.GIPIWEndtText;

public interface GIPIWEndtTextDAO {
	String getEndtText(int parId) throws SQLException;
	String getEndtTax(Integer parId) throws SQLException, Exception;
	GIPIWEndtText getGIPIWEndttext(Integer parId) throws SQLException;
	String CheckUpdateTaxEndtCancellation() throws SQLException;
}
