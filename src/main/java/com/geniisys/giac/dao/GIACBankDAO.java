package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIACBankDAO {

	void saveGiacs307(Map<String, Object> params) throws SQLException;
	void valDeleteRec(String recId) throws SQLException;
	void valAddRec(String recId) throws SQLException;
}
