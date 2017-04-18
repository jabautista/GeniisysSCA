package com.geniisys.gixx.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.entity.GIXXCasualtyItem;

public interface GIXXCasualtyItemDAO {
	
	public GIXXCasualtyItem getGIXXCasualtyItemInfo(Map<String, Object> params) throws SQLException;

}
