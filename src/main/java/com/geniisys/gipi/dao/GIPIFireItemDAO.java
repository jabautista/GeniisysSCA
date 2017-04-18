package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.HashMap;

import com.geniisys.gipi.entity.GIPIFireItem;

public interface GIPIFireItemDAO {
	
	GIPIFireItem getFireitemInfo(HashMap<String,Object> params) throws SQLException;
	
}
