package com.geniisys.common.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import org.json.JSONException;

import com.geniisys.common.entity.GIISCollateralType;

public interface GIISCollateralService {

	HashMap<String, Object> getCollateralList(HashMap<String, Object> params) throws SQLException;
	List<GIISCollateralType> getCollType() throws SQLException;
	void addCollateralPar(String parameter, Integer parId) throws SQLException, JSONException ;
	void delCollateralPar(String parameter, Integer parId) throws SQLException, JSONException ;
}
