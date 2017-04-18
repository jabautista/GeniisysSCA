package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.gipi.entity.GIPIInspDataWc;

public interface GIPIInspDataWcService {

	List<GIPIInspDataWc> getGipiInspDataWc(Integer inspNo) throws SQLException;
	
}
