package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.HashMap;

import com.geniisys.gipi.dao.GIPIAccidentItemDAO;
import com.geniisys.gipi.entity.GIPIAccidentItem;
import com.geniisys.gipi.service.GIPIAccidentItemService;

public class GIPIAccidentItemServiceImpl implements GIPIAccidentItemService{
	
	private GIPIAccidentItemDAO gipiAccidentItemDAO;

	public GIPIAccidentItemDAO getGipiAccidentItemDAO() {
		return gipiAccidentItemDAO;
	}

	public void setGipiAccidentItemDAO(GIPIAccidentItemDAO gipiAccidentItemDAO) {
		this.gipiAccidentItemDAO = gipiAccidentItemDAO;
	}

	@Override
	public GIPIAccidentItem getAccidentItemInfo(HashMap<String, Object> params) throws SQLException {
		return getGipiAccidentItemDAO().getAccidentItemInfo(params);

	}
	
	

}
