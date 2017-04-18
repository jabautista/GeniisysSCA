package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIBeneficiary;

public interface GIPIBeneficiaryService {
	
	HashMap<String, Object> getGipiBeneficiaries(HashMap<String,Object> params) throws SQLException;
	GIPIBeneficiary getGIPIBeneficiary(Map<String, Object> params) throws SQLException;
}
