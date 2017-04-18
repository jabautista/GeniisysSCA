package com.geniisys.gixx.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.entity.GIXXItemVes;

public interface GIXXItemVesDAO {

	public GIXXItemVes getGIXXItemVesInfo(Map<String, Object> params) throws SQLException;
}
