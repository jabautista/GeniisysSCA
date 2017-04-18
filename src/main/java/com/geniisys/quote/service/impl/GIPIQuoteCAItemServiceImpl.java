package com.geniisys.quote.service.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.quote.dao.GIPIQuoteCAItemDAO;
import com.geniisys.quote.entity.GIPIQuoteCAItem;
import com.geniisys.quote.service.GIPIQuoteCAItemService;

public class GIPIQuoteCAItemServiceImpl implements GIPIQuoteCAItemService{
	
	private GIPIQuoteCAItemDAO gipiQuoteCAItemDAO;

	public GIPIQuoteCAItemDAO getGipiQuoteCAItemDAO() {
		return gipiQuoteCAItemDAO;
	}

	public void setGipiQuoteCAItemDAO(GIPIQuoteCAItemDAO gipiQuoteCAItemDAO) {
		this.gipiQuoteCAItemDAO = gipiQuoteCAItemDAO;
	}

	@Override
	public GIPIQuoteCAItem getGIPIQuoteCAItemDetails(Map<String, Object> params)
			throws SQLException {
		return this.getGipiQuoteCAItemDAO().getGIPIQuoteCAItemDetails(params);
	}

}
