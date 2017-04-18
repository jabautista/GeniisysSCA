package com.geniisys.common.service.impl;

import java.sql.SQLException;

import com.geniisys.common.dao.GIISDocumentDAO;
import com.geniisys.common.service.GIISDocumentService;

public class GIISDocumentServiceImpl implements GIISDocumentService{

	private GIISDocumentDAO giisDocumentDAO;

	public void setGiisDocumentDAO(GIISDocumentDAO giisDocumentDAO) {
		this.giisDocumentDAO = giisDocumentDAO;
	}

	public GIISDocumentDAO getGiisDocumentDAO() {
		return giisDocumentDAO;
	}
	
	@Override
	public String checkDisplayGiexs006(String title) throws SQLException {
		return this.giisDocumentDAO.checkDisplayGiexs006(title);
	}
	
	@Override
	public String checkPrintPremiumDetails(String lineCd)
			throws SQLException {
		return this.getGiisDocumentDAO().checkPrintPremiumDetails(lineCd);
	}

}
