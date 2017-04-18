package com.geniisys.gixx.service;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.entity.GIXXFireItem;

public interface GIXXFireItemService {

	public GIXXFireItem getGIXXFireItemInfo(Map<String, Object> params) throws SQLException;
}
