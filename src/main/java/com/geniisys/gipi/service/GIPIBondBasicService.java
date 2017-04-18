package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.text.ParseException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;

public interface GIPIBondBasicService {

	void getBondPolicyData(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	void getGipiCosigntry(Integer policyId, HttpServletRequest request) throws SQLException, JSONException;

}
