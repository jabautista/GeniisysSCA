package com.geniisys.gixx.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.entity.GIXXAccidentItem;

public interface GIXXAccidentItemDAO {
	
	public GIXXAccidentItem getGIXXAccidentItemInto (Map<String, Object> params) throws SQLException;

}
