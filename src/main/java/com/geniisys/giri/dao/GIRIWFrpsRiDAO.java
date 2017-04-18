package com.geniisys.giri.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.giri.entity.GIRIWFrpsRi;

public interface GIRIWFrpsRiDAO {

	Map<String, Object> getWarrDays(Map<String, Object> params) throws SQLException;
	List<GIRIWFrpsRi> getGIRIWFrpsRiList (HashMap<String, Object> params) throws SQLException;
	void setRiAcceptance(Map<String, Object> params) throws SQLException;
	Map<String, Object> computeRiPremAmt(Map<String, Object> params) throws SQLException;
	Map<String, Object> computeRiPremVat1(Map<String, Object> params) throws SQLException;
	String createBindersGiris002(Map<String, Object> params) throws SQLException;
	Map<String, Object>  saveRiPlacement(Map<String, Object> params) throws SQLException;
	String checkDelRecRiPlacement(String preBinderId) throws SQLException;
	Map<String, Object> adjustPremVat(Map<String, Object> params) throws SQLException;
	Map<String, Object> adjustPremVatGIRIS002(Map<String, Object> params) throws SQLException;
	String validateBinderPrinting(Map<String, Object> params) throws SQLException;
	String validateFrpsPosting(Map<String, Object> params) throws SQLException;
	Map<String, Object> getTsiPremAmt(Map<String, Object> params) throws SQLException;
}
