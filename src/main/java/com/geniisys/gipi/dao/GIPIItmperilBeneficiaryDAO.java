package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import com.geniisys.gipi.entity.GIPIItmperilBeneficiary;

public interface GIPIItmperilBeneficiaryDAO {
	
	List<GIPIItmperilBeneficiary> getItmperilBeneficiaries(HashMap<String,Object> params) throws SQLException;
}
