package com.geniisys.gixx.service;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.entity.GIXXAviationItem;

public interface GIXXAviationItemService {

	public GIXXAviationItem getGIXXAviationItemInfo(Map<String, Object> params) throws SQLException;
}
