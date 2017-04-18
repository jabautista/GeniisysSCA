package com.geniisys.gixx.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.entity.GIXXBondBasic;

public interface GIXXBondBasicDAO {

	public GIXXBondBasic getGIXXBondBasicInfo(Map<String, Object> params) throws SQLException;
}
