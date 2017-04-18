package com.geniisys.giuts.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface GIUTS023BeneficiaryInfoDAO {
	List<Map <String, Object>> getGIUTS023GroupedItems(Map<String, Object> params) throws SQLException; //for validation
	List<Map <String, Object>> getGIUTS023BeneficiaryNos(Map<String, Object> params) throws SQLException; //for validation
	String validateGroupedItemNo(Map<String, Object> params) throws SQLException;
	String validateBeneficiarymNo(Map<String, Object> params) throws SQLException;
	void saveGIUTS023(Map<String, Object> allParams) throws SQLException;
	String showOtherCert(String lineCd) throws SQLException;
}
