package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.util.Date;
import java.util.Map;

public interface GICLTakeUpHistService {
	
	Date getMaxAcctDate() throws SQLException;
	Map<String, Object> validateTranDate(Map<String, Object> params) throws SQLException;
	Map<String, Object> bookOsGICLB001(Map<String, Object> params) throws SQLException;

}
