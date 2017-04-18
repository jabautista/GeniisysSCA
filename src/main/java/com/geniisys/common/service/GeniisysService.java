package com.geniisys.common.service;

import java.io.FileNotFoundException;
import java.io.IOException;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.common.entity.Geniisys;

public interface GeniisysService {

	Geniisys getGeniisysDetails(HttpServletRequest request) throws FileNotFoundException, IOException;
	
}
