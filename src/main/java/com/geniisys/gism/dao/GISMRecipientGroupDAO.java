package com.geniisys.gism.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GISMRecipientGroupDAO {

	void saveGisms003(Map<String, Object> params) throws SQLException;
	void valDeleteRec(String recId) throws SQLException;
	void valAddRec(String recId) throws SQLException;
}
