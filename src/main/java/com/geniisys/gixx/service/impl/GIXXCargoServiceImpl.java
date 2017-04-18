package com.geniisys.gixx.service.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.dao.GIXXCargoDAO;
import com.geniisys.gixx.entity.GIXXCargo;
import com.geniisys.gixx.service.GIXXCargoService;

public class GIXXCargoServiceImpl implements GIXXCargoService{

	private GIXXCargoDAO gixxCargoDAO;

	public GIXXCargoDAO getGixxCargoDAO() {
		return gixxCargoDAO;
	}

	public void setGixxCargoDAO(GIXXCargoDAO gixxCargoDAO) {
		this.gixxCargoDAO = gixxCargoDAO;
	}

	
	@Override
	public GIXXCargo getGIXXCargoInfo(Map<String, Object> params) throws SQLException {
		return this.getGixxCargoDAO().getGIXXCargoInfo(params);
	}
	
}
