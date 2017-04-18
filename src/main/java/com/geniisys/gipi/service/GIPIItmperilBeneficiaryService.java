package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.HashMap;

public interface GIPIItmperilBeneficiaryService {
	
	HashMap<String, Object> getItmperilBeneficiaries (HashMap<String,Object> params) throws SQLException;
}
