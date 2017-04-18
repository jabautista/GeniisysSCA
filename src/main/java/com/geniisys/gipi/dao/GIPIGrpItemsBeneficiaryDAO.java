package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import com.geniisys.gipi.entity.GIPIGrpItemsBeneficiary;

public interface GIPIGrpItemsBeneficiaryDAO{

	List<GIPIGrpItemsBeneficiary> getGrpItemsBeneficiaries(HashMap<String,Object> params) throws SQLException;
}
