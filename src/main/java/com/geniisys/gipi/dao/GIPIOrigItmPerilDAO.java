package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import com.geniisys.gipi.entity.GIPIOrigItmPeril;

public interface GIPIOrigItmPerilDAO {
	
	List<GIPIOrigItmPeril> getGipiOrigItmPerils(HashMap<String, Object> params) throws SQLException;
	
	List<HashMap<String, Object>> getOrigItmPerils(HashMap<String, Object> params) throws SQLException;
}
