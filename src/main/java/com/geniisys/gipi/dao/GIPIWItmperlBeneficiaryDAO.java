package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.gipi.entity.GIPIWItmperlBeneficiary;

public interface GIPIWItmperlBeneficiaryDAO {

	List<GIPIWItmperlBeneficiary> getGipiWItmperlBeneficiary(Integer parId, Integer itemNo) throws SQLException;
	List<GIPIWItmperlBeneficiary> getGipiWItmperlBeneficiary2(Integer parId) throws SQLException;
}
