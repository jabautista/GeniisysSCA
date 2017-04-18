package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GICLLossExpTaxDAO {
	Integer getNextTaxId(Map<String, Object> params) throws SQLException, Exception;
	void saveLossExpTax(Map<String, Object> params) throws SQLException, Exception;
	Integer checkLossExpTaxType(Map<String, Object> params) throws SQLException;
	String checkLossExpTaxExist(Map<String, Object> params) throws SQLException; //benjo 03.08.2017 SR-5945
}
