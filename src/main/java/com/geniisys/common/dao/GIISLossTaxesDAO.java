package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISLossTaxesDAO {

	void saveGicls106(Map<String, Object> params) throws SQLException;
	String valDeleteRec(String recId) throws SQLException;
	void valAddRec(String recId) throws SQLException;
	Map<String, Object> validateGicls106Tax(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateGicls106Branch(Map<String, Object> params) throws SQLException;
	void copyTaxToIssuingSource(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateGicls106LossTaxes(Map<String, Object> params) throws SQLException;
	void saveLineLossExp(Map<String, Object> params) throws SQLException;
	String valLineLossExp(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateGicls106Line(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateGicls106LossExp(Map<String, Object> params) throws SQLException;
	void copyTaxToIssuingSourceAndTaxLine(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkCopyTaxLineBtn(Map<String, Object> params) throws SQLException;
}
