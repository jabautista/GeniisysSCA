package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.gicl.entity.GICLCasualtyDtl;

public interface GICLCasualtyDtlDAO {
	/**
	 * @author rey
	 * @date 09.01.2011
	 * @param params
	 * @return casualty detail
	 * @throws SQLException
	 */
	List<GICLCasualtyDtl> getCasualtyDtlList(HashMap<String, Object> params) throws SQLException;
	
	Map<String, Object> validateClmItemNo(Map<String, Object> params) throws SQLException;
	Map<String, Object> saveClmItemCasualty(Map<String, Object> params) throws SQLException;
	List<GICLCasualtyDtl> getPersonnelList(HashMap<String, Object> params)
			throws SQLException;
	/*Map<String, Object> savePersonnel(Map<String, Object> params) throws SQLException;*/
	String getCasualtyGroupedItemTitle(Map<String, Integer> params) throws SQLException;
	Map<String, Object> validateGroupItemNo(Map<String, Object>params) throws SQLException;
	Map<String, Object>validatePersonnelNo (Map<String, Object>params) throws SQLException;
	
}
