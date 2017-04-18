package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIACDocSequenceDAO {

	void saveGiacs322(Map<String, Object> params) throws SQLException;
	String valDeleteRec(String recId) throws SQLException;
	String valAddRec(Map<String, Object> params) throws SQLException;
}
