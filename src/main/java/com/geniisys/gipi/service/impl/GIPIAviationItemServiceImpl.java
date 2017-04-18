package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.HashMap;

import com.geniisys.gipi.dao.GIPIAviationItemDAO;
import com.geniisys.gipi.entity.GIPIAviationItem;
import com.geniisys.gipi.service.GIPIAviationItemService;

public class GIPIAviationItemServiceImpl implements GIPIAviationItemService{

	private GIPIAviationItemDAO gipiAviationItemDAO;

	public GIPIAviationItemDAO getGipiAviationItemDAO() {
		return gipiAviationItemDAO;
	}

	public void setGipiAviationItemDAO(GIPIAviationItemDAO gipiAviationItemDAO) {
		this.gipiAviationItemDAO = gipiAviationItemDAO;
	}

	@Override
	public GIPIAviationItem getAviationItemInfo(HashMap<String, Object> params) throws SQLException {
		return getGipiAviationItemDAO().getAviationItemInfo(params);
	}

	
	
}
