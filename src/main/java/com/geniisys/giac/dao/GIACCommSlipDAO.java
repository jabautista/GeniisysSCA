package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.entity.GIACCommSlipExt;

public interface GIACCommSlipDAO {
	
	List<GIACCommSlipExt> getCommSlip(Integer gaccTranId) throws SQLException;
	Map<String, Object> extractCommSlip(Map<String, Object> params) throws SQLException;
	Map<String, Object> getCommSlipPrintParams(Map<String, Object> params) throws SQLException;
	void confirmCommSlipPrinted(Map<String, Object> params) throws SQLException;
	void updateCommSlipTag(List<GIACCommSlipExt> commSlip) throws SQLException;
}
