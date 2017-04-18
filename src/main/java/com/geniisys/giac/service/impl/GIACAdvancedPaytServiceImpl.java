package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.giac.dao.GIACAdvancedPaytDAO;
import com.geniisys.giac.entity.GIACAdvancedPayt;
import com.geniisys.giac.service.GIACAdvancedPaytService;

public class GIACAdvancedPaytServiceImpl implements GIACAdvancedPaytService{

	private GIACAdvancedPaytDAO giacAdvancedPaytDAO;
	
	/**
	 * @return the giacAdvancedPaytDAO
	 */
	public GIACAdvancedPaytDAO getGiacAdvancedPaytDAO() {
		return giacAdvancedPaytDAO;
	}

	/**
	 * @param giacAdvancedPaytDAO the giacAdvancedPaytDAO to set
	 */
	public void setGiacAdvancedPaytDAO(GIACAdvancedPaytDAO giacAdvancedPaytDAO) {
		this.giacAdvancedPaytDAO = giacAdvancedPaytDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAdvancedPaytService#deleteGIACAdvancedPayt(com.geniisys.giac.entity.GIACAdvancedPayt)
	 */
	@Override
	public void deleteGIACAdvancedPayt(GIACAdvancedPayt giacAdvancedPayt)
			throws SQLException {
		
		this.getGiacAdvancedPaytDAO().deleteGIACAdvancedPayt(giacAdvancedPayt);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAdvancedPaytService#deleteGIACAdvancedPayt(java.util.Map)
	 */
	@Override
	public void deleteGIACAdvancedPayt(Map<String, Object> params)
			throws SQLException {

		this.getGiacAdvancedPaytDAO().deleteGIACAdvancedPayt(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAdvancedPaytService#setGIACAdvancedPayt(com.geniisys.giac.entity.GIACAdvancedPayt)
	 */
	@Override
	public void setGIACAdvancedPayt(GIACAdvancedPayt giacAdvancedPaytDtls)
			throws SQLException {

		this.getGiacAdvancedPaytDAO().setGIACAdvancedPayt(giacAdvancedPaytDtls);
	}

}
