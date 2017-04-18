package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.gicl.dao.GICLPrelimLossReportDAO;
import com.geniisys.gicl.entity.GICLClaims;
import com.geniisys.gicl.service.GICLPrelimLossReportService;

public class GICLPrelimLossReportServiceImpl implements GICLPrelimLossReportService{
	private GICLPrelimLossReportDAO giclPrelimLossReportDAO;

	public void setGiclPrelimLossReportDAO(GICLPrelimLossReportDAO giclPrelimLossReportDAO) {
		this.giclPrelimLossReportDAO = giclPrelimLossReportDAO;
	}

	public GICLPrelimLossReportDAO getGiclPrelimLossReportDAO() {
		return giclPrelimLossReportDAO;
	}

	public GICLClaims getPrelimLossInfo(Integer claimId) throws SQLException {
		return this.getGiclPrelimLossReportDAO().getPrelimLossInfo(claimId);
	}

	public GICLClaims getFinalLossInfo(Integer claimId) throws SQLException {
		return this.getGiclPrelimLossReportDAO().getFinalLossInfo(claimId);
	}

	public List<String> getAgentList(Integer claimId) throws SQLException {
		return this.getGiclPrelimLossReportDAO().getAgentList(claimId);
	}

	public List<String> getMortgageeList(Integer claimId) throws SQLException {
		return this.getGiclPrelimLossReportDAO().getMortgageeList(claimId);
	}
}
