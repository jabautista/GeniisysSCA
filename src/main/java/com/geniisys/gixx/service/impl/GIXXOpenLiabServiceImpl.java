package com.geniisys.gixx.service.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.dao.GIXXOpenLiabDAO;
import com.geniisys.gixx.entity.GIXXOpenLiab;
import com.geniisys.gixx.service.GIXXOpenLiabService;

public class GIXXOpenLiabServiceImpl implements GIXXOpenLiabService {

	private GIXXOpenLiabDAO gixxOpenLiabDAO;

	public GIXXOpenLiabDAO getGixxOpenLiabDAO() {
		return gixxOpenLiabDAO;
	}

	public void setGixxOpenLiabDAO(GIXXOpenLiabDAO gixxOpenLiabDAO) {
		this.gixxOpenLiabDAO = gixxOpenLiabDAO;
	}

	@Override
	public GIXXOpenLiab getGIXXOpenLiabInfo(Map<String, Object> params) throws SQLException {
		return this.getGixxOpenLiabDAO().getGIXXOpenLianInfo(params);
	}
	
}
