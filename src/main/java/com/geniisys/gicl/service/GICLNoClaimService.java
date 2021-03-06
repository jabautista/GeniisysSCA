package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gicl.entity.GICLNoClaim;

public interface GICLNoClaimService {
	
	GICLNoClaim getNoClaimCertDtls (Integer noClaimId) throws SQLException;
	Map<String, Object> getDetailsGICLS026(Map<String, Object> params) throws SQLException;
	Map<String, Object> getSignatoryGICLS026(Map<String, Object> params) throws SQLException;
	Map<String, Object> insertNewRecordGICLS026(Map<String, Object> params) throws SQLException ;
	Map<String, Object> updateRecordGICLS026(Map<String, Object> params) throws SQLException ;
	
}
