/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	gzelle
 * Create Date	:	02.15.2013
 ***************************************************/
package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gicl.dao.GICLClaimListingInquiryDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLClaimListingInquiryDAOImpl implements GICLClaimListingInquiryDAO {
	
	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	@Override
	public String validateColorPerColor(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateColorPerColor", params);
	}

	@Override
	public String validateBasicColorPerColor(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateBasicColorPerColor", params);
	}

	@Override
	public String validatePayeePerAdjuster(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validatePayeePerAdjuster", params);
	}

	@Override
	public String validateCargoClassPerCargoClass(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateCargoClassPerCargoClass", params);
	}
	
	@Override
	public String validateDistrictPerBlock(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateDistrictPerBlock", params);
	}

	@Override
	public String validateBlockPerBlock(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateBlockPerBlock", params);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getBlockByDistrictNo(Map<String, Object> params) 
			throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getBlockByDistrictNo", params);
	}
	
	@Override
	public String validateCargoTypePerCargoClass(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateCargoTypePerCargoClass", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> fetchCorrespondingCargoTypeBasedOnClassCd(Map<String, Object> params) 
			throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("fetchCorrespondingCargoTypeBasedOnClassCd", params);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Integer> fetchValidCargo(Map<String, Object> params) 
			throws SQLException {
		return (List<Integer>) this.getSqlMapClient().queryForList("fetchValidCargo", params);
	}

	@Override
	public String validateMotorshop(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateMotorshop", params);
	}

	@Override
	public String validateLineCdByLineName(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateLineCdByLineName", params);
	}

	@Override
	public String validateLossCatDescPerLineCd(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateLossCatDescPerLineCd", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> fetchValidLossCatDesc(Map<String, Object> params)
			throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("fetchValidLossCatDesc", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<String> fetchValidLineCd(Map<String, Object> params)
			throws SQLException {
		return (List<String>) this.getSqlMapClient().queryForList("fetchValidLineCd", params);
	}

	@Override
	public String validatePayees(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validatePayees", params);
	}

	@Override
	public String validatePayeeClass(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validatePayeeClass", params);
	}
	
	@Override
	public String validateDocNumber(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateDocNumber", params);
	}

	@Override
	public String validateLawyer(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateLawyer", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<String> fetchValidThirdParty(Map<String, Object> params)
			throws SQLException {
		return (List<String>) this.getSqlMapClient().queryForList("fetchValidThirdParty", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<String> validateClassPerClass(Map<String, Object> params)
			throws SQLException {
		return (List<String>) this.getSqlMapClient().queryForList("validateClassPerClass", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<String> validatePayeePerClassCd(Map<String, Object> params)
			throws SQLException {
		return (List<String>) this.getSqlMapClient().queryForList("validatePayeePerClassCd", params);
	}

	@Override
	public String validateGICLS278Field(Map<String, Object> params) throws SQLException {
		String value = (String) params.get("value");
		String query = "validateGICLS278" + (String) params.get("field");
		return (String) this.getSqlMapClient().queryForObject(query, value);
	}

	@Override
	public String validateGICLS278Entries(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateGICLS278Entries", params);
	}
	
	public Map<String, Object> populateGicls256Totals(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("populateGicls256Totals", params);
		return params;
	}
	
	public Map<String, Object> validateGicls277PayeeName(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateGicls277PayeeName", params);
		return params;
	}
}
