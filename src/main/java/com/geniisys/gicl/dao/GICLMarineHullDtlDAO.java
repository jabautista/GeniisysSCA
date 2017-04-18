package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.gicl.entity.GICLMarineHullDtl;

/**
 * 
 * @author rencela
 */
public interface GICLMarineHullDtlDAO {
	List<GICLMarineHullDtl> getMarineHullDtlList(HashMap<String, Object> params) throws SQLException;
	
	Map<String, Object> validateClmItemNo(Map<String, Object> params) throws SQLException;
	Map<String, Object> saveClmItemMarineHull(Map<String, Object> params) throws SQLException;
	//List<GICLCasualtyDtl> getPersonnelList(HashMap<String, Object> params)throws SQLException;
}
