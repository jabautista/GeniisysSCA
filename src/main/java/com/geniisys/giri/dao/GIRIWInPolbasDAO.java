package com.geniisys.giri.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.giri.entity.GIRIWInPolbas;

public interface GIRIWInPolbasDAO {

	public void saveGIRIWInPolbas(Map<String, Object> giriWInPolbas) throws SQLException;
	
	GIRIWInPolbas getGIRIWInPolbasForPAR(int parId) throws SQLException;
	
	Integer generateAcceptNo() throws SQLException;
	
}
