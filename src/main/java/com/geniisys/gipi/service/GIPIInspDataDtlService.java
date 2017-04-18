package com.geniisys.gipi.service;

import java.sql.SQLException;

import com.geniisys.gipi.entity.GIPIInspDataDtl;

public interface GIPIInspDataDtlService {

	GIPIInspDataDtl getInspDataDtl(Integer inspNo) throws SQLException;
	
}
