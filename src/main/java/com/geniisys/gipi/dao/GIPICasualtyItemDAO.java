package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.HashMap;

import com.geniisys.gipi.entity.GIPICasualtyItem;

public interface GIPICasualtyItemDAO {
	
	GIPICasualtyItem getCasualtyItemInfo(HashMap<String,Object> params) throws SQLException;
}
