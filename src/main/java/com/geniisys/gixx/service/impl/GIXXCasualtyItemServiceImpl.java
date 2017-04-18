package com.geniisys.gixx.service.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.dao.GIXXCasualtyItemDAO;
import com.geniisys.gixx.entity.GIXXCasualtyItem;
import com.geniisys.gixx.service.GIXXCasualtyItemService;

public class GIXXCasualtyItemServiceImpl implements GIXXCasualtyItemService{
	
	private GIXXCasualtyItemDAO gixxCasualtyItemDAO;

	public GIXXCasualtyItemDAO getGixxCasualtyItemDAO() {
		return gixxCasualtyItemDAO;
	}

	public void setGixxCasualtyItemDAO(GIXXCasualtyItemDAO gixxCasualtyItemDAO) {
		this.gixxCasualtyItemDAO = gixxCasualtyItemDAO;
	}

	
	@Override
	public GIXXCasualtyItem getGIXXCasualtyItemInfo(Map<String, Object> params) throws SQLException {
		return this.getGixxCasualtyItemDAO().getGIXXCasualtyItemInfo(params);
	}
	

}
