package com.geniisys.common.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.entity.CGRefCodes;
import com.geniisys.common.entity.GIISReinsurer;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.PaginatedList;

public interface GIISReinsurerService {

	/**
	 * Gets all records of GIIS_REINSURER
	 * @param pageNo
	 * @param keyword
	 * @return
	 * @throws SQLException
	 */
	PaginatedList getGiisReinsurerList(Integer pageNo, String keyword) throws SQLException;
	
	/**
	 * Gets all records of GIIS_REINSURER
	 * @return
	 * @throws SQLException
	 */
	List<GIISReinsurer> getAllGiisReinsurer() throws SQLException;
	
	String getInputVatRate(String riCd) throws SQLException;
	
	GIISReinsurer getGiisReinsurerByRiCd(Integer riCd) throws SQLException;
	
	/**
	 * Check the Binder Id of GIIS_REINSURER if it is existing
	 * @return
	 * @throws SQLException
	 */
	String checkIfBinderExist(Map<String, Object> params) throws SQLException;	//added by steven 5.17.2012
	
	String getReinsurerName(String riCd) throws SQLException;	//added by shan 07.02.2013
	JSONObject showGiiss030 (HttpServletRequest request) throws SQLException, JSONException; //added by fons 9.16.2013
	List<CGRefCodes> getRIBaseList() throws SQLException;
	Map<String, Object> validateGIISS030MobileNo (HttpServletRequest request) throws SQLException;
	Map<String, Object> getGIISS030MaxRiCd () throws SQLException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	void saveGiiss030(HttpServletRequest request, String userId) throws SQLException, JSONException;	
	JSONObject getAllReinsurer(HttpServletRequest request, String userId)throws SQLException, JSONException;
}
