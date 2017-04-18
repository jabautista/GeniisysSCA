package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIBeneficiary;

public interface GIPIBeneficiaryDAO {
	
	List<GIPIBeneficiary> getGipiBeneficiaries(HashMap<String,Object> params) throws SQLException;
	GIPIBeneficiary getGIPIBeneficiary(Map<String, Object> params) throws SQLException;
}
