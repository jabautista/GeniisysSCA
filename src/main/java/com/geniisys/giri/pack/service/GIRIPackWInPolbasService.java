/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.giri.pack.service
	File Name: GIRIPackWInPolbasService.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Jun 6, 2012
	Description: 
*/


package com.geniisys.giri.pack.service;

import java.sql.SQLException;

import com.geniisys.giri.entity.GIRIPackWInPolbas;

public interface GIRIPackWInPolbasService {
	GIRIPackWInPolbas getGiriPackWInPolbas(Integer packParId) throws SQLException; 
}
