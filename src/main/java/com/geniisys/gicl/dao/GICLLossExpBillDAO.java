package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GICLLossExpBillDAO {
	
	void saveLossExpBill(Map<String, Object> params) throws SQLException, Exception;
	Map<String, Object> chkLossExpBill (Map<String, Object> params) throws SQLException, Exception; //Added by: Jerome Bautista 05.28.2015 SR 3646
}
