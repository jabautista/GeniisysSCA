package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.gipi.entity.GIPIInspDataWc;

public interface GIPIInspDataWcDAO {

	List<GIPIInspDataWc> getGipiInspDataWc(Integer inspNo) throws SQLException;
	
}
