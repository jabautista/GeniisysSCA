package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.HashMap;

import com.geniisys.gipi.entity.GIPIAccidentItem;

public interface GIPIAccidentItemDAO {
	GIPIAccidentItem getAccidentItemInfo(HashMap<String,Object> params) throws SQLException;
}
