package com.geniisys.gixx.service.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.dao.GIXXAviationItemDAO;
import com.geniisys.gixx.entity.GIXXAviationItem;
import com.geniisys.gixx.service.GIXXAviationItemService;

public class GIXXAviationItemServiceImpl implements GIXXAviationItemService{
	
	private GIXXAviationItemDAO gixxAviationItemDAO;

	public GIXXAviationItemDAO getGixxAviationItemDAO() {
		return gixxAviationItemDAO;
	}

	public void setGixxAviationItemDAO(GIXXAviationItemDAO gixxAviationItemDAO) {
		this.gixxAviationItemDAO = gixxAviationItemDAO;
	}

	@Override
	public GIXXAviationItem getGIXXAviationItemInfo(Map<String, Object> params) throws SQLException {
		return this.getGixxAviationItemDAO().getGIXXAviationItemInfo(params);
	}

}
