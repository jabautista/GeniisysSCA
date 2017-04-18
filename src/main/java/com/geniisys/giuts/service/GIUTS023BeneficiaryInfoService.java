package com.geniisys.giuts.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

public interface GIUTS023BeneficiaryInfoService {
	void populateDropDownLists(Map<String, Object> params) throws SQLException, JSONException;
	Map<String, Object> populateGIUTS023ItemInfoTableGrid(HttpServletRequest request) throws SQLException, JSONException;
	Map<String, Object>	populateGIUTS023GroupedItemsInfoTableGrid(HttpServletRequest request) throws SQLException, JSONException;
	List<Map<String, Object>> getGIUTS023GroupedItems(HttpServletRequest request) throws SQLException, JSONException; //for validation
	List<Map<String, Object>> getGIUTS023BeneficiaryNos(HttpServletRequest request) throws SQLException, JSONException; //for validation
	String validateGroupedItemNo(HttpServletRequest request) throws SQLException, JSONException;
	String validateBeneficiaryNo(HttpServletRequest request) throws SQLException, JSONException;
	Map<String, Object> populateGIUTS023beneficiaryInfoTableGrid(HttpServletRequest request) throws SQLException, JSONException;
	String saveGIUTS023(String parameters, Map<String, Object> params) throws JSONException, SQLException;
	String showOtherCert(String lineCd) throws SQLException;
}
