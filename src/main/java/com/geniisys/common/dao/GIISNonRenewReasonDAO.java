package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISNonRenewReasonDAO {
	
	Map<String, Object> validateReasonCd(Map<String, Object> params) throws SQLException;
	void saveGiiss210(Map<String, Object> params) throws SQLException;
	void valDeleteRec(String recId) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;

}
