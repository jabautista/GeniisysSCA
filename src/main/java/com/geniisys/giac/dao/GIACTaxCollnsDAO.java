package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.giac.entity.GIACTaxCollns;

public interface GIACTaxCollnsDAO {
	
	List<GIACTaxCollns> getTaxCollnsListing(Integer gaccTranId) throws SQLException;
	
	
}
