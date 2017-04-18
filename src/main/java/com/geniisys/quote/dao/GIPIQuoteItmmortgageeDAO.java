package com.geniisys.quote.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.quote.entity.GIPIQuoteItmmortgagee;
import com.geniisys.quote.entity.GIPIQuoteItmperil;

public interface GIPIQuoteItmmortgageeDAO {	
	List<GIPIQuoteItmmortgagee> getItmMortgagee(Map<String, Object> params) throws SQLException;
}
