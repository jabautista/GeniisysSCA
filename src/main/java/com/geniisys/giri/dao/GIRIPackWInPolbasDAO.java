/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.giri.dao
	File Name: GIRIPackWInpolbasDAO.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: May 31, 2012
	Description: 
*/


package com.geniisys.giri.dao;

import java.sql.SQLException;

import com.geniisys.giri.entity.GIRIPackWInPolbas;

public interface GIRIPackWInPolbasDAO {
	public void saveGiriPackWInpolbas(GIRIPackWInPolbas giriPackWInPolbas) throws SQLException;
	Integer getNewPackAcceptNo() throws SQLException;
	GIRIPackWInPolbas getGiriPackWInPolbas(Integer packParId) throws SQLException;
}
