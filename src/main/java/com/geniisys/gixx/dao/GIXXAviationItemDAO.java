package com.geniisys.gixx.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.entity.GIXXAviationItem;

public interface GIXXAviationItemDAO {

	public GIXXAviationItem getGIXXAviationItemInfo(Map<String, Object> params) throws SQLException;
}
