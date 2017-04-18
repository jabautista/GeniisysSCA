package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISUserGrpHist;

public interface GIISUserGrpHistDAO {

	List<GIISUserGrpHist> getUserHistory(Map<String, Object> params) throws SQLException;
}
