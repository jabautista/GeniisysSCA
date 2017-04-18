package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.HashMap;

import com.geniisys.gipi.entity.GIPICargo;

public interface GIPICargoDAO {
	
	GIPICargo getCargoInfo(HashMap<String,Object> params) throws SQLException;
	
}
