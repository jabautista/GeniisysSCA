package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIWBondBasic;

public interface GIPIWBondBasicDAO{
	
	GIPIWBondBasic getGIPIWBondBasic(Integer parId) throws SQLException;
	void insertGIPIWBondBasic(Map<String, Object> wBondBasic) throws SQLException;
	void saveBondPolicyData(Map<String, Object> params) throws SQLException;
	void deleteBillRelatedTables(Integer parId) throws SQLException;
	void saveEndtBondPolicyData(Map<String, Object>params)throws SQLException;
	GIPIWBondBasic getBondBasicNewRecord(Integer parId) throws SQLException;
	
	// shan 10.13.2014
	void saveLandCarrierDtl(Map<String, Object> params) throws SQLException;
	void valAddLandCarrierDtl(Map<String, Object> params) throws SQLException;
	Integer getMaxItemNoLandCarrierDtl(Integer parId) throws SQLException;
}
