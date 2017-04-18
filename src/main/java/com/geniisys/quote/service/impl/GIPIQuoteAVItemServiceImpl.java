package com.geniisys.quote.service.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.quote.dao.GIPIQuoteAVItemDAO;
import com.geniisys.quote.entity.GIPIQuoteAVItem;
import com.geniisys.quote.service.GIPIQuoteAVItemService;

public class GIPIQuoteAVItemServiceImpl implements GIPIQuoteAVItemService{
	
	private GIPIQuoteAVItemDAO gipiQuoteAVItemDAO;

	public GIPIQuoteAVItemDAO getGipiQuoteAVItemDAO() {
		return gipiQuoteAVItemDAO;
	}

	public void setGipiQuoteAVItemDAO(GIPIQuoteAVItemDAO gipiQuoteAVItemDAO) {
		this.gipiQuoteAVItemDAO = gipiQuoteAVItemDAO;
	}

	@Override
	public GIPIQuoteAVItem getGIPIQuoteAVItemDetails(Map<String, Object> params)
			throws SQLException {
		return this.getGipiQuoteAVItemDAO().getGIPIQuoteAVItemDetails(params);
	}

}
