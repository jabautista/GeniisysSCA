package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import com.geniisys.gicl.entity.GICLNoClaim;
import com.geniisys.gicl.entity.GICLNoClaimMultiYy;

public interface GICLNoClaimMultiYyDAO {
	Map<String, Object> getNoClaimMultiYyList(HashMap<String, Object> params) throws SQLException;
	GICLNoClaimMultiYy getNoClaimMultiYyDetails(Integer noClaimId) throws SQLException;
	Map<String, Object> getNoClaimMultiYyPolicyList(HashMap<String, Object> params)throws SQLException;
	Map<String, Object> getNoClaimMultiYyPolicyList2(HashMap<String,Object> params)throws SQLException;
	Map<String, Object> getNoClaimMultiYyPolicyList3(HashMap<String, Object> params)throws SQLException;
	Integer getNoClaimMultiYyNo() throws SQLException;
	//Map<String, Object> insertNewDetails(Map<String, Object> params)throws SQLException;
	GICLNoClaimMultiYy populateDetails(HashMap<String, Object> params)throws SQLException;
	String validateExisting(Map<String, Object> params) throws SQLException;
	GICLNoClaimMultiYy additionalDtl() throws SQLException;
	GICLNoClaimMultiYy updateDtls(Integer noClaimId) throws SQLException;
	Map<String, Object> saveNewDetails (Map<String, Object> params) throws SQLException;
	GICLNoClaim getNoClaimCertDtls (Integer noClaimId) throws SQLException;
	
	
}
