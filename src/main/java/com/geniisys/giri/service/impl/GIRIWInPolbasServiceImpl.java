package com.geniisys.giri.service.impl;

import java.sql.SQLException;

import com.geniisys.giri.dao.GIRIWInPolbasDAO;
import com.geniisys.giri.entity.GIRIWInPolbas;
import com.geniisys.giri.service.GIRIWInPolbasService;
import com.seer.framework.util.StringFormatter;

public class GIRIWInPolbasServiceImpl implements GIRIWInPolbasService{
	
	private GIRIWInPolbasDAO giriWInPolbasDAO;

	public GIRIWInPolbasDAO getGiriWInPolbasDAO() {
		return giriWInPolbasDAO;
	}

	public void setGiriWInPolbasDAO(GIRIWInPolbasDAO giriWInPolbasDAO) {
		this.giriWInPolbasDAO = giriWInPolbasDAO;
	}

	@Override
	public GIRIWInPolbas getWInPolbas(Integer parId) throws SQLException {
		return (GIRIWInPolbas) StringFormatter.escapeHTMLInObject(this.getGiriWInPolbasDAO().getGIRIWInPolbasForPAR(parId)); //added escapeHTML christian 04/16/2013
	}

	@Override
	public Integer generateAcceptNo() throws SQLException {
		return this.getGiriWInPolbasDAO().generateAcceptNo();
	}

}
