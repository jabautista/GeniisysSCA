package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;


public interface GIACPdcChecksDAO {
	Map<String, Object> checkDateForDeposit(Map<String, Object> params) throws SQLException;
	void saveForDeposit(Map<String, Object> params) throws SQLException;
	void saveReplacePDC(Map<String, Object> params) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;
	void saveGiacs031(Map<String, Object> params) throws SQLException;
	Map<String, Object> applyPDC(Map<String, Object> params) throws SQLException;
}
