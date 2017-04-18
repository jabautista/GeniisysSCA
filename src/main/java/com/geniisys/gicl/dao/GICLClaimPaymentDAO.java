package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GICLClaimPaymentDAO {
	String validateEntries (Map<String, Object> params) throws SQLException;
}
