package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISObligee;

public interface GIISReportParameterDAO {
	Map<String, Object> saveReportParameter(Map<String, Object> params) throws SQLException;
}
