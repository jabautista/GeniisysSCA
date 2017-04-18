package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.gipi.entity.GIPIItemPeril;

public interface GIPIItemPerilService {
	
	/**
	 * Get list of itemPerils based on parId
	 * @param parId Integer
	 * @return list of gipiItemPerils
	 * @throws SQLException
	 */
	List<GIPIItemPeril> getGIPIItemPerils (Integer parId) throws SQLException;
	
	/**
	 * Check compulsary death based on policyId
	 * @param policyId Integer
	 * @return String compulsaryDeath
	 * @throws SQLException
	 */
	String checkCompulsoryDeath(Integer policyId) throws SQLException;
	
	/**
	 * Get itemPerilSize based on policyId
	 * @param policyId Integer
	 * @return size of itemPerilList having :policyId
	 * @throws SQLException
	 */
	Integer getItemPerilCount(Integer policyId) throws SQLException;
	
	/**
	 * Retrieves List of Perils for a given Item
	 * @param  a HashMap containing table grid parameters ,policyId and itemNo
	 * @throws SQLException 
	 * @returns HashMap that contains list of Perils
	 * @throws  SQLException
	 */
	HashMap<String, Object> getItemPerils(HashMap<String, Object> params) throws SQLException;
	JSONObject getGIPIS175Perils(HttpServletRequest request) throws JSONException, SQLException;
}
