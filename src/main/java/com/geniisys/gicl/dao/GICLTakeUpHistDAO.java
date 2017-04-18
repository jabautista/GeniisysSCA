package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Date;
import java.util.Map;

public interface GICLTakeUpHistDAO {
	
	Date getMaxAcctDate() throws SQLException;
	Map<String, Object> validateTranDate(Map<String, Object> params) throws SQLException;
	Map<String, Object> bookOsGICLB001(Map<String, Object> params) throws SQLException;
	
}
