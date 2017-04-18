package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIWGrpItemsBeneficiary;

public interface GIPIWGrpItemsBeneficiaryDAO {

	List<GIPIWGrpItemsBeneficiary> getGipiWGrpItemsBeneficiary(Integer parId, Integer itemNo) throws SQLException;
	List<GIPIWGrpItemsBeneficiary> getGipiWGrpItemsBeneficiary2(Integer parId) throws SQLException;
	List<GIPIWGrpItemsBeneficiary> getRetGipiWGrpItemsBeneficiary(Map<String, Object> params) throws SQLException;
	
	void saveBeneficiaries(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateBenNo(Map<String, Object> params) throws SQLException;
	/*added by MarkS SR21720 10.5.2016 to handle checking of unique beneficiary no. from all item_no(enrollee) not by grouped_item_no(per enrollee)*/
	Map<String, Object> validateBenNo2(Map<String, Object> params) throws SQLException;
	/*END SR21720*/
}
