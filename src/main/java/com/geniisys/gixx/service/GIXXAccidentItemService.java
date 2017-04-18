package com.geniisys.gixx.service;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.entity.GIXXAccidentItem;

public interface GIXXAccidentItemService {
	
	public GIXXAccidentItem getGIXXAccidentItem(Map<String, Object> params) throws SQLException;

}
