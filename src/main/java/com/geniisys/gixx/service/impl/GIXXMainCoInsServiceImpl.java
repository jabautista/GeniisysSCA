package com.geniisys.gixx.service.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.dao.GIXXMainCoInsDAO;
import com.geniisys.gixx.entity.GIXXMainCoIns;
import com.geniisys.gixx.service.GIXXMainCoInsService;

public class GIXXMainCoInsServiceImpl implements GIXXMainCoInsService{

	private GIXXMainCoInsDAO gixxMainCoInsDAO;

	public GIXXMainCoInsDAO getGixxMainCoInsDAO() {
		return gixxMainCoInsDAO;
	}

	public void setGixxMainCoInsDAO(GIXXMainCoInsDAO gixxMainCoInsDAO) {
		this.gixxMainCoInsDAO = gixxMainCoInsDAO;
	}

	@Override
	public GIXXMainCoIns getGIXXMainCoInsInfo(Map<String, Object> params) throws SQLException {
		return this.getGixxMainCoInsDAO().getGIXXMainCoInsInfo(params);
	}
	
}
