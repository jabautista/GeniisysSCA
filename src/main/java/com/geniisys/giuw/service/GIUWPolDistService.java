package com.geniisys.giuw.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gipi.exceptions.DistributionException;
import com.geniisys.gipi.exceptions.NegateDistributionException;
import com.geniisys.gipi.exceptions.PostingParException;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.giuw.entity.GIUWPolDist;

public interface GIUWPolDistService {

	List<GIUWPolDist> getGIUWPolDist(Integer parId, String moduleId) throws SQLException; // added parameter : shan 05.14.2014
	String checkDistFlag(Integer distNo, Integer distSeqNo) throws SQLException;
	Map<String, Object> compareGipiItemItmperil(Map<String, Object> params) throws SQLException;
	Map<String, Object> compareGipiItemItmperil2(Map<String, Object> params) throws SQLException;
	Map<String, Object> createItems(Map<String, Object> params) throws SQLException;
	Map<String, Object> giuws003NewFormInstance(Map<String, Object> params) throws SQLException;
	Map<String, Object> postDist(Map<String, Object> params, String parameter, GIISUser USER) throws SQLException, JSONException, ParseException;
	Map<String, Object> savePrelimOneRiskDist(String parameter, GIISUser uSER) throws SQLException, JSONException, ParseException;
	List<GIUWPolDist> getGIUWPolDist2(Integer parId) throws SQLException;
	Map<String, Object> createItems2(Map<String, Object> params) throws Exception;
	String saveSetupGroupDist(String parameter, String userId) throws SQLException, JSONException, Exception;
	Map<String, Object> savePrelimOneRiskDistByTsiPrem(String parameter, GIISUser uSER) throws SQLException, JSONException, ParseException;
	Map<String, Object> createItemsGiuws005(Map<String, Object> params) throws SQLException;
	Map<String, Object> postDistGiuw005(Map<String, Object> params, String parameter, GIISUser USER) throws SQLException, JSONException, ParseException;
	List<GIUWPolDist> getGIUWPolDistGiuws013(Map<String, Object> params) throws SQLException;
	List<GIUWPolDist> getGIUWPolDistGiuws016(Map<String, Object> params) throws SQLException;
	Map<String, Object> postDistGiuws013(Map<String, Object> params) throws SQLException, JSONException, ParseException;
	Map<String, Object> saveOneRiskDistGiuws013(String parameter, GIISUser uSER) throws SQLException, JSONException, ParseException;
	List<GIUWPolDist> getGIUWPolDistGiuts002(Map<String, Object> params) throws SQLException;
	Map<String, Object> negDistGiuts002(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkExistingClaimGiuts002(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateFaculPremPaytGIUTS002(Map<String, Object> params) throws SQLException;
	/**
	 * Execute check_dist_flag on giuws003
	 * @param params
	 * @throws SQLException
	 */
	void checkDistFlagGiuws003(Map<String, Object> params) throws SQLException;
	
	/**
	 * Create items on GIUWS003
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	Map<String, Object> createItemsGiuws003(Map<String, Object> params) throws SQLException;
	
	/**
	 * Execute Post Distribution on Preliminary Peril Distribution module
	 * @param params
	 * @param parameter
	 * @param USER
	 * @return
	 * @throws SQLException
	 * @throws JSONException
	 * @throws ParseException
	 */
	Map<String, Object> postDistGiuws003(Map<String, Object> params, String parameter, GIISUser USER) throws SQLException, JSONException, ParseException;
	
	/**
	 * Save prelim peril dist records in GIUWS003
	 * @param parameter
	 * @param uSER
	 * @return
	 * @throws SQLException
	 * @throws JSONException
	 * @throws ParseException
	 */
	Map<String, Object> savePrelimPerilDist(String parameter, GIISUser USER, String isPack) throws SQLException, JSONException, ParseException;
	Map<String, Object> checkDistMenu(HttpServletRequest request, GIISUser USER, ApplicationContext APPLICATIONCONTEXT) throws SQLException;
	Map<String, Object> savePrelimPerilDistByTsiPrem(String parameter, GIISUser USER) throws SQLException, JSONException, ParseException;
	Map<String, Object> createItemsGiuws006(HttpServletRequest request, GIISUser USER) throws SQLException;
	Map<String, Object> postDistGiuws006(HttpServletRequest request, String parameter, GIISUser USER) throws SQLException, JSONException, ParseException;
	String checkIfPosted(Integer distno) throws SQLException;
	List<GIUWPolDist> getPackGIUWPolDist(Integer packParId) throws SQLException;
	List<GIUWPolDist> getGIUWPolDistForPerilDistribution(Integer parId, Integer distNo) throws SQLException;
	
	/**
	 * Save distribution by peril (GIUWS012)
	 * @param parameter
	 * @param USER
	 * @param isPack
	 * @return
	 * @throws SQLException
	 * @throws JSONException
	 * @throws ParseException
	 */
	Map<String, Object> saveDistributionByPeril(String parameter, GIISUser USER) throws SQLException, JSONException, ParseException;
	void showPreliminaryOneRiskDist(HttpServletRequest request, GIPIPARListService gipiParListService) throws SQLException;
	List<GIUWPolDist> getDistByTsiPremPeril(HttpServletRequest request, GIISUser USER) throws SQLException;
	
	/**
	 * Post distribution by peril (GIUWS012)
	 * @param params
	 * @return
	 * @throws SQLException
	 * @throws PostingParException
	 */
	Map<String, Object> postDistGiuws012(Map<String, Object> params) throws SQLException, PostingParException;
	
	void saveDistrByTSIPremGroup(String parameters, GIISUser USER) throws SQLException, Exception, JSONException;
	
	Map<String, Object> postDistGiuws016(Map<String, Object> params) throws SQLException, PostingParException;

	Map<String, Object> saveDistByTsiPremPeril(String parameter, GIISUser USER) throws SQLException, JSONException, ParseException, DistributionException;

	/**
	 * Gets dist flag and batch id of specified policy id and dist no in table GIUW_POL_DIST
	 * @param policyId
	 * @param distNo
	 * @return
	 * @throws SQLException
	 */
	Map<String, Object> getDistFlagAndBatchId(Integer policyId, Integer distNo) throws SQLException;
	
	/**
	 * Gets giuw_pol_dist records for redistribution
	 * @param parId
	 * @param distNo
	 * @return
	 * @throws SQLException
	 */
	List<GIUWPolDist> getGIUWPolDistForRedistribution(Integer parId, Integer distNo) throws SQLException;
	
	/**
	 * Negate distribution in Redistribution (GIUTS021)
	 * @param params
	 * @throws SQLException
	 */
	void negateDistributionGiuts021(Map<String, Object> params) throws SQLException, NegateDistributionException;
	
	/**
	 * Save redistribution (GIUTS021)
	 * @param params
	 * @throws SQLException
	 */
	void saveRedistribution(Map<String, Object> params) throws SQLException;
	
	/**
	 * Ends current running transaction
	 * @throws SQLException
	 */
	void endRedistributionTransaction() throws SQLException;
	
	Map<String, Object> validateExistingDist(Map<String, Object> params) throws SQLException;
	
	/**
	 * Adjust distribution tables upon saving/posting edgar 03/05/2014
	 */
	Map<String, Object> adjustPerilDistTables(Map<String, Object> params) throws SQLException;
	
	/**
	 * Recomputes distribution premium amounts upon saving/posting edgar 04/29/2014
	 */
	Map<String, Object> recomputePerilDistPrem(Map<String, Object> params) throws SQLException;
	
	/**
	 * Compare distribution tables and itemperil table edgar 05/05/2014
	 */
	Map<String, Object> compareWitemPerilToDs(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets the peril type for checking of endorsement edgar 05/05/2014
	 */
	Map<String, Object> getPerilType(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets the expiry date for comparison to effectivity date of policy edgar 05/06/2014
	 */
	Map<String, Object> getTreatyExpiry(Map<String, Object> params) throws SQLException;
	
	/**
	 * Execute deletion of distribution master tables during unposting edgar 05/07/2014
	 */
	Map<String, Object> unpostDist(Map<String, Object> params) throws SQLException;
	
	/**
	 * Recompute and adjust distribution tables with discrepancies edgar 05/07/2014
	 */
	Map<String, Object> recomputeAfterCompare(Map<String, Object> params) throws SQLException;
	
	/**
	 * get takeup term edgar 05/08/2014
	 */
	Map<String, Object> getTakeUpTerm(Map<String, Object> params) throws SQLException;
	
	/**
	 * updates dist_spct1 when distribution is saved in GIUWS003 then navigate to GIUWS006 shan 05.06.2014
	 */	
	public void updateDistSpct1(Integer distNo) throws SQLException;
	
	void updateGIUWS017DistSpct1(HttpServletRequest request) throws SQLException;
	
	Map<String, Object> getPolicyTakeUp(Map<String, Object> params) throws SQLException;
	
	Map<String, Object> comparePolItmperilToDs(Map<String, Object> params) throws SQLException;
	
	/**
	 *  Compare distribution tables and itemperil table for One Risk edgar 05/12/2014
	 */
	Map<String, Object> compareWitemPerilToDsGIUWS004(Map<String, Object> params) throws SQLException;
	
	/**
	 *  Recomputes dist prem amounts when dist_spct1 has value for GIUWS004, GIUWS013 edgar 05/12/2014
	 */
	Map<String, Object> adjustDistPremGIUWS004(Map<String, Object> params) throws SQLException;
	
	/**
	 *  Adjust all working distribution tables for GIUWS004, GIUWS013 edgar 05/12/2014
	 */
	Map<String, Object> adjustAllWTablesGIUWS004(Map<String, Object> params) throws SQLException;
	
	/**
	 *  check if non-null distSpct1 exists edgar 05/13/2014
	 */
	Map<String, Object> getDistScpt1Val(Map<String, Object> params) throws SQLException;
	
	/**
	 *  Updates dist_spct1 to null when it has value but same with dist_spct for GIUWS004, GIUWS013 edgar 05/13/2014
	 */
	Map<String, Object> updateDistSpct1ToNull(Map<String, Object> params) throws SQLException;
	
	/**
	 *  Delete and Reinsert when posting in GIUWS004 which was saved from Peril modules edgar 05/14/2014
	 */
	Map<String, Object> deleteReinsertGIUWS004(Map<String, Object> params) throws SQLException;
	
	// shan 06.03.2014
	void compareDelRinsrtWdistTable(Integer distNo) throws SQLException;
	
	void updateAutoDistGIUWS005(HttpServletRequest request) throws SQLException;
	
	String compareWdistTable(Map<String, Object> params) throws SQLException;
	
	Map<String, Object> getWpolbasGIUWS005(Integer parId) throws SQLException;
	
	// Gzelle 06112014
	void compareDelRinsrtWdistTableGIUWS004(Integer distNo) throws SQLException;
	
	void cmpareDelRinsrtWdistTbl1GIUWS004(Integer distNo) throws SQLException;
	
	Map<String, Object> postDistGiuws004Final(Map<String, Object> params,String parameter, GIISUser USER) throws SQLException, JSONException, ParseException;
	//end
	
	String checkBinderExist(Integer policyId, Integer distNo) throws SQLException;
	
	Map<String, Object> checkNullDistPremGIUWS006(HttpServletRequest request) throws SQLException;
	
	void populateWitemPerilDtl(Integer distNo) throws SQLException;
	
	String checkSumInsuredPremGIUWS006(Integer distNo) throws SQLException;
	
	String validateB4PostGIUWS006(Map<String, Object> params) throws SQLException;
	//edgar 06/10/2014
	Map<String, Object> postDistGiuws003Final(Map<String, Object> params,
			String parameter, GIISUser USER) throws SQLException,
			JSONException, ParseException;
	
	Map<String, Object> postDistGiuws006Final(HttpServletRequest request, String parameter, GIISUser USER) throws SQLException, JSONException, ParseException;
		
	void validateRenumItemNos(HttpServletRequest request) throws SQLException;
	
	Map<String, Object> postDistGiuw005Final(Map<String, Object> params, String parameter, GIISUser USER) throws SQLException, JSONException, ParseException;

	void preSaveOuterDist(HttpServletRequest request) throws SQLException, JSONException;
	
	//edgar 06/20/2014
	Map<String, Object> checkPostedBinder(Map<String, Object> params) throws SQLException;
	void checkItemPerilAmountAndShare(HttpServletRequest request) throws SQLException;
	
	String checkIfDiffPerilGroupShare(Integer distNo) throws SQLException;
	
	void preValidationNegDist(HttpServletRequest request) throws SQLException;
	void validateTakeupGiuts021(HttpServletRequest request) throws SQLException;	//edgar 09/26/2014
}
