package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISHullTypeDAO {

	void saveGiiss046(Map<String, Object> params) throws SQLException;
	void valDeleteRec(Integer recId) throws SQLException;
	void valAddRec(Integer recId) throws SQLException;
}