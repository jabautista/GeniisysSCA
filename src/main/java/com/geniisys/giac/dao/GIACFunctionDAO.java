package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIACFunctionDAO {

	String getFunctionName(Map<String, Object> params) throws SQLException;
	void saveGiacs314(Map<String, Object> params) throws SQLException;
	String valDeleteRec(Map<String, Object> params) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateGiacs314Module(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateGiacs314Table(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateGiacs314Column(Map<String, Object> params) throws SQLException;
	void saveFunctionColumn(Map<String, Object> params) throws SQLException;
	void valAddFunctionColumn(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateGiacs314Display(Map<String, Object> params) throws SQLException;
	void saveColumnDisplay(Map<String, Object> params) throws SQLException;
	void valAddColumnDisplay(Map<String, Object> params) throws SQLException;
	String checkFuncExists (Map<String, Object> params) throws SQLException; //Added by Jerome Bautista 05.28.2015 SR 4225
}
