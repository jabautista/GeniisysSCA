package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;

import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIWEngBasic;
import com.geniisys.gipi.entity.GIPIWPrincipal;

public interface GIPIWEngBasicService {

	public GIPIWEngBasic getWEngBasicInfo(int parId) throws SQLException;
	
	//public void setWEngBasicInfo(GIPIWEngBasic enInfo) throws SQLException;
	public void setWEngBasicInfo(String enInfo, String subline) throws SQLException, JSONException, ParseException;
	
	public List<GIPIWPrincipal> getENPrincipals(int parId, String pType) throws SQLException;
	
	public void saveENPrincipals(String principals, int parId) throws SQLException, JSONException, ParseException;
	
}
