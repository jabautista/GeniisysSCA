package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIACEomRepDAO {
	void valAddRec(Map<String, Object> params) throws SQLException;
	void valDeleteRec(Map<String, Object> params) throws SQLException;
	void saveGiacs350(Map<String, Object> params) throws SQLException;
	
	void validateGLAcctNo(Map<String, Object> params) throws SQLException;
	void valAddDtlRec(Map<String, Object> params) throws SQLException;
	void saveGiacs351(Map<String, Object> params) throws SQLException;
}
