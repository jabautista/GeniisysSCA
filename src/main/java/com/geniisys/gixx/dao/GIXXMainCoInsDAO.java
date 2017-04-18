package com.geniisys.gixx.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.entity.GIXXMainCoIns;

public interface GIXXMainCoInsDAO {

	public GIXXMainCoIns getGIXXMainCoInsInfo(Map<String, Object> params) throws SQLException;
}
