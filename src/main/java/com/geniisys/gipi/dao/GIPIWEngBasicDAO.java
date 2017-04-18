package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIWPrincipal;
import com.geniisys.gipi.entity.GIPIWEngBasic;

public interface GIPIWEngBasicDAO {

	public GIPIWEngBasic getWEngBasicInfo(int parId) throws SQLException;
	
	public void setWEngBasicInfo(GIPIWEngBasic enInfo) throws SQLException;
	
	public List<GIPIWPrincipal> getENPrincipals(int parId, String pType) throws SQLException;
	
	public void saveENPrincipals(Map<String, Object> principals, int parId) throws SQLException;
	
}
