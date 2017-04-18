package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISTaxCharges;


public interface GIISTaxChargesDAO {
	void saveGiiss028(Map<String, Object> params) throws SQLException;
	void valDeleteRec(Map<String, Object> params) throws SQLException;
	String valAddRec(Map<String, Object> params) throws SQLException;
	String valDateOnAdd(Map<String, Object> params) throws SQLException;
	void valSeqOnAdd (Map<String, Object> params) throws SQLException;
	public List<GIISTaxCharges> getGiisTaxCharges(Map<String, Object> params) throws SQLException;	//Gzelle 10282014
}

