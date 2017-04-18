package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.HashMap;

import com.geniisys.gipi.entity.GIPIAviationItem;

public interface GIPIAviationItemService {

	GIPIAviationItem getAviationItemInfo(HashMap<String, Object> params) throws SQLException;
}
