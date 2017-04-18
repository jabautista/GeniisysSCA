package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.gipi.entity.GIPIErrorLog;

public interface GIPIErrorLogDAO {

	List<GIPIErrorLog> getGipiErrorLog(String filename) throws SQLException;

}
