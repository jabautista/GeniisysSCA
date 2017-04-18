package com.geniisys.gipi.service.impl;

import java.sql.SQLException;

import com.geniisys.gipi.dao.GIPIInspDataDtlDAO;
import com.geniisys.gipi.entity.GIPIInspDataDtl;
import com.geniisys.gipi.service.GIPIInspDataDtlService;

public class GIPIInspDataDtlServiceImpl implements GIPIInspDataDtlService{
	
	private GIPIInspDataDtlDAO gipiInspDataDtlDAO;

	public GIPIInspDataDtlDAO getGipiInspDataDtlDAO() {
		return gipiInspDataDtlDAO;
	}

	public void setGipiInspDataDtlDAO(GIPIInspDataDtlDAO gipiInspDataDtlDAO) {
		this.gipiInspDataDtlDAO = gipiInspDataDtlDAO;
	}

	public GIPIInspDataDtl getInspDataDtl(Integer inspNo)
		throws SQLException {
		return this.getGipiInspDataDtlDAO().getInspDataDtl(inspNo);
	}
	
}
