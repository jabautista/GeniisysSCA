package com.geniisys.giac.dao;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.entity.GIACParameter;

public interface GIACParameterDAO {

	public GIACParameter getParamValueV(String paramName) throws SQLException;
	
	public String getParamValueV2(String paramName) throws SQLException;
		 
	public Integer getParamValueN(String paramName1) throws SQLException;
	 
	public List<GIACParameter> getParamValues(String paramName) throws SQLException;
	
	String getGlobalBranchCdByUserId(String paramName)
			throws SQLException; 
	
	//shan 11.25.2013
	void saveGiacs301(Map<String, Object> params) throws SQLException;
	void valDeleteRec(String paramName) throws SQLException;
	void valAddRec(String paramName) throws SQLException;
	
	//john 10.23.2014
	public BigDecimal getParamValueN2(String paramName1) throws SQLException;
}
