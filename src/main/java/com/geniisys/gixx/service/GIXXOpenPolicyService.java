package com.geniisys.gixx.service;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.entity.GIXXOpenPolicy;

public interface GIXXOpenPolicyService {

	public GIXXOpenPolicy getGIXXOpenPolicy(Map<String, Object> params) throws SQLException;
}
