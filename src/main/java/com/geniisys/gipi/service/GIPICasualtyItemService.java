package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.HashMap;

import com.geniisys.gipi.entity.GIPICasualtyItem;

public interface GIPICasualtyItemService {
	
	GIPICasualtyItem getCasualtyItemInfo(HashMap<String,Object> params) throws SQLException;
	
}
