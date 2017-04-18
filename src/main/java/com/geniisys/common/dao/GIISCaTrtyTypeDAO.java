package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISCaTrtyTypeDAO {
	void saveGiiss094(Map<String, Object> params) throws SQLException;
	void valAddRec(Integer recId) throws SQLException;
}
