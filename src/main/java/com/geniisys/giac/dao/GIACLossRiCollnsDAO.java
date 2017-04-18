package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.entity.GIACLossRiCollns;

public interface GIACLossRiCollnsDAO {

	List<Map<String, Object>> getLossAdviceList(HashMap<String, Object> params) throws SQLException;
	List<GIACLossRiCollns> getGIACLossRiCollns(Integer gaccTranId) throws SQLException;
	List<Map<String, Object>> validateFLA(HashMap<String, Object> params) throws SQLException;	//shan 07.24.2013; SR-13688 changed from Map to List to handle FLA with different payee types
	Map<String, Object> validateCurrencyCode(Map<String, Object> params) throws SQLException;
	String saveLossesRecov(Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> getLossAdviceListTableGrid(HashMap<String, Object> params) throws SQLException;
}
