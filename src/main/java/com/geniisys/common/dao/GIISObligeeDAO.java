package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISObligee;

public interface GIISObligeeDAO {
	
	List<GIISObligee> getObligeeList(HashMap<String,Object> params) throws SQLException;
	
	/**
	 * For retrieving obligee list used for Obligee Maintenance
	 * @param params
	 * @return obligeeList of type GIISObligee
	 * @throws SQLException
	 */
	List<GIISObligee> getObligeeListMaintenance(HashMap<String, Object> params) throws SQLException;
	
	/**
	 * For saving additions, deletions, and modifications made into the obligee information
	 * @param allParams
	 * @return message equals "SUCCESS" for successful saving
	 * @throws SQLException
	 */
	String saveObligee(Map<String, Object> allParams) throws SQLException;
	
	/**
	 * For validating an obligee if it has dependents from other database tables
	 * @param obligeeNo
	 * @return tableName from which the obligee to be deleted has dependents
	 * @throws SQLException
	 */
	String validateObligeeNoOnDelete(Integer obligeeNo) throws SQLException;
}
