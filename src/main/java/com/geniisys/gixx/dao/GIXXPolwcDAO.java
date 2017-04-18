package com.geniisys.gixx.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gixx.entity.GIXXPolwc;

public interface GIXXPolwcDAO {

	public List<GIXXPolwc> getGIXXRelatedWcInfo(Map<String, Object> params) throws SQLException;
}
