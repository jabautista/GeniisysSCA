package com.geniisys.giis.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giis.entity.GIISPayTerm;

public interface GIISPayTermDAO {
	List<GIISPayTerm> getPaymentTerm() throws SQLException;

	String savePayTerm(Map<String, Object> allParams) throws SQLException;

	String validateDeletePaytTerm(String paytTermToDelete) throws SQLException;

	String validateAddPaytTerm(String paytTermToAdd) throws SQLException;

	String validateAddPaytTermDesc(Map<String, Object> valParams)throws SQLException;
}
