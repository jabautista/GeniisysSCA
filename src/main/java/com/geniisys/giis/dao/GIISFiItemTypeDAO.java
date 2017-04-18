package com.geniisys.giis.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISFiItemTypeDAO {
	void giiss012ValAddRec(String frItemType) throws SQLException;
	void giiss012ValDelRec(String frItemType) throws SQLException;
	void saveGiiss012(Map<String, Object> params) throws SQLException;
}
