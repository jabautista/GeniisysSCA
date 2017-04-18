package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gicl.entity.GICLNoClaim;
import com.geniisys.gicl.entity.GICLNoClaimMultiYy;

public interface GICLNoClaimMultiYyService {

	Map<String, Object> getNoClaimMultiYyList(HashMap<String, Object> params)throws SQLException;
	GICLNoClaimMultiYy getNoClaimMultiYyDetails(Integer noClaimId)
			throws SQLException;
	Map<String, Object> getNoClaimMultiYyPolicyList(HashMap<String,Object> params)throws SQLException;
	Map<String, Object> getNoClaimMultiYyPolicyList2(HashMap<String, Object> params)throws SQLException;
	Map<String, Object> getNoClaimMultiYyPolicyList3(HashMap<String, Object> params)throws SQLException;
	Integer getNoClaimMultiYyNumber() throws SQLException;
	//String insertNewDetail(HttpServletRequest request, GIISUser USER)throws SQLException, JSONException, ParseException;
	String saveNewDetail(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	GICLNoClaimMultiYy populateDetails(HashMap<String,Object> params)throws SQLException;
	String validateExisting(Map<String, Object> params)throws SQLException;
	GICLNoClaimMultiYy additionalDtls() throws SQLException;
	GICLNoClaimMultiYy updateDtls(Integer noClaimId) throws SQLException;
	String saveNoClmMultiYy(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	GICLNoClaim getNoClaimCertDtls (Integer noClaimId) throws SQLException;
}
