package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISTaxRangeDAO {
	void saveGiiss028TaxRange(Map<String, Object> params) throws SQLException;
}
