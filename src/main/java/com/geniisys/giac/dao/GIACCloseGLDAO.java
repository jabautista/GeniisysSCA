package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIACCloseGLDAO {

	String getCloseGLParams(String paramId) throws SQLException;

	Map<String, Object> getModuleId()throws SQLException;

	Map<String, Object> closeGenLedger(Map<String, Object> params) throws SQLException, Exception;

	Map<String, Object> closeGenLedgerConfirmation(Map<String, Object> params) throws SQLException, Exception;
}
