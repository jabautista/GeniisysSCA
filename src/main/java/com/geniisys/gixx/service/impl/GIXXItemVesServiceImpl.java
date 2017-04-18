package com.geniisys.gixx.service.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.dao.GIXXItemVesDAO;
import com.geniisys.gixx.entity.GIXXItemVes;
import com.geniisys.gixx.service.GIXXItemVesService;

public class GIXXItemVesServiceImpl implements GIXXItemVesService {

	private GIXXItemVesDAO gixxItemVesDAO;

	public GIXXItemVesDAO getGixxItemVesDAO() {
		return gixxItemVesDAO;
	}

	public void setGixxItemVesDAO(GIXXItemVesDAO gixxItemVesDAO) {
		this.gixxItemVesDAO = gixxItemVesDAO;
	}

	
	@Override
	public GIXXItemVes getGIXXItemVesInfo(Map<String, Object> params) throws SQLException {
		return this.getGixxItemVesDAO().getGIXXItemVesInfo(params);
	}
	
}
