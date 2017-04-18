package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIWPolGenin;

public interface GIISGeninInfoDAO {

	List<GIPIWPolGenin> getInitInfoList(HashMap<String, Object> params) throws SQLException;
	List<GIPIWPolGenin> getGenInfoList(HashMap<String, Object> params) throws SQLException;
	
	// shan 12.11.2013
	void saveGiiss180(Map<String, Object> params) throws SQLException;
	void valDeleteRec(String geninInfoCd) throws SQLException;
	void valAddRec(String geninInfoCd) throws SQLException;
	String allowUpdateGiiss180(String geninInfoCd) throws SQLException;
}
