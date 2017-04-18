package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.common.entity.GIISTariffRatesHdr;

public interface GIISTariffRatesHdrDAO {
	
	GIISTariffRatesHdr getTariffDetailsFI(Map<String, Object> params) throws SQLException; 
	GIISTariffRatesHdr getTariffDetailsMC(Map<String, Object> params) throws SQLException; 
	
	// shan 01.07.2014
//	Map<String, Object> getGiiss106WithCompDtl(String tariffCd) throws SQLException; //remove by steven 07.14.2014
//	Map<String, Object> getGiiss106FixedPremDtl(String tariffCd) throws SQLException;
	void valAddHdrRec(Map<String, Object> params) throws SQLException;
	void valDeleteHdrRec(String tariffCd) throws SQLException;
	Integer getTariffCdNoSequence() throws SQLException;
	void valTariffRatesFixedSIRec(Map<String, Object> params) throws SQLException;
//	Map<String, Object> getGiiss106MinMaxAmt(Integer tariffCd) throws SQLException;
//	Integer getNextTariffDtlCd(Integer tariffCd) throws SQLException;
	void valAddDtlRec(Map<String, Object> params) throws SQLException;
	void saveGiiss106(Map<String, Object> params) throws SQLException;
}
