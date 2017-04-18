package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.HashMap;

import com.geniisys.gipi.entity.GIPIAviationItem;

public interface GIPIAviationItemDAO {
	
	GIPIAviationItem getAviationItemInfo(HashMap<String,Object> params) throws SQLException;
}
