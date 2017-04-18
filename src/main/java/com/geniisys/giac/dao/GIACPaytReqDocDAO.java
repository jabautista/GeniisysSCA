package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIACPaytReqDocDAO {

	void saveGiacs306(Map<String, Object> params) throws SQLException;
	void valDeleteRec(Map<String, Object> params) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;
}
