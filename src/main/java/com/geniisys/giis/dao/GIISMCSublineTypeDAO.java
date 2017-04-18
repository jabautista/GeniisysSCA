package com.geniisys.giis.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface GIISMCSublineTypeDAO {
	void giiss056ValAddRec(Map <String, Object> params) throws SQLException;
	void saveGiiss056(Map<String, Object> params) throws SQLException;
	void giiss056ValDelRec(String sublineTypeCd) throws SQLException;
}
