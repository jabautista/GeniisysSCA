package com.geniisys.gixx.service.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.dao.GIXXAccidentItemDAO;
import com.geniisys.gixx.entity.GIXXAccidentItem;
import com.geniisys.gixx.service.GIXXAccidentItemService;

public class GIXXAccidentItemServiceImpl implements GIXXAccidentItemService{

	private GIXXAccidentItemDAO gixxAccidentItemDAO;
	
	
	public GIXXAccidentItemDAO getGixxAccidentItemDAO() {
		return gixxAccidentItemDAO;
	}

	public void setGixxAccidentItemDAO(GIXXAccidentItemDAO gixxAccidentItemDAO) {
		this.gixxAccidentItemDAO = gixxAccidentItemDAO;
	}


	@Override
	public GIXXAccidentItem getGIXXAccidentItem(Map<String, Object> params) throws SQLException {
		return this.getGixxAccidentItemDAO().getGIXXAccidentItemInto(params);
	}

}
