package com.geniisys.gixx.service;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.entity.GIXXMainCoIns;

public interface GIXXMainCoInsService {

	public GIXXMainCoIns getGIXXMainCoInsInfo(Map<String, Object> params) throws SQLException;
}
