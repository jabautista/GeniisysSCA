package com.geniisys.gixx.service.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.dao.GIXXFireItemDAO;
import com.geniisys.gixx.entity.GIXXFireItem;
import com.geniisys.gixx.service.GIXXFireItemService;

public class GIXXFireItemServiceImpl implements GIXXFireItemService{

	private GIXXFireItemDAO gixxFireItemDAO;

	public GIXXFireItemDAO getGixxFireItemDAO() {
		return gixxFireItemDAO;
	}

	public void setGixxFireItemDAO(GIXXFireItemDAO gixxFireItemDAO) {
		this.gixxFireItemDAO = gixxFireItemDAO;
	}

	@Override
	public GIXXFireItem getGIXXFireItemInfo(Map<String, Object> params) throws SQLException {
		return this.getGixxFireItemDAO().getGIXXFireItemInfo(params);
	}
	
	
}
