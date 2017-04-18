/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIPolbasicDAO;
import com.geniisys.gipi.entity.GIPIPolbasic;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIPolbasicDAOImpl.
 */
public class GIPIPolbasicDAOImpl implements GIPIPolbasicDAO{
	
	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIPolbasicDAOImpl.class);

	/**
	 * Gets the sql map client.
	 * 
	 * @return the sql map client
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/**
	 * Sets the sql map client.
	 * 
	 * @param sqlMapClient the new sql map client
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIPolbasicDAO#getRefOpenPolNo(java.util.Map)
	 */
	@Override
	public String getRefOpenPolNo(Map<String, Object> params)
			throws SQLException {
		log.info("Getting reference policy number...");
		String refOpenPolNo = (String) this.getSqlMapClient().queryForObject("getRefOpenPolNo", params);
		return refOpenPolNo;
	}

	/* (non-Javadoc)
	 * @see com.seer.framework.db.GenericDAO#delete(com.seer.framework.util.Entity)
	 */
	@Override
	public void delete(GIPIPolbasic object) {
		// 		
	}

	/* (non-Javadoc)
	 * @see com.seer.framework.db.GenericDAO#findAll()
	 */
	@Override
	public List<GIPIPolbasic> findAll() {
		return null;
	}

	/* (non-Javadoc)
	 * @see com.seer.framework.db.GenericDAO#findById(java.lang.Object)
	 */
	@Override
	public GIPIPolbasic findById(Object id) {		
		return null;
	}

	/* (non-Javadoc)
	 * @see com.seer.framework.db.GenericDAO#save(com.seer.framework.util.Entity)
	 */
	@Override
	public void save(GIPIPolbasic object) {
		//		
	}

	@SuppressWarnings({ "unchecked", "unused" })
	@Override
	public List<GIPIPolbasic> getPolbasicForOpenPolicy(String linecd,
			Integer assdNo, String inceptionDate, String expiryDate)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", linecd);
		params.put("assdNo", assdNo);
		params.put("inceptDate", inceptionDate);
		params.put("expiryDate", expiryDate);
		System.out.println("DAO -- assdNo: "+assdNo);
		System.out.println("DAO -- lineCd: "+linecd);
		System.out.println("DAO -- inceptDate: "+inceptionDate);
		System.out.println("DAO -- expiryDate: "+expiryDate);
		List<GIPIPolbasic> pol = this.getSqlMapClient().queryForList("getPolbasicForOpenPolicy", params);
		for (GIPIPolbasic bas : pol){
			System.out.println("op1: "+bas.getSublineCd());
			System.out.println("op2: "+bas.getPolSeqNo());
		}
		if (pol == null){
			System.out.println("pol is null");
		}
		return pol;
	}

	@Override
	public Date extractExpiryDate(int parId) throws SQLException {		
		return (Date)this.getSqlMapClient().queryForObject("extractExpiryDate", parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIPolbasicDAO#getBackEndtEffectivityDate(int, int)
	 */
	@Override
	public String getBackEndtEffectivityDate(int parId, int itemNo)
			throws SQLException {		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("itemNo", itemNo);		
		return (String)this.getSqlMapClient().queryForObject("getBackEndtEffDate", params);
	}

	@Override
	public GIPIPolbasic getPolicyDetails(Map<String, Object> params)
			throws SQLException {
		log.info("Getting policy details...");
		System.out.println("parId: "+params.get("parId"));
		System.out.println("packPol: "+params.get("packPol"));
		return (GIPIPolbasic) this.getSqlMapClient().queryForObject("getPolicyDetails", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPolbasic> getEndtPolicy(int parId) throws SQLException {
		
		log.info("DAO - Retrieving Endt Policy...");
		List<GIPIPolbasic> endtPolicy = this.getSqlMapClient().queryForList("getEndtPolicy", parId);
		log.info("DAO - Endt Policy retrieved...");
		
		return endtPolicy;
	}

	@Override
	public Integer getExtractId() throws SQLException {
		log.info("Getting extract id...");
		Integer extractId = (Integer) this.getSqlMapClient().queryForObject("getExtractId");
		log.info("New extract id is "+extractId+".");
		return extractId;
	}

	@Override
	public void populateGixxTables(Map<String, Object> params)
			throws SQLException {
		Integer policyId = (Integer) params.get("policyId");
		log.info("Populating gixx tables for policyId "+policyId+"...");
		System.out.println("Populating gixx tables for policyId "+policyId);
		this.getSqlMapClient().queryForObject("populateGixxTables", params);
	}

	@Override
	public void populatePackGixxTables(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().queryForObject("populatePackGixxTables", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIPolbasicDAO#getAddressForNewEndtItem(java.util.Map)
	 */
	@Override
	public Map<String, Object> getAddressForNewEndtItem(
			Map<String, Object> params) throws SQLException {		
		log.info("Retrieving address for new endt ...");
		log.info(params.toString());
		this.getSqlMapClient().update("getNewEndtAddress", params);
		log.info(params.toString());
		log.info("Address retrieved ...");		
		return params;
	}

	@Override
	public void updatePrintedCount(Map<String, Object> params) throws SQLException {
		log.info("Updating print count in GIPI_POLBASIC... " + params.toString());
		this.getSqlMapClient().queryForObject("updatePrintedCount", params);
	}

	@Override
	public void populateGixxTableWPolDoc(Map<String, Object> params)
			throws SQLException {
		Integer parId = (Integer) params.get("parId");
		log.info("Populating gixx tables for policyId "+parId+"...");
		this.getSqlMapClient().queryForObject("populateGixxTableWPolDoc", params);
	}
	
	@Override
	public void populatePackGixxTableWPolDoc(Map<String, Object> params)
			throws SQLException {
		Integer packParId = (Integer) params.get("packParId");
		log.info("Populating gixx tables for policyId "+packParId+"...");
		this.getSqlMapClient().queryForObject("populatePackGixxTableWPolDoc", params);
	}

	@Override
	public String checkClaim(Map<String, Object> params) throws SQLException {
		System.out.println(params.get("premSeqNo") + " " + params.get("issCd"));
		return this.getSqlMapClient().queryForObject("checkClaim", params).toString();
	}

	@Override
	public Integer getMaxEndtItemNo(Map<String, Object> params)
			throws SQLException {
		log.info("Getting maximum endt item no....");
		Integer maxNo = (Integer) this.getSqlMapClient().queryForObject("getMaxEndtItemNo", params);
		log.info("Max no = "+maxNo);
		return maxNo;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPolbasic> getEndtPolicyCA(int parId) throws SQLException {
		log.info("DAO - Retrieving Endt Policy for Casualty...");
		List<GIPIPolbasic> gipiPolbasicList = this.getSqlMapClient().queryForList("getEndtPolicyCA", parId);
		log.info("DAO - Endt Policy for Casualty retrieved...");
		return gipiPolbasicList;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPolbasic> getEndtPolicyAC(int parId) throws SQLException {
		log.info("DAO - Retrieving Endt Policy for Accident ...");
		List<GIPIPolbasic> gipiPolbasicList = this.getSqlMapClient().queryForList("getEndtPolicyAC", parId);
		log.info("DAO - Endt Policy for Accident retrieved ...");
		return gipiPolbasicList;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPolbasic> getPolicyForEndt(Map<String, String> params) throws SQLException {
		log.info("DAO - Retrieving Endt Policies for Endorsement...");
		//List<GIPIPolbasic> policyList = this.getSqlMapClient().queryForList("getPolicyForEndt", lineCd, issCd, sublineCd);
		List<GIPIPolbasic> policyList = this.getSqlMapClient().queryForList("getPolicyForEndt", params);
		log.info("DAO - " + policyList.size() + " record/s retrieved...");
		return policyList;
	}

	@Override
	public String isPolExist(Map<String, Object> params) throws SQLException {
		log.info("Checking if policy exists...");
		return (String) this.getSqlMapClient().queryForObject("isPolExist", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPolbasic> getPolicyListing(Map<String, Object> params) throws SQLException {
		log.info("Getting policy listing for "+params.get("userId")+"...");
		log.info("userId: "+params.get("userId"));
		log.info("lineCd: "+params.get("lineCd"));
		log.info("sublineCd: "+params.get("sublineCd"));
		log.info("issCd: "+params.get("issCd"));
		return this.getSqlMapClient().queryForList("getPolicyListing", params) ;
	}

	@Override
	public String getBillNotPrinted(Map<String, Object> params)
			throws SQLException {
		log.info("Checking if bill can be printed...");
		return (String) this.getSqlMapClient().queryForObject("getBillNotPrinted", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIPolbasicDAO#getGipdLineCdLov(java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPolbasic> getGipdLineCdLov(String keyword) throws SQLException {
		return this.getSqlMapClient().queryForList("getGipdLineCdLov", keyword);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<HashMap<String, Object>> getPolicyInformation(Map<String, Object> params) throws SQLException {
		log.info("Loading list of policies...");
		return this.getSqlMapClient().queryForList("getPolBasicForViewPolicyInformation", params);
		
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPolbasic> getRelatedPolicies(Map<String, Object> params)throws SQLException {
		return this.getSqlMapClient().queryForList("getRelatedPoliciesForViewPolicyInformation", params);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getPolicyMainInformation(Integer policyId)throws SQLException {
		return (HashMap<String, Object>) this.getSqlMapClient().queryForObject("getPolMainInfo",policyId);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getPolicyBasicInformation(Integer policyId) throws SQLException {
		return (HashMap<String, Object>) this.getSqlMapClient().queryForObject("getPolBasicInfo", policyId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getPolicyBasicInformationSu(Integer policyId)throws SQLException {
		return (HashMap<String, Object>) this.getSqlMapClient().queryForObject("getPolBasicInfoSu",policyId);
	}

	@Override
	public GIPIPolbasic getBankPaymentDtl(Integer policyId) throws SQLException {
		return (GIPIPolbasic) this.getSqlMapClient().queryForObject("getBankPaymentDtl",policyId);
	}

	@Override
	public GIPIPolbasic getBancassuranceDtl(Integer policyId)throws SQLException {
		return (GIPIPolbasic) this.getSqlMapClient().queryForObject("getBancassuranceDtl", policyId);
	}

	@Override
	public GIPIPolbasic getPlanDtl(Integer policyId) throws SQLException {
		return (GIPIPolbasic) this.getSqlMapClient().queryForObject("getPlanDtl",policyId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getPolicyEndtSeq0(Integer policyId) throws SQLException {
		return (HashMap<String, Object>) this.getSqlMapClient().queryForObject("getPolicyEndtSeq0", policyId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPolbasic> getPolicyListByAssured(HashMap<String, Object> params) throws SQLException {
		return this.sqlMapClient.queryForList("getPolicyPerAssured", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPolbasic> getPolicyListByObligee(HashMap<String, Object> params) throws SQLException {
		return this.sqlMapClient.queryForList("getPolicyObligeeList", params);
	}
	
	

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPolbasic> getPolicyRenewals(HashMap<String, Object> params)	throws SQLException {
		return this.getSqlMapClient().queryForList("getPolicyRenewals",params);
	}
	
	@SuppressWarnings("unchecked")
	public List<GIPIPolbasic> getEndtCancellationLOV(GIPIPolbasic polbasic) throws SQLException {
		return this.getSqlMapClient().queryForList("getEndtCancellationLOV", polbasic);
	}
	
	@SuppressWarnings("unchecked")
	public List<GIPIPolbasic> getEndtCancellationLOV2(GIPIPolbasic polbasic) throws SQLException {
		return this.getSqlMapClient().queryForList("getEndtCancellationLOV2", polbasic);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPolbasic> getPolicyListingForCertPrinting(
			Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getPolicyListingForCertPrinting", params);
	}

	@Override
	public List<GIPIPolbasic> getEndtPolicyFI(int parId) throws SQLException {
		log.info("DAO - Retrieving Endt Policy - Fire ...");
		@SuppressWarnings("unchecked")
		List<GIPIPolbasic> gipiPolbasicList = this.getSqlMapClient().queryForList("getEndtPolicyFI", parId);
		log.info("DAO - Endt Policy - Fire retrieved ...");
		return gipiPolbasicList;
	}

	@Override
	public List<GIPIPolbasic> getEndtPolicyMC(int parId) throws SQLException {
		log.info("DAO - Retrieving Endt Policy - Motorcar ...");
		@SuppressWarnings("unchecked")
		List<GIPIPolbasic> gipiPolbasicList = this.getSqlMapClient().queryForList("getEndtPolicyMC", parId);
		log.info("DAO - Endt Policy - Motorcar retrieved ...");
		return gipiPolbasicList;
	}

	@Override
	public List<GIPIPolbasic> getEndtPolicyMN(int parId) throws SQLException {
		log.info("DAO - Retrieving Endt Policy - Marine Cargo ...");
		@SuppressWarnings("unchecked")
		List<GIPIPolbasic> gipiPolbasicList = this.getSqlMapClient().queryForList("getEndtPolicyMN", parId);
		log.info("DAO - Endt Policy - Marine Cargo retrieved ...");
		return gipiPolbasicList;
	}

	@Override
	public List<GIPIPolbasic> getEndtPolicyMH(int parId) throws SQLException {
		log.info("DAO - Retrieving Endt Policy - Marine Hull ...");
		@SuppressWarnings("unchecked")
		List<GIPIPolbasic> gipiPolbasicList = this.getSqlMapClient().queryForList("getEndtPolicyMH", parId);
		log.info("DAO - Endt Policy - Marine Hull retrieved ...");
		return gipiPolbasicList;
	}

	@Override
	public List<GIPIPolbasic> getEndtPolicyAV(int parId) throws SQLException {
		log.info("DAO - Retrieving Endt Policy - Aviation ...");
		@SuppressWarnings("unchecked")
		List<GIPIPolbasic> gipiPolbasicList = this.getSqlMapClient().queryForList("getEndtPolicyAV", parId);
		log.info("DAO - Endt Policy - Aviation retrieved ...");
		return gipiPolbasicList;
	}

	@Override
	public List<GIPIPolbasic> getEndtPolicyEN(int parId) throws SQLException {
		log.info("DAO - Retrieving Endt Policy - Engineering ...");
		@SuppressWarnings("unchecked")
		List<GIPIPolbasic> gipiPolbasicList = this.getSqlMapClient().queryForList("getEndtPolicyEN", parId);
		log.info("DAO - Endt Policy - Engineering retrieved ...");
		return gipiPolbasicList;
	}
	/**
	 * @author rey
	 * @date 07-19-2011
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPolbasic> getPolicyListByEndorsementType(HashMap<String, Object> params) throws SQLException {
		System.out.println("DAO POLICY ENDORSEMENT TYPE");
		System.out.println(params);
		//return this.sqlMapClient.queryForList("getPolicyPerEndorsementType", params);
		return this.sqlMapClient.queryForList("getGIPIS100EndorsementCode", params);
	}

	@Override
	public Map<String, Object> getValidRefPolNo(Map<String, Object> params)
			throws SQLException {
		log.info("Getting valid ref pol no...");
		this.getSqlMapClient().update("retrieveRefPolNo", params);
		return params;
	}
	/**
	 * @author rey
	 * @date 07-29-2011
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPolbasic> getBillTaxListDAO(Integer policyId)
			throws SQLException {
		log.info("Getting Bill Tax List...");
		return this.sqlMapClient.queryForList("getBillTaxList", policyId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIPolbasicDAO#getPolicyNo(java.lang.Integer)
	 */
	@Override
	public String getPolicyNo(Integer policyId) throws SQLException {
		return (String)this.getSqlMapClient().queryForObject("getPolicyNo", policyId);
	}
	/**
	 * @author rey
	 * @date 08.04.2011
	 * bill peril list
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPolbasic> getBillPerilListDAO(HashMap<String, Object> params)
			throws SQLException {
		log.info("Getting Bill Peril List...");
		return this.sqlMapClient.queryForList("getBillPerilList", params);
	}
	/**
	 * @author rey
	 * @date 08.05.2011
	 * payment schedule
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPolbasic> getPaymentScheduleDAO(
			HashMap<String, Object> params) throws SQLException {
		log.info("Getting Payment Schedule...");
		return this.sqlMapClient.queryForList("getPaymentSchedule", params);
	}
	/**
	 * @author rey
	 * @date 08.05.2011
	 * invoice commission
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPolbasic> getInvoiceCommissionDAO(
			HashMap<String, Object> params) throws SQLException {
		log.info("Getting Invoice Commission...");
		return this.sqlMapClient.queryForList("getInvoiceCommission", params);
	}
	/**
	 * @author rey
	 * @date 08.08.2011
	 * commission details
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPolbasic> getCommissionDetailsDAO(
			HashMap<String, Object> params) throws SQLException {
		log.info("Getting Commission Details...");
		return this.sqlMapClient.queryForList("getCommissionDetails", params);
	}
	/**
	 * @author rey
	 * @date 08.09.2011
	 * policy discount/surcharge list
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPolbasic> getPolicyDiscountDAO(
			HashMap<String, Object> params) throws SQLException {
		log.info("Getting Policy Discount/Surcharge List...");
		return this.sqlMapClient.queryForList("policyDiscountSurchargeList", params);
	}
	/**
	 * @author rey
	 * @date 08.09.2011
	 * item discount surcharge
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPolbasic> getItemDiscountDAO(HashMap<String, Object> params)
			throws SQLException {
		log.info("Getting Item Discount/Surcharge List...");
		return this.sqlMapClient.queryForList("itemDiscountSurchargeList", params);
	}
	/**
	 * @author rey
	 * @date 08.09.2011
	 * peril discount surcharge
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPolbasic> getPerilDiscountDAO(HashMap<String, Object> params)
			throws SQLException {
		log.info("Getting Peril Discount/Surcharge List...");
		return this.sqlMapClient.queryForList("perilDiscountSurchargeList", params);
	}
	/**
	 * @author rey
	 * @date 08.11.2011
	 * policy by assured in account of
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPolbasic> getPolicyByAssuredInAcctOfDAO(
			HashMap<String, Object> params) throws SQLException {
		log.info("Getting Policy By Assured in Account Of List...");
		return this.sqlMapClient.queryForList("getPolicyByAssuredInAcctOf", params);
	}


	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIPolbasicDAO#getPolicyListingForRedistribution(java.util.HashMap)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPolbasic> getPolicyListingForRedistribution(
			HashMap<String, Object> params) throws SQLException {
		log.info("Getting GIPIPolbasic List...");
		return this.getSqlMapClient().queryForList("getPolicyListingForRedistribution", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIPolbasicDAO#executeGIUWS012V370PostQuery(java.util.Map)
	 */
	@Override
	public void executeGIUWS012V370PostQuery(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("executeGIUWS012V370PostQuery", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIPolbasicDAO#checkReinsurancePaymentForRedistribution(java.lang.Integer, java.lang.String)
	 */
	@Override
	public String checkReinsurancePaymentForRedistribution(Integer policyId,
			String lineCd) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("policyId", policyId);
		params.put("lineCd", lineCd);
		this.getSqlMapClient().update("checkReinsurancePaymentForRedistribution", params);
		return (String)params.get("policyStatus");
	}
	/**
	 * @author rey
	 * @date 08.16.2011
	 * bond policy data
	 */
	@Override
	public GIPIPolbasic getBondPolicyDataDAO(
			Integer policyId) throws SQLException {
		log.info("Getting Bond Policy Data...");
		return (GIPIPolbasic) this.sqlMapClient.queryForObject("getBondPolicyData",policyId);
	}
	/**
	 * @author rey
	 * @date 08.16.2011
	 * co signors list
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPolbasic> getCoSignorsDAO(HashMap<String, Object> params)
			throws SQLException {
		log.info("Getting Co Signors List...");
		return this.sqlMapClient.queryForList("getCosignList", params);
	}

	@Override
	public Map<String, Object> getPackDetailsHeader(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("getPackDetailsHeader", params);
		return params;
	}

	@Override
	public Map<String, Object> checkPolicyGICLS026(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("checkPolicyGICLS026", params);
		return params;
	}

	@Override
	public String getRefPolNo(Map<String, Object> params) throws SQLException {
		System.out.println("Retrieving ref pol no for policy: "+params+" / "+(String) this.getSqlMapClient().queryForObject("getRefPolNo", params));
		return (String) this.getSqlMapClient().queryForObject("getRefPolNo", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPolbasic> checkPolicyGiexs006(Map<String, Object> params)
			throws SQLException {
		return this.sqlMapClient.queryForList("checkPolicyGiexs006", params);
	}


	@Override
	public String getEndtTax2GIPIS091(Integer policyId) throws SQLException {
		System.out.println("Retrieving endt tax for policy - "+policyId);
		return (String) this.getSqlMapClient().queryForObject("getEndtTax2Gipis091", policyId);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getPolicyInformation(Integer policyId) throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getPolicyInformation", policyId);
	}

	@Override
	public Integer getPolBondSeqNo(Map<String, Object> params)
			throws SQLException {
		return (Integer) this.sqlMapClient.queryForObject("getPolBondSeqNo", params);
	}

	@Override
	public String getPolicyId(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getPolicyIdFromPolNo", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> checkEndtGiuts008a(Map<String, Object> params)
			throws SQLException {
		return (Map<String, Object>) this.sqlMapClient.queryForObject("checkEndtGiuts008a", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> checkPolicyGuits008a(Map<String, Object> params)
			throws SQLException {
		return (Map<String, Object>) this.sqlMapClient.queryForObject("checkPolicyGiuts008a", params);
	}

	@Override
	public String getRefPolNo2(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getRefPolNo2", params);
	}

	@Override
	public Integer getMainPolicyId(Map<String, Object> params) throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("getMainPolicyId", params);
	}

	@Override
	public Map<String, Object> gipis100ExtractSummary(Map<String, Object> params)
			throws SQLException, Exception {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Params before gipis100PopulateSummaryTabA: "+ params);
			this.getSqlMapClient().update("gipis100PopulateSummaryTabA", params);
			this.getSqlMapClient().executeBatch();
			
			log.info("Params before gipis100PopulateSummaryTabB: "+ params);
			this.getSqlMapClient().update("gipis100PopulateSummaryTabB", params);
			this.getSqlMapClient().executeBatch();
			
			log.info("Extraction successful - "+params);
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}

	@Override
	public String callExtractDistGipis130(Map<String, Object> params) throws SQLException {
		String message = "";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);					
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("callExtractDistGipis130", params);
			this.sqlMapClient.executeBatch();
			
			message = (String) params.get("message");
			System.out.println("callExtractDistGipis130 params: "+params);
			
			this.sqlMapClient.getCurrentConnection().commit();
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override
	public String onLoadSummarizedDist(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("onLoadSummarizedDist", params);
	}

	@Override
	public String insertSummDist(Map<String, Object> params) throws SQLException {
		String message = "";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);					
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("insertSummDist", params);
			this.sqlMapClient.executeBatch();
			
			message = (String) params.get("message");
			System.out.println("insertSummDist params: "+params);
			
			// shan 08.19.2014
			Map<String, Object> p = new HashMap<String, Object>();
			p.put("distNo", params.get("distNo"));
			System.out.println("Deleting master table records of dist_no " + p.toString());
			this.sqlMapClient.delete("delDistMasterTables", p);
			
			p.put("distFlag", "1");
			System.out.println("Updating dist_flag : " + p.toString());
			this.sqlMapClient.update("updateDistFlag", p);
			// end 08.19.2014
			
			this.sqlMapClient.getCurrentConnection().commit();
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getGIPIS156BasicInfo(Map<String, Object> params)
			throws SQLException {
		System.out.println(params);
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getGIPIS156BasicInfo", params);
	}

	@Override
	public void extractVesselAccum(Map<String, Object> params)
			throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);					
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().insert("extractVesselAccum", params);
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public String extractRecapsVI(Map<String, Object> params) throws SQLException {
		String isNotExists = "";
		log.info("Extracting data...");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Extracting recapitulation...");
			this.getSqlMapClient().update("extractRecapsVI", params);
			this.getSqlMapClient().executeBatch();
		
			log.info("Extracting recapitulation social...");
			this.getSqlMapClient().update("extractRecapsVISocial", params);
			this.getSqlMapClient().executeBatch();
		
			log.info("Extracting recapitulation losses...");
			this.getSqlMapClient().update("extractRecapsVILosses", params);
			this.getSqlMapClient().executeBatch();
		
			log.info("Extracting recapitulation detail...");
			this.getSqlMapClient().update("extractRecapsVIDetail", params);
			this.getSqlMapClient().executeBatch();
		
			log.info("Extracting recapitulation loss detail...");
			this.getSqlMapClient().update("extractRecapsVILossDetail", params);
			this.getSqlMapClient().executeBatch();
		
			this.getSqlMapClient().getCurrentConnection().commit();
			log.info("Extraction of data done.");
			
			log.info("Checking for extracted records...");
			isNotExists = (String) this.getSqlMapClient().queryForObject("checkExtractedRecapsVI", params);
			log.info("Has no extracted records? "+ isNotExists);
			
		} catch(SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return isNotExists;
	}

	@Override
	public String checkExtractedRecordsBeforePrint(Map<String, Object> params) throws SQLException{
		return (String) this.getSqlMapClient().queryForObject("checkExtractedRecapsVIBeforePrint", params);
	}
	
	/* benjo 06.01.2015 GENQA AFPGEN_IMPLEM SR 4150 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> checkRecapsVIBeforeExtract(Map<String, Object> params) throws SQLException {
		log.info("Checking records for RecapsVI..."+ params.toString());
		this.sqlMapClient.update("checkRecapsVIBeforeExtract", params);
		return params;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> saveGIPIS175(Map<String, Object> params)
			throws SQLException {
		
		String policyId = (String) params.get("policyId");
		String itemGrp = (String) params.get("itemGrp");
		String itemNo = (String) params.get("itemNo");
		//String perilCd = (String) params.get("perilCd");
		String acctEntDate = (String) params.get("acctEntDate");
		//String riCommRate = (String) params.get("riCommRate");
		String premSeqNo = (String) params.get("premSeqNo");
		String issCd = (String) params.get("issCd");
		String branchCd = (String) params.get("branchCd");
		String userId = (String) params.get("userId");
		String lineCd = (String) params.get("lineCd");
		String riCd = (String) params.get("riCd");
		String prevRiCommAmt = (String) params.get("prevRiCommAmt");
		String oldRiCommVat = (String) params.get("oldRiCommVat"); //removed comment by MarkS SR23053 9.13.2016
		
		List<Map<String, Object>> perilList = (List<Map<String, Object>>) params.get("perilList");
		
		Map<String, Object> preCommitMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("policyId", policyId);
		paramMap.put("itemGrp", itemGrp);
		
		Map<String, Object> updateV490Map = new HashMap<String, Object>();
		Map<String, Object> postCommitMap = new HashMap<String, Object>();
		postCommitMap.put("policyId", policyId);
		postCommitMap.put("itemGrp", itemGrp);
		postCommitMap.put("issCd", issCd);
		postCommitMap.put("premSeqNo", premSeqNo);
		postCommitMap.put("branchCd", branchCd);
		postCommitMap.put("userId", userId);
		postCommitMap.put("lineCd", lineCd);
		postCommitMap.put("riCd", riCd);
		postCommitMap.put("prevRiCommAmt", prevRiCommAmt);
		postCommitMap.put("oldRiCommVat", oldRiCommVat); //removed comment by MarkS SR23053 9.13.2016
		postCommitMap.put("acctEntDate", acctEntDate);
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			if(acctEntDate != "" && acctEntDate != null){
				preCommitMap.put("policyId", policyId);
				preCommitMap.put("itemGrp", itemGrp);
				
				this.getSqlMapClient().update("gipis175PreCommit", preCommitMap);
				this.getSqlMapClient().executeBatch();
			}
			
			postCommitMap.put("prevRiCommAmt", preCommitMap.get("prevRiCommAmt"));
						
			for(int x = 0; x < perilList.size(); x++){
				this.getSqlMapClient().update("gipis175PopRiCommVat", perilList.get(x));
				this.getSqlMapClient().executeBatch();
				System.out.println("perilList : " + perilList.get(x));
			}
			
			for(int x = 0; x < perilList.size(); x++){
				this.getSqlMapClient().update("gipis175InsertHist", perilList.get(x));
				this.getSqlMapClient().executeBatch();
				System.out.println("perilList insert Hist : " + perilList.get(x));
			}
			
			updateV490Map.put("coInsuranceSw", params.get("coInsuranceSw"));
			updateV490Map.put("policyId", policyId);
			updateV490Map.put("itemNo", itemNo);
			/*updateV490Map.put("perilCd", perilCd);
			updateV490Map.put("riCommRate", riCommRate);*/
			updateV490Map.put("itemGrp", itemGrp);
			updateV490Map.put("premSeqNo", premSeqNo);
			updateV490Map.put("issCd", issCd);
			
			this.getSqlMapClient().update("gipis175UpdateGIPIInvoice", paramMap); // Moved before gipis175UpdateV490 to fix RI comm amount issue in SR 22146 - Jerome 05.12.2016
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().insert("gipis175UpdateV490", updateV490Map);
			this.getSqlMapClient().executeBatch();
			
			postCommitMap.put("sumRiCommVat", paramMap.get("sumRiCommVat"));
			postCommitMap.put("sumRiCommAmt", paramMap.get("sumRiCommAmt"));
						
			if(acctEntDate != "" && acctEntDate != null){
				System.out.println("acctEntDate IS NOT NULL");
				System.out.println("acctEntDate : " + acctEntDate);
				this.getSqlMapClient().update("gipis175PostCommit", postCommitMap);
				this.getSqlMapClient().executeBatch();
			}
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch(SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		
		return null;
	}

	@Override
	public void extractCasualtyAccum(Map<String, Object> params)
			throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);					
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().insert("extractCasualtyAccum", params);
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public void extractBlockAccum(Map<String, Object> params)
			throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);					
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().insert("extractBlockAccum", params);
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public String gipis110CheckFiAccess(String userId) throws SQLException {
		return (String) getSqlMapClient().queryForObject("gipis110CheckFiAccess",userId);
	}

	@Override
	public String gipis191ExtractRiskCategory(Map<String, Object> params)
			throws SQLException {
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);					
			this.getSqlMapClient().startBatch();
			
			System.out.println("PARAMS");
			System.out.println(params);
			
			this.getSqlMapClient().update("gipis191ExtractRiskCategory", params);
			this.sqlMapClient.executeBatch();
			
			this.sqlMapClient.getCurrentConnection().commit();
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		
		return (String) params.get("noOfRecs");
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getGIPIS191Params(String userId) throws SQLException {
		return (Map<String, Object>)this.getSqlMapClient().queryForObject("getGIPIS191Params", userId);
	}
	
	@Override
	public Map<String, Object> validateGIPIS201Access(Map<String, Object> params)
			throws SQLException {
		HashMap<String, Object> param = new HashMap<String, Object>();	
		param.put("lineCd", (String) params.get("lineCd"));		
		param.put("issCd", (String) params.get("issCd"));
		param.put("userId", (String) params.get("userId"));
		param.put("result", this.sqlMapClient.queryForObject("validateGIPIS201Access",param));
		return param;
	}
	
	@Override
	public Map<String, Object> validateGIPIS201DisplayORC() throws SQLException {
		HashMap<String, Object> param = new HashMap<String, Object>();	
		param.put("result", this.sqlMapClient.queryForObject("validateGIPIS201DisplayORC",param));
		return param;
	}	
	
	@Override
	public Map<String, Object> checkViewProdDtls(
			Map<String, Object> params) throws SQLException {
		log.info("Checking Production Param:  "+params.toString());		
		this.sqlMapClient.update("checkViewProdDtls", params);
		return params;
	}
	
	@Override
	public Map<String, Object> extractProduction(
			Map<String, Object> params) throws SQLException {	
		log.info("Extracting GIPI Production Param:  "+params.toString());
		this.sqlMapClient.update("extractProduction", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getEndtPolicyDates(Integer parId) throws SQLException {
		return (Map<String, Object>) this.sqlMapClient.queryForObject("getEndtPolicyDates", parId);
	}
	
	/*
	 * Added by: hdrtagudin
	 * Date: 07302015
	 * SR No.: 19751
	 */
	public String getIssCdRI() throws SQLException{
		return (String) this.sqlMapClient.queryForObject("getIssCdRI");
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getInitialAcceptance(Integer policyId) throws SQLException{	
		return (Map<String, Object>) this.sqlMapClient.queryForObject("getInitialAcceptance", policyId);
	} 
	
	public Integer getParId(String policyId) throws SQLException {
		return (Integer) this.sqlMapClient.queryForObject("getParId", policyId);
	}
}