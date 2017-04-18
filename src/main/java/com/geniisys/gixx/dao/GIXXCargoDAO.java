package com.geniisys.gixx.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.entity.GIXXCargo;

public interface GIXXCargoDAO {

	public GIXXCargo getGIXXCargoInfo(Map<String, Object> params) throws SQLException;
}
