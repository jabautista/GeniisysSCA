package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.giac.dao.GIACCashReceiptsReportDAO;
import com.ibatis.sqlmap.client.SqlMapClient;
import common.Logger;

public class GIACCashReceiptsReportDAOImpl implements GIACCashReceiptsReportDAO{

private Logger log = Logger.getLogger(GIACCashReceiptsReportDAOImpl.class);
	
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}


	@Override
	public String validateGIACS093BranchCd(Map<String, Object> params) throws SQLException{
		log.info("Validating GIACS093 intm no...");
		return (String) this.getSqlMapClient().queryForObject("validateGiacs093BranchCd", params);
	}
	
	@Override
	public Map<String, Object> populateGiacPdc(Map<String, Object> params) throws SQLException {
		log.info("Populating Giac Pdc:  "+params.toString());
		this.sqlMapClient.update("populateGiacPdc", params);
		return params;
	}
	


	@Override
	public String validateGIACS281BankAcctCd(String bankAcctCd)
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("validateGIACS281BankAcctCd", bankAcctCd);
	}


	@Override
	public Map<String, Object> getGIACS078OInitialValues(Map<String, Object> params)throws SQLException {
		log.info("Getting GIACS078 initial date values.... " );
		this.getSqlMapClient().update("getGIACS078InitialValues", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> validateIntmNo(Integer intmNo)throws SQLException {
		log.info("Validating GIACS078 intm no...");
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("validateIntmNoGiacs078", intmNo);
	}

	@Override
	public Map<String, Object> extractGiacs078Records(Map<String, Object> params)throws SQLException {
		log.info("Extracting GIACS078 records...");
		this.getSqlMapClient().update("extractGiacs078Records", params);
		return params;
	}

	@Override
	public Integer countGiacs078ExtractedRecords(Map<String, Object> params) throws SQLException {
		log.info("Fetching extracted records count..");
		return (Integer) this.getSqlMapClient().queryForObject("countGiacs078ExtractedRecords", params);
	}
	
	//john 10.9.2014
	@Override
	public Map<String, Object> getLastExtractParam(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().queryForObject("giacs093LastExtractParams", params);
		return params;
	}

}
