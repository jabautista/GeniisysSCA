package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.HashMap;

import com.geniisys.gipi.dao.GIPIFireItemDAO;
import com.geniisys.gipi.entity.GIPIFireItem;
import com.geniisys.gipi.service.GIPIFireItemService;

public class GIPIFireItemServiceImpl implements GIPIFireItemService{
		
	private GIPIFireItemDAO gipiFireItemDAO;

	public GIPIFireItemDAO getGipiFireItemDAO() {
		return gipiFireItemDAO;
	}

	public void setGipiFireItemDAO(GIPIFireItemDAO gipiFireItemDAO) {
		this.gipiFireItemDAO = gipiFireItemDAO;
	}

	@Override
	public GIPIFireItem getFireitemInfo(HashMap<String, Object> params)throws SQLException {
		return getGipiFireItemDAO().getFireitemInfo(params);
	}
	
	
}
