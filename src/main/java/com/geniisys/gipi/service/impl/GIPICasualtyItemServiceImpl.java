package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.HashMap;

import com.geniisys.gipi.dao.GIPICasualtyItemDAO;
import com.geniisys.gipi.entity.GIPICasualtyItem;
import com.geniisys.gipi.service.GIPICasualtyItemService;

public class GIPICasualtyItemServiceImpl implements GIPICasualtyItemService{

	private GIPICasualtyItemDAO gipiCasualtyItemDAO;

	public GIPICasualtyItemDAO getGipiCasualtyItemDAO() {
		return gipiCasualtyItemDAO;
	}

	public void setGipiCasualtyItemDAO(GIPICasualtyItemDAO gipiCasualtyItemDAO) {
		this.gipiCasualtyItemDAO = gipiCasualtyItemDAO;
	}

	@Override
	public GIPICasualtyItem getCasualtyItemInfo(HashMap<String, Object> params)throws SQLException {

		return getGipiCasualtyItemDAO().getCasualtyItemInfo(params);
		
	}
	
	
}
