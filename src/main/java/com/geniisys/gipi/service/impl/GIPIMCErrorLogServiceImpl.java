/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIMCErrorLogDAO;
import com.geniisys.gipi.entity.GIPIMCErrorLog;
import com.geniisys.gipi.service.GIPIMCErrorLogService;


/**
 * The Class GIPIMCErrorLogServiceImpl.
 */
public class GIPIMCErrorLogServiceImpl implements GIPIMCErrorLogService {

	/** The gipi mc error log dao. */
	private GIPIMCErrorLogDAO gipiMCErrorLogDAO;
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIMCErrorLogService#getGipiMCErrorList(java.lang.String)
	 */
	@Override
	public List<GIPIMCErrorLog> getGipiMCErrorList(String fileName) throws SQLException {
		return this.getGipiMCErrorLogDAO().getGipiMCErrorList(fileName);
	}

	/**
	 * Sets the gipi mc error log dao.
	 * 
	 * @param gipiMCErrorLogDAO the new gipi mc error log dao
	 */
	public void setGipiMCErrorLogDAO(GIPIMCErrorLogDAO gipiMCErrorLogDAO) {
		this.gipiMCErrorLogDAO = gipiMCErrorLogDAO;
	}

	/**
	 * Gets the gipi mc error log dao.
	 * 
	 * @return the gipi mc error log dao
	 */
	public GIPIMCErrorLogDAO getGipiMCErrorLogDAO() {
		return gipiMCErrorLogDAO;
	}

	@Override
	public JSONObject getGipiMCErrorList2(HttpServletRequest request) throws SQLException,
			JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGipiMCErrorList2");
		
		String fileName = request.getParameter("fileName");
		String slashType = (fileName.lastIndexOf("\\") > 0) ? "\\" : "/";// Windows or UNIX 
		int lastIndexOfSlash = fileName.lastIndexOf(slashType);		
		params.put("fileName",  fileName.substring(lastIndexOfSlash+1));
		
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(map);
		
		return json;
	}

}
