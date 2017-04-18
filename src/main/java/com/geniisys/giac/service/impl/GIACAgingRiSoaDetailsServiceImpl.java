package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.giac.dao.GIACAgingRiSoaDetailsDAO;
import com.geniisys.giac.entity.GIACAgingRiSoaDetails;
import com.geniisys.giac.service.GIACAgingRiSoaDetailsService;

public class GIACAgingRiSoaDetailsServiceImpl implements
		GIACAgingRiSoaDetailsService {
	
	/** The DAO **/
	private GIACAgingRiSoaDetailsDAO giacAgingRiSoaDetailsDAO;

	public void setGiacAgingRiSoaDetailsDAO(GIACAgingRiSoaDetailsDAO giacAgingRiSoaDetailsDAO) {
		this.giacAgingRiSoaDetailsDAO = giacAgingRiSoaDetailsDAO;
	}

	public GIACAgingRiSoaDetailsDAO getGiacAgingRiSoaDetailsDAO() {
		return giacAgingRiSoaDetailsDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAgingRiSoaDetailsService#getAgingRiSoaDetails(java.lang.String)
	 */
	@Override
	public PaginatedList getAgingRiSoaDetails(String keyword)
			throws SQLException {
		List<GIACAgingRiSoaDetails> agingRiSoaDetails = this.getGiacAgingRiSoaDetailsDAO().getAgingRiSoaDetails(keyword);
		PaginatedList paginatedList = new PaginatedList(agingRiSoaDetails, ApplicationWideParameters.PAGE_SIZE);
		return paginatedList;
	}
}
