package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACInquiryDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACInquiryDAOImpl implements GIACInquiryDAO{

	private SqlMapClient sqlMapClient;	
	private Logger log = Logger.getLogger(GIACInputVatDAOImpl.class);
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	@Override
	public String giacs070WhenNewFormInstance() throws SQLException {
		log.info("GIACS070 when new form instance...");
		return (String) this.sqlMapClient.queryForObject("giacs070WhenNewFormInstance");
	}
	
	public Integer getOpInfoGiacs070(Integer tranId) throws SQLException{
		log.info("Getting OP Info for TranId " + tranId);
		return (Integer) this.sqlMapClient.queryForObject("getOpInfoGiacs070", tranId);
	}
	
	public Integer chkPaytReqDtl (Integer tranId) throws SQLException{
		return (Integer) this.sqlMapClient.queryForObject("chkPaytReqDtlGiacs070", tranId);
	}
	
	public Map<String, Object> getDvInfoGiacs070(Map<String, Object> params) throws SQLException{
		log.info("Giacs070 dv_info button...");
		this.sqlMapClient.update("getDvInfoGiacs070", params);
		return params;
	}
	@Override
	public String validateFundCdGiacs240(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateFundCd", params);
	}
	
	@Override
	public String validateBranchCdGiacs240(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateBranchCdGiacs240", params);
	}
	
	@Override
	public String validatePayeeClassCdGiacs240(String payeeClassCd) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validatePayeeClassCdGiacs240", payeeClassCd);
	}
	@Override
	public Map<String, Object> validatePayeeNoGiacs240(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("validatePayeeNoGiacs240", params);
		return params;
	}
	
	@Override
	public Map<String, Object> getDvAmount(Map<String, Object> params)throws SQLException {
		List<?> list = this.getSqlMapClient().queryForList("getDvAmount", params);
		params.put("list", list);
		return params;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getGiacs211BillDetails(Map<String, Object> params) throws SQLException { // andrew - 08042015 - SR 19643
		Map<String, Object> invoice = (Map<String, Object>) this.getSqlMapClient().queryForObject("getGiacs211BillDetails", params);
		return invoice;
	} 
	
}
