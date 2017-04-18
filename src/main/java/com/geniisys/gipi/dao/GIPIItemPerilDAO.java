package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import com.geniisys.gipi.entity.GIPIItemPeril;

public interface GIPIItemPerilDAO {

	/**
	 * 
	 * @param parId
	 * @return
	 * @throws SQLException
	 */
	List<GIPIItemPeril> getGIPIItemPerils (Integer parId) throws SQLException;
	
	/**
	 * 
	 * @param policyId
	 * @return
	 * @throws SQLException
	 */
	String checkCompulsoryDeath(Integer policyId) throws SQLException;
	
	/**
	 * 
	 * @param policyId
	 * @return
	 * @throws SQLException
	 */
	Integer getItemPerilCount(Integer policyId) throws SQLException;
	
	/**
	 * @param  policyId
	 * @return list of perils for an Item
	 * @throws SQLException 
	 * @throws SQLException
	 */
	List<GIPIItemPeril> getItemPerils (HashMap<String,Object> params) throws SQLException;
	
}
