package com.geniisys.gixx.service.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.dao.GIXXBondBasicDAO;
import com.geniisys.gixx.entity.GIXXBondBasic;
import com.geniisys.gixx.service.GIXXBondBasicService;

public class GIXXBondBasicServiceImpl implements GIXXBondBasicService {

	private GIXXBondBasicDAO gixxBondBasicDAO;

	public GIXXBondBasicDAO getGixxBondBasicDAO() {
		return gixxBondBasicDAO;
	}

	public void setGixxBondBasicDAO(GIXXBondBasicDAO gixxBondBasicDAO) {
		this.gixxBondBasicDAO = gixxBondBasicDAO;
	}
	

	@Override
	public GIXXBondBasic getGIXXBondBasicInfo(Map<String, Object> params) throws SQLException {
		return this.getGixxBondBasicDAO().getGIXXBondBasicInfo(params);
	}
	
}
