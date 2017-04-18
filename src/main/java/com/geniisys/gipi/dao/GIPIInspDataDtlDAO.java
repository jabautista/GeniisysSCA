package com.geniisys.gipi.dao;

import java.sql.SQLException;

import com.geniisys.gipi.entity.GIPIInspDataDtl;

public interface GIPIInspDataDtlDAO {

	GIPIInspDataDtl getInspDataDtl(Integer inspNo) throws SQLException;
	
}
