package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.Map;

public interface GIACReinstatedOrService {

	String reinstateOr(Map<String, Object> params) throws SQLException;
}
