package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GICLReportDocumentDAO {

	void saveGICLS180(Map<String, Object> params) throws SQLException;
	void valDeleteRec(String reportId) throws SQLException;
}
