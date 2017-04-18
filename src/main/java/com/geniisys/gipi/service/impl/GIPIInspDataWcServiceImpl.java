package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.gipi.dao.GIPIInspDataWcDAO;
import com.geniisys.gipi.entity.GIPIInspDataWc;
import com.geniisys.gipi.service.GIPIInspDataWcService;

public class GIPIInspDataWcServiceImpl implements GIPIInspDataWcService{
	
	private GIPIInspDataWcDAO gipiInspDataWcDAO;

	public GIPIInspDataWcDAO getGipiInspDataWcDAO() {
		return gipiInspDataWcDAO;
	}

	public void setGipiInspDataWcDAO(GIPIInspDataWcDAO gipiInspDataWcDAO) {
		this.gipiInspDataWcDAO = gipiInspDataWcDAO;
	}
	
	public List<GIPIInspDataWc> getGipiInspDataWc(Integer inspNo) throws SQLException {
		return this.getGipiInspDataWcDAO().getGipiInspDataWc(inspNo);
	}
	
}
