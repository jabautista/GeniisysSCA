package com.geniisys.gipi.pack.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONObject;

import com.geniisys.gipi.pack.dao.GIPIPackWPolnrepDAO;
import com.geniisys.gipi.pack.entity.GIPIPackWPolnrep;
import com.geniisys.gipi.pack.service.GIPIPackWPolnrepService;

public class GIPIPackWPolnrepServiceImpl implements GIPIPackWPolnrepService{
	
	/** The gipiPackWpolnrep DAO*/
	private GIPIPackWPolnrepDAO gipiPackWPolnrepDAO;
	
	/** The log */
	private static Logger log = Logger.getLogger(GIPIPackPARListServiceImpl.class);

	
	@Override
	public List<GIPIPackWPolnrep> getGipiPackPolnrep(Integer packParId)
			throws SQLException {
		return this.getGipiPackWPolnrepDAO().getGipiPackPolnrep(packParId);
	}


	public void setGipiPackWPolnrepDAO(GIPIPackWPolnrepDAO gipiPackWPolnrepDAO) {
		this.gipiPackWPolnrepDAO = gipiPackWPolnrepDAO;
	}


	public GIPIPackWPolnrepDAO getGipiPackWPolnrepDAO() {
		return gipiPackWPolnrepDAO;
	}


	@Override
	public Map<String, String> isGipiPackWPolnrepExist(Integer packParId)
			throws SQLException {
		return this.getGipiPackWPolnrepDAO().isGipiPackWPolnrepExist(packParId);
	}


	@Override
	public String checkPackPolicyForRenewal(GIPIPackWPolnrep gipiPackWPolnrep, String polFlag) throws SQLException {
		log.info("Retrieving old pack_policy_id...");
		Map<String, Object> resultMap = this.getGipiPackWPolnrepDAO().checkPackPolicyForRenewal(gipiPackWPolnrep, polFlag);
		//return resultMap.get("message").toString();
		return new JSONObject(resultMap).toString();
	}

}
