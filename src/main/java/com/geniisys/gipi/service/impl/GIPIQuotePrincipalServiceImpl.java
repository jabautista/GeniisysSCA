package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.gipi.dao.GIPIQuotePrincipalDAO;
import com.geniisys.gipi.entity.GIPIQuotePrincipal;
import com.geniisys.gipi.service.GIPIQuotePrincipalService;

public class GIPIQuotePrincipalServiceImpl implements GIPIQuotePrincipalService{
	
	private GIPIQuotePrincipalDAO gipiQuotePrincipalDAO;
	
	/**
	 * @return the gipiQuotePrincipalDAO
	 */
	public GIPIQuotePrincipalDAO getGipiQuotePrincipalDAO() {
		return gipiQuotePrincipalDAO;
	}
	/**
	 * @param gipiQuotePrincipalDAO the gipiQuotePrincipalDAO to set
	 */
	public void setGipiQuotePrincipalDAO(GIPIQuotePrincipalDAO gipiQuotePrincipalDAO) {
		this.gipiQuotePrincipalDAO = gipiQuotePrincipalDAO;
	}
	
	@Override
	public List<GIPIQuotePrincipal> getPrincipalList(Integer quoteId, String principalType) throws SQLException {
		// TODO Auto-generated method stub
		return gipiQuotePrincipalDAO.getPrincipalList(quoteId, principalType);
	}
	
	@Override
	public List<GIPIQuotePrincipal> getPrincipalListForPackQuote(
			Integer packQuoteId, String principalType) throws SQLException {
		return this.getGipiQuotePrincipalDAO().getPrincipalListForPackQuote(packQuoteId, principalType);
	}

}
