package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIWEndtText;

public interface GIISEndtTextDAO {

	List<GIPIWEndtText> getEndtTextList(HashMap<String, Object> params) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;
	void saveGiiss104(Map<String, Object> params) throws SQLException;
	void valDelRec(String recId) throws SQLException;	//Gzelle 02062015
}
