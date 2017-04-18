package com.geniisys.gipi.pack.service.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gipi.pack.dao.GIPIPackWPolGeninDAO;
import com.geniisys.gipi.pack.entity.GIPIPackWPolGenin;
import com.geniisys.gipi.pack.service.GIPIPackWPolGeninService;
import com.seer.framework.util.StringFormatter;

public class GIPIPackWPolGeninServiceImpl implements GIPIPackWPolGeninService{
	
	private GIPIPackWPolGeninDAO gipiPackWPolGeninDAO;

	public void setGipiPackWPolGeninDAO(GIPIPackWPolGeninDAO gipiPackWPolGeninDAO) {
		this.gipiPackWPolGeninDAO = gipiPackWPolGeninDAO;
	}

	public GIPIPackWPolGeninDAO getGipiPackWPolGeninDAO() {
		return gipiPackWPolGeninDAO;
	}
	
	@Override
	public GIPIPackWPolGenin getGipiPackWPolGenin(Integer packParId)
			throws SQLException {
		return (GIPIPackWPolGenin) StringFormatter.replaceQuotesInObject(this.gipiPackWPolGeninDAO.getGipiPackWPolGenin(packParId));
	}

	@Override
	public void copyPackWPolGeninGiuts008a(Map<String, Object> params) throws SQLException {
		this.getGipiPackWPolGeninDAO().copyPackWPolGeninGiuts008a(params);
	}
}
