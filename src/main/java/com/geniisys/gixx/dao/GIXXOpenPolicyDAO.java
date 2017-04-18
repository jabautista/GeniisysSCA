package com.geniisys.gixx.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.entity.GIXXOpenPolicy;

public interface GIXXOpenPolicyDAO {

	public GIXXOpenPolicy getGIXXOpenPolicy(Map<String, Object> params) throws SQLException;
}
