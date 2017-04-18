package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface GIACTaxPaymentsDAO {

	Map<String, Object> getGIACS021Variables(Integer gaccTranId) throws SQLException;
	List<Integer> getGIACS021Items(Integer gaccTranId) throws SQLException;
	void saveTaxPayments(Map<String, Object> params) throws SQLException;
	
}