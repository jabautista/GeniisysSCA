package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import com.geniisys.gipi.entity.GIPIOrigInvPerl;

public interface GIPIOrigInvPerlDAO {
	List<GIPIOrigInvPerl> getGipiInvPerl(HashMap<String, Object> params) throws SQLException;
	
	List<HashMap<String , Object>> getInvPerils(HashMap<String, Object> params) throws SQLException;
}
