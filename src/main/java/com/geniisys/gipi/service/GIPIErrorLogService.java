package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.gipi.entity.GIPIErrorLog;

public interface GIPIErrorLogService {

	List<GIPIErrorLog> getGipiErrorLog(String filename) throws SQLException;
}
