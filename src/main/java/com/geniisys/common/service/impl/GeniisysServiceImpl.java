package com.geniisys.common.service.impl;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import com.geniisys.common.entity.Geniisys;
import com.geniisys.common.service.GeniisysService;

public class GeniisysServiceImpl implements GeniisysService {

	private static Logger log = Logger.getLogger(GeniisysServiceImpl.class);
	
	@Override
	public Geniisys getGeniisysDetails(HttpServletRequest request) throws FileNotFoundException, IOException {
		String path = request.getServletContext().getRealPath("");
		File version = new File(path+"\\WEB-INF\\version.properties");
		Geniisys geniisys = null;
		
		if(version.isFile()){
			geniisys = new Geniisys();

			log.info("Reading version file...");
			try(BufferedReader br = new BufferedReader(new FileReader(version))){
				for(String line; (line = br.readLine()) != null; ) {
					System.out.println(line);
					if(line.contains("version")){
						String ver = line.substring(line.indexOf(":")+1, line.length());
						geniisys.setVersion(ver.trim());
						log.info("Version: "+ ver);
					} else if (line.contains("releaseDate")){
						String releaseDate = line.substring(line.indexOf(":")+1, line.length());
						geniisys.setReleaseDate(releaseDate.trim());
						log.info(releaseDate);
					}
			    }
			}					
		} else {
			log.info("Version file is missing");
		}
		
		return geniisys;
	}


}
