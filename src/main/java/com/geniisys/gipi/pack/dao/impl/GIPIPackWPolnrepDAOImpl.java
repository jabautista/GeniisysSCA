package com.geniisys.gipi.pack.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.pack.dao.GIPIPackWPolnrepDAO;
import com.geniisys.gipi.pack.entity.GIPIPackWPolnrep;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIPackWPolnrepDAOImpl implements GIPIPackWPolnrepDAO{
	
	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIPackWPolnrepDAOImpl.class);

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPackWPolnrep> getGipiPackPolnrep(Integer packParId)
			throws SQLException {
		log.info("Retrieving GIPI_PACK_WPOLGENIN records for " + packParId);
		List<GIPIPackWPolnrep> gipiPackWPolnrepList = this.getSqlMapClient().queryForList("getGipiPackWPolnrep", packParId);
		log.info(gipiPackWPolnrepList.size() + " record/s found in GIPI_PACK_WPOLGENIN");
		return gipiPackWPolnrepList;
	}

	@Override
	public Map<String, String> isGipiPackWPolnrepExist(Integer packParId)
			throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("packParId", packParId.toString());
		this.getSqlMapClient().update("isGipiPackWPolnrepExist", params);
		return params;
	}

	@Override
	public Map<String, Object> checkPackPolicyForRenewal(
			GIPIPackWPolnrep gipiPackWPolnrep, String polFlag) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("packParId", gipiPackWPolnrep.getParId());
		params.put("lineCd", gipiPackWPolnrep.getLineCd());
		params.put("sublineCd", gipiPackWPolnrep.getSublineCd());
		params.put("issCd", gipiPackWPolnrep.getIssCd());
		params.put("issueYy", gipiPackWPolnrep.getIssueYy());
		params.put("polSeqNo", gipiPackWPolnrep.getPolSeqNo());
		params.put("renewNo", gipiPackWPolnrep.getRenewNo());
		params.put("polFlag", polFlag);
		
		this.getSqlMapClient().update("checkPackPolicyForRenewal", params);
		log.info("old pack_policy_id retrieved. - "+params);
		return params;
	}
}
