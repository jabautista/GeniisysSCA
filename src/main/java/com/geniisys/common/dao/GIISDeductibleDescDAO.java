package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISDeductibleDescDAO {

	void saveGiiss010(Map<String, Object> params) throws SQLException;
	void valDeleteRec(Map<String, Object> params) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;
	Map<String, Object> getAllTDedType (Map<String, Object> params) throws SQLException;	//Gzelle 08272015 SR4851
}
