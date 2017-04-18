package com.geniisys.gixx.service;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.entity.GIXXCasualtyItem;

public interface GIXXCasualtyItemService {
	
	public GIXXCasualtyItem getGIXXCasualtyItemInfo(Map<String, Object> params) throws SQLException;

}
