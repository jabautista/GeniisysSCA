package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.HashMap;

public interface GIPIGrpItemsBeneficiaryService {
	
	HashMap<String, Object> getGrpItemsBeneficiaries(HashMap<String,Object> params) throws SQLException;
	
}
