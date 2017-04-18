package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIACJvTranDAO {

	void saveGiacs323(Map<String, Object> params) throws SQLException;
	void valDeleteRec(String recId) throws SQLException;
	void valAddRec(String recId) throws SQLException;
}
