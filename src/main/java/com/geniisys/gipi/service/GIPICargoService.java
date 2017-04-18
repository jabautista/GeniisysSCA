package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

public interface GIPICargoService {

	void getCargoInfo(HashMap<String,Object> params,HttpServletRequest request) throws SQLException,JSONException; //edited by MarkS 5.11.2016 SR-22217
	
}
