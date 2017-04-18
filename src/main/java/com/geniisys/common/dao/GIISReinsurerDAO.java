package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.entity.CGRefCodes;
import com.geniisys.common.entity.GIISReinsurer;

public interface GIISReinsurerDAO {

	/**
	 * Gets all records of GIIS_REINSURER
	 * @param keyword
	 * @return
	 * @throws SQLException
	 */
	List<GIISReinsurer> getGiisReinsurerList(String keyword) throws SQLException;
	
	String getInputVatRate(String riCd) throws SQLException;
	
	GIISReinsurer getGiisReinsurerByRiCd(Integer riCd) throws SQLException;
	
	/**
	 * Check the Binder Id of GIIS_REINSURER if it is existing
	 * @return
	 * @throws SQLException
	 */
	public String checkIfBinderExist(Map<String, Object> params) throws SQLException;	//added by steven 5.17.2012
	
	public String getReinsurerName(String riCd) throws SQLException; //added by shan 7.2.2013
	List<CGRefCodes> getRIBaseList() throws SQLException;//added by fons 9.16.2013
	Map<String, Object> validateGIISS030MobileNo (Map<String, Object> params) throws SQLException;
	Map<String, Object> getGIISS030MaxRiCd() throws SQLException;
	void valAddRec(String recId) throws SQLException;
	void saveGiiss030(Map<String, Object> params) throws SQLException;
}
