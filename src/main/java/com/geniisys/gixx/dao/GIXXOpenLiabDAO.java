package com.geniisys.gixx.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.entity.GIXXOpenLiab;

public interface GIXXOpenLiabDAO {

	public GIXXOpenLiab getGIXXOpenLianInfo(Map<String, Object> params) throws SQLException;
}
