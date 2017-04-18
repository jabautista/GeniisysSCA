package com.geniisys.giri.service;

import java.sql.SQLException;

import com.geniisys.giri.entity.GIRIWInPolbas;

public interface GIRIWInPolbasService {
	
	public GIRIWInPolbas getWInPolbas(Integer parId) throws SQLException;
	
	Integer generateAcceptNo() throws SQLException;

}
