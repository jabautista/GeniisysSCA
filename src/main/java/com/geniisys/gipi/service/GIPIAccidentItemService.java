package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.HashMap;

import com.geniisys.gipi.entity.GIPIAccidentItem;

public interface GIPIAccidentItemService {

		GIPIAccidentItem getAccidentItemInfo(HashMap<String,Object> params) throws SQLException;
		
}
