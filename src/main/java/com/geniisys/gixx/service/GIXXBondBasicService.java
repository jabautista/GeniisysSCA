package com.geniisys.gixx.service;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.entity.GIXXBondBasic;

public interface GIXXBondBasicService {

	public GIXXBondBasic getGIXXBondBasicInfo(Map<String, Object> params) throws SQLException;
}
