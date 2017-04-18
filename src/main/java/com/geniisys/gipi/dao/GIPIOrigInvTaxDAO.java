package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import com.geniisys.gipi.entity.GIPIOrigInvTax;

public interface GIPIOrigInvTaxDAO {
	
	List<GIPIOrigInvTax> getGipiInvTax(HashMap<String, Object> params) throws SQLException;
	
	List<HashMap<String , Object>> getLeadPolicyInvTax(HashMap<String, Object> params) throws SQLException;

}
