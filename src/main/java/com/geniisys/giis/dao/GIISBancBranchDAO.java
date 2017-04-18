package com.geniisys.giis.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISBancBranchDAO {

	void saveGiiss216(Map<String, Object> params) throws SQLException;
	void valAddRecGiiss216(Map<String, Object> params) throws SQLException;
}
