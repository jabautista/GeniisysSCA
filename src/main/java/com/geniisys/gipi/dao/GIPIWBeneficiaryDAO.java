package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.gipi.entity.GIPIWBeneficiary;

public interface GIPIWBeneficiaryDAO {

	List<GIPIWBeneficiary> getGipiWBeneficiary(Integer parId) throws SQLException;
}
