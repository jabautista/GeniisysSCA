package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.gipi.entity.GIPIWBeneficiary;

public interface GIPIWBeneficiaryService {
	
	List<GIPIWBeneficiary> getGipiWBeneficiary(Integer parId) throws SQLException;
}
