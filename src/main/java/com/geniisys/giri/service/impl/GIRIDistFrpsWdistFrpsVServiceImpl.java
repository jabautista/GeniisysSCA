package com.geniisys.giri.service.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.giri.dao.GIRIDistFrpsWdistFrpsVDAO;
import com.geniisys.giri.entity.GIRIDistFrpsWdistFrpsV;
import com.geniisys.giri.service.GIRIDistFrpsWdistFrpsVService;

public class GIRIDistFrpsWdistFrpsVServiceImpl implements GIRIDistFrpsWdistFrpsVService{
	
	GIRIDistFrpsWdistFrpsVDAO giriDistFrpsWdistFrpsVDAO;
	
	/**
	 * @return the giriDistFrpsWdistFrpsVDAO
	 */
	public GIRIDistFrpsWdistFrpsVDAO getGiriDistFrpsWdistFrpsVDAO() {
		return giriDistFrpsWdistFrpsVDAO;
	}

	/**
	 * @param giriDistFrpsWdistFrpsVDAO the giriDistFrpsWdistFrpsVDAO to set
	 */
	public void setGiriDistFrpsWdistFrpsVDAO(
			GIRIDistFrpsWdistFrpsVDAO giriDistFrpsWdistFrpsVDAO) {
		this.giriDistFrpsWdistFrpsVDAO = giriDistFrpsWdistFrpsVDAO;
	}

	@Override
	public GIRIDistFrpsWdistFrpsV getWdistFrpsVDtls(Map<String, Object> params) throws SQLException{
		// TODO Auto-generated method stub
		return (GIRIDistFrpsWdistFrpsV) giriDistFrpsWdistFrpsVDAO.getWdistFrpsVDtls(params);
	}

}
