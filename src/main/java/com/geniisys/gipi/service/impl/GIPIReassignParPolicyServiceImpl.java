package com.geniisys.gipi.service.impl;

import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIReassignParPolicyDAO;
import com.geniisys.gipi.service.GIPIReassignParPolicyService;

public class GIPIReassignParPolicyServiceImpl implements GIPIReassignParPolicyService {

	private static Logger log = Logger.getLogger(GIPIReassignParPolicyService.class);
	
	private GIPIReassignParPolicyDAO gipiReassignParPolicyDAO;

	/**
	 * @return the gipiReassignParPolicyDAO
	 */
	public GIPIReassignParPolicyDAO getGipiReassignParPolicyDAO() {
		return gipiReassignParPolicyDAO;
	}

	/**
	 * @param gipiReassignParPolicyDAO the gipiReassignParPolicyDAO to set
	 */
	public void setGipiReassignParPolicyDAO(GIPIReassignParPolicyDAO gipiReassignParPolicyDAO) {
		this.gipiReassignParPolicyDAO = gipiReassignParPolicyDAO;
	}

	@Override
	public boolean saveReassignParPolicy(Map<String, Object> parameters)
			throws Exception {
		log.info("Saving Reassign Par Policy...");
		this.getGipiReassignParPolicyDAO().saveReassignParPolicy(parameters);
		log.info("Reassign Par Policy. Saved.");
		return true;
	}

}
