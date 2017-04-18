package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.gicl.entity.GICLClaims;

public interface GICLPrelimLossReportDAO {
	GICLClaims getPrelimLossInfo(Integer claimId) throws SQLException;
	GICLClaims getFinalLossInfo(Integer claimId) throws SQLException;
	List<String> getAgentList(Integer claimId) throws SQLException;
	List<String> getMortgageeList(Integer claimId) throws SQLException;
}
