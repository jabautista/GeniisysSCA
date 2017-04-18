package com.geniisys.gixx.service;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.entity.GIXXCargo;

public interface GIXXCargoService {

	public GIXXCargo getGIXXCargoInfo(Map<String, Object> params) throws SQLException;
}
