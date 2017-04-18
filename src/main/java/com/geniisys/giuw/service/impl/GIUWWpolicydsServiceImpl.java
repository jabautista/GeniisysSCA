package com.geniisys.giuw.service.impl;

import java.sql.SQLException;

import com.geniisys.giuw.dao.GIUWWpolicydsDAO;
import com.geniisys.giuw.service.GIUWWpolicydsService;

public class GIUWWpolicydsServiceImpl implements GIUWWpolicydsService{

	private GIUWWpolicydsDAO giuwWpolicydsDAO;

	public GIUWWpolicydsDAO getGiuwWpolicydsDAO() {
		return giuwWpolicydsDAO;
	}

	public void setGiuwWpolicydsDAO(GIUWWpolicydsDAO giuwWpolicydsDAO) {
		this.giuwWpolicydsDAO = giuwWpolicydsDAO;
	}

	@Override
	public String isExistGIUWWpolicyds(Integer distNo) throws SQLException {
		return this.getGiuwWpolicydsDAO().isExistGIUWWpolicyds(distNo);
	}
	
}
