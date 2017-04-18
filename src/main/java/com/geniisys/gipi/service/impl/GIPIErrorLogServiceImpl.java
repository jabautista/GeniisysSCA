package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.gipi.dao.GIPIErrorLogDAO;
import com.geniisys.gipi.entity.GIPIErrorLog;
import com.geniisys.gipi.service.GIPIErrorLogService;
import com.seer.framework.util.StringFormatter;

public class GIPIErrorLogServiceImpl implements GIPIErrorLogService{

	private GIPIErrorLogDAO gipiErrorLogDAO;

	public GIPIErrorLogDAO getGipiErrorLogDAO() {
		return gipiErrorLogDAO;
	}

	public void setGipiErrorLogDAO(GIPIErrorLogDAO gipiErrorLogDAO) {
		this.gipiErrorLogDAO = gipiErrorLogDAO;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIErrorLog> getGipiErrorLog(String filename)
			throws SQLException {
		return (List<GIPIErrorLog>) StringFormatter.replaceQuotesInList(this.gipiErrorLogDAO.getGipiErrorLog(filename));
	}
	
	
}
