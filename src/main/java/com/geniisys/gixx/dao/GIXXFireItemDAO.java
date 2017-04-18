package com.geniisys.gixx.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.entity.GIXXFireItem;

public interface GIXXFireItemDAO {

	public GIXXFireItem getGIXXFireItemInfo(Map<String, Object> params) throws SQLException;
}
