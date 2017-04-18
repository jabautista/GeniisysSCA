package com.geniisys.giis.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISBondClassDAO {

	void saveGiiss043(Map<String, Object> params) throws SQLException;
	void giiss043ValAddBondClass(String classNo) throws SQLException;
	void giiss043ValDelBondClass(String classNo) throws SQLException;
	void giiss043ValAddBondClassSubline(Map<String, Object> params) throws SQLException;
	void giiss043ValDelBondClassSubline(Map<String, Object> params) throws SQLException;
	void giiss043ValAddBondClassRt(Map<String, Object> params) throws SQLException;
}
