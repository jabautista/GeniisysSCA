package com.geniisys.gixx.service;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.entity.GIXXOpenLiab;

public interface GIXXOpenLiabService {

	public GIXXOpenLiab getGIXXOpenLiabInfo(Map<String, Object> params) throws SQLException;

}
