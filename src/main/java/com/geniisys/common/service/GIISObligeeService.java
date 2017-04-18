package com.geniisys.common.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISObligee;
import com.ibm.disthub2.impl.matching.selector.ParseException;

public interface GIISObligeeService {
	
	HashMap<String, Object> getObligeeList(HashMap<String, Object> params) throws SQLException;
	
	/**
	 * For retrieving obligee list used for Obligee Maintenance
	 * @param params
	 * @return obligeeList of type GIISObligee
	 * @throws SQLException
	 */
	List<GIISObligee> getObligeeListMaintenance(HashMap<String, Object> params) throws SQLException;
	
	/**
	 * For saving additions, deletions, and modifications made into the obligee information
	 * @param request
	 * @param userId
	 * @return message equals "SUCCESS" for successful saving
	 * @throws SQLException
	 * @throws JSONException
	 * @throws ParseException
	 */
	String saveObligee(HttpServletRequest request, String userId) throws SQLException, JSONException, ParseException;
	
	/**
	 * For validating an obligee if it has dependents from other database tables
	 * @param obligeeNoToValidate
	 * @return tableName from which the obligee to be deleted has dependents
	 * @throws SQLException
	 */
	String validateObligeeNoOnDelete(Integer obligeeNoToValidate) throws SQLException;
}
