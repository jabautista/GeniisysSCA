package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIACPaytRequestsDtlDAO {

	Object getGiacPaytRequestsDtl(Map<String, Object> params) throws SQLException;

}
