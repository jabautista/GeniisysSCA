package com.geniisys.gixx.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.entity.GIXXPolbasic;

public interface GIXXPolbasicDAO {
	
	public GIXXPolbasic getPolicySummary(Map<String, Object> params) throws SQLException;
	public GIXXPolbasic getPolicySummarySu(Map<String, Object> params) throws SQLException;
	public GIXXPolbasic getBondPolicyData(Map<String, Object> params) throws SQLException;
}
