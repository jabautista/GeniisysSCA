package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.HashMap;

import com.geniisys.gipi.entity.GIPIFireItem;

public interface GIPIFireItemService {
	GIPIFireItem getFireitemInfo(HashMap<String, Object> params) throws SQLException;
}
