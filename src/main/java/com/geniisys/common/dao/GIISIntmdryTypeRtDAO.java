package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISIntmdryTypeRtDAO {

	void saveGiiss201(Map<String, Object> params) throws SQLException;
	void valDeleteRec(Map<String, Object> params) throws SQLException;
	
}
