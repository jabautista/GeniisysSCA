package com.geniisys.gipi.service.impl;

import java.sql.SQLException;

import com.geniisys.gipi.dao.GIPIParBillGroupingDAO;
import com.geniisys.gipi.service.GIPIParBillGroupingService;

public class GIPIParBillGroupingServiceImpl implements GIPIParBillGroupingService{
	
	private GIPIParBillGroupingDAO gipiParBillGroupingDAO;
	
	public void setGipiParBillGroupingDAO(GIPIParBillGroupingDAO gipiParBillGroupingDAO) {
		this.gipiParBillGroupingDAO = gipiParBillGroupingDAO;
	}

	public GIPIParBillGroupingDAO getGipiParBillGroupingDAO() {
		return gipiParBillGroupingDAO;
	}
	
	@Override
	public void deleteDistWorkTables(Integer parId) throws SQLException {
		this.gipiParBillGroupingDAO.deleteDistWorkTables(parId);
	}

}
