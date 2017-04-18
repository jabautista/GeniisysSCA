package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import com.geniisys.gipi.entity.GIPIOrigCommInvPeril;

public interface GIPIOrigCommInvPerilDAO {
	List<GIPIOrigCommInvPeril> getGipiOrigCommInvPeril(HashMap<String, Object> params) throws SQLException;
	
	List<HashMap<String , Object>> getCommInvPerils(HashMap<String, Object> params) throws SQLException;
}
