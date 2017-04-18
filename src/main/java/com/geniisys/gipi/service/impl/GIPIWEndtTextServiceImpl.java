package com.geniisys.gipi.service.impl;

import java.sql.SQLException;

import com.geniisys.gipi.dao.GIPIWEndtTextDAO;
import com.geniisys.gipi.entity.GIPIWEndtText;
import com.geniisys.gipi.service.GIPIWEndtTextService;

public class GIPIWEndtTextServiceImpl implements GIPIWEndtTextService{

	private GIPIWEndtTextDAO gipiWEndtTextDAO;
	
	public GIPIWEndtTextDAO getGipiWEndtTextDAO() {
		return gipiWEndtTextDAO;
	}

	public void setGipiWEndtTextDAO(GIPIWEndtTextDAO gipiWEndtTextDAO) {
		this.gipiWEndtTextDAO = gipiWEndtTextDAO;
	}

	@Override
	public String getEndtText(int parId) throws SQLException {		
		return this.getGipiWEndtTextDAO().getEndtText(parId);
	}

	@Override
	public GIPIWEndtText getGIPIWEndttext(Integer parId) throws SQLException {		
		return (GIPIWEndtText) this.getGipiWEndtTextDAO().getGIPIWEndttext(parId);
	}

	@Override
	public String CheckUpdateTaxEndtCancellation() throws SQLException {
		return  (String) this.getGipiWEndtTextDAO().CheckUpdateTaxEndtCancellation();
	}
}
