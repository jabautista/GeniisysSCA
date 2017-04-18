package com.geniisys.common.service;

import java.sql.SQLException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISTaxCharges;

public interface GIISTaxChargesService {
	JSONObject showGiiss028(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGiiss028(HttpServletRequest request, String userId) throws SQLException, JSONException;
	String valAddRec(HttpServletRequest request) throws SQLException;
	String valDateOnAdd(HttpServletRequest request) throws SQLException;
	void valSeqOnAdd (HttpServletRequest request) throws SQLException;
	public List<GIISTaxCharges> getGiisTaxCharges(HttpServletRequest request) throws SQLException;	//Gzelle 10282014
}
