package com.geniisys.giac.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.giac.dao.GIACInwClaimPaytsDAO;
import com.geniisys.giac.entity.GIACInwClaimPayts;
import com.geniisys.giac.service.GIACInwClaimPaytsService;

public class GIACInwClaimPaytsServiceImpl implements GIACInwClaimPaytsService {
	
	/** The logger */
	private static Logger log = Logger.getLogger(GIACInwClaimPaytsServiceImpl.class);
	
	/** The GIACInwClaimPayts DAO */
	private GIACInwClaimPaytsDAO giacInwClaimPaytsDAO;

	public void setGiacInwClaimPaytsDAO(GIACInwClaimPaytsDAO giacInwClaimPaytsDAO) {
		this.giacInwClaimPaytsDAO = giacInwClaimPaytsDAO;
	}

	public GIACInwClaimPaytsDAO getGiacInwClaimPaytsDAO() {
		return giacInwClaimPaytsDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACInwClaimPaytsService#getGIACInwClaimPayts(java.lang.Integer)
	 */
	@Override
	public List<GIACInwClaimPayts> getGIACInwClaimPayts(Integer gaccTranId)
			throws SQLException {
		log.info("");
		return this.getGiacInwClaimPaytsDAO().getGIACInwClaimPayts(gaccTranId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACInwClaimPaytsService#getClaimPolicyAndAssured(java.lang.Integer)
	 */
	@Override
	public Map<String, Object> getClaimPolicyAndAssured(Integer claimId)
			throws SQLException {
		return this.getGiacInwClaimPaytsDAO().getClaimPolicyAndAssured(claimId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACInwClaimPaytsService#getClmLossIdListing(java.util.Map)
	 */
	@Override
	public List<Map<String, Object>> getClmLossIdListing(
			Map<String, Object> params) throws SQLException {
		return this.getGiacInwClaimPaytsDAO().getClmLossIdListing(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACInwClaimPaytsService#validatePayee(java.util.Map)
	 */
	@Override
	public void validatePayee(Map<String, Object> params) throws SQLException {
		this.getGiacInwClaimPaytsDAO().validatePayee(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACInwClaimPaytsService#executeGiacs018PreInsertTrigger(java.util.Map)
	 */
	@Override
	public void executeGiacs018PreInsertTrigger(Map<String, Object> params)
			throws SQLException {
		this.getGiacInwClaimPaytsDAO().executeGiacs018PreInsertTrigger(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACInwClaimPaytsService#executeGiacs018PostFormsCommit(java.util.Map)
	 */
	@Override
	public void executeGiacs018PostFormsCommit(Map<String, Object> params)
			throws SQLException {
		this.getGiacInwClaimPaytsDAO().executeGiacs018PostFormsCommit(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACInwClaimPaytsService#delGIACInwClaimPayts(java.util.List)
	 */
	@Override
	public void delGIACInwClaimPayts(List<GIACInwClaimPayts> inwClaimPaytsList)
			throws SQLException {
		this.getGiacInwClaimPaytsDAO().delGIACInwClaimPayts(inwClaimPaytsList);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACInwClaimPaytsService#setGIACInwClaimPayts(java.util.List)
	 */
	@Override
	public void setGIACInwClaimPayts(List<GIACInwClaimPayts> inwClaimPaytsList)
			throws SQLException {
		this.getGiacInwClaimPaytsDAO().setGIACInwClaimPayts(inwClaimPaytsList);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACInwClaimPaytsService#saveGIACInwClaimPayts(org.json.JSONArray, org.json.JSONArray, java.util.Map)
	 */
	@Override
	public Map<String, Object> saveGIACInwClaimPayts(
			JSONArray setRows, JSONArray delRows,
			Map<String, Object> params) throws SQLException, JSONException,
			ParseException {
		List<GIACInwClaimPayts> setInwClaimPaytsList = this.prepareGIACInwClaimPaytsForInsert(setRows);
		List<GIACInwClaimPayts> delInwClaimPaytsList = this.prepareGIACInwClaimPaytsForDelete(delRows);
		
		return this.getGiacInwClaimPaytsDAO().saveGIACInwClaimPayts(setInwClaimPaytsList, delInwClaimPaytsList, params);
	}
	
	private List<GIACInwClaimPayts> prepareGIACInwClaimPaytsForInsert(JSONArray setRows) 
			throws JSONException, ParseException{
		List<GIACInwClaimPayts> inwClaimPaytsList = new ArrayList<GIACInwClaimPayts>();
		GIACInwClaimPayts inwClaimPayts = null;
		
		for (int i = 0; i < setRows.length(); i++) {
			inwClaimPayts = new GIACInwClaimPayts();
			
			inwClaimPayts.setGaccTranId(setRows.getJSONObject(i).isNull("gaccTranId") ? null : setRows.getJSONObject(i).getInt("gaccTranId"));
			inwClaimPayts.setClaimId(setRows.getJSONObject(i).isNull("claimId") ? null : setRows.getJSONObject(i).getInt("claimId"));
			inwClaimPayts.setClmLossId(setRows.getJSONObject(i).isNull("clmLossId") ? null : setRows.getJSONObject(i).getInt("clmLossId"));
			inwClaimPayts.setTransactionType(setRows.getJSONObject(i).isNull("transactionType") ? null : setRows.getJSONObject(i).getInt("transactionType"));
			inwClaimPayts.setAdviceId(setRows.getJSONObject(i).isNull("adviceId") ? null : setRows.getJSONObject(i).getInt("adviceId"));
			inwClaimPayts.setPayeeCd(setRows.getJSONObject(i).isNull("payeeCd") ? null : setRows.getJSONObject(i).getInt("payeeCd"));
			inwClaimPayts.setPayeeClassCd(setRows.getJSONObject(i).isNull("payeeClassCd") ? null : setRows.getJSONObject(i).getString("payeeClassCd"));
			inwClaimPayts.setPayeeType(setRows.getJSONObject(i).isNull("payeeType") ? null : setRows.getJSONObject(i).getString("payeeType"));
			inwClaimPayts.setDisbursementAmt(setRows.getJSONObject(i).isNull("disbursementAmt") ? null : ("".equals(setRows.getJSONObject(i).getString("disbursementAmt").trim())) ? null : new BigDecimal(setRows.getJSONObject(i).getString("disbursementAmt")));
			inwClaimPayts.setCurrencyCd(setRows.getJSONObject(i).isNull("currencyCd") ? null : setRows.getJSONObject(i).getInt("currencyCd"));
			inwClaimPayts.setConvertRate(setRows.getJSONObject(i).isNull("convertRate") ? null : ("".equals(setRows.getJSONObject(i).getString("convertRate").trim())) ? null : new BigDecimal(setRows.getJSONObject(i).getString("convertRate")));
			inwClaimPayts.setForeignCurrAmt(setRows.getJSONObject(i).isNull("foreignCurrAmt") ? null : ("".equals(setRows.getJSONObject(i).getString("foreignCurrAmt").trim())) ? null : new BigDecimal(setRows.getJSONObject(i).getString("foreignCurrAmt")));
			inwClaimPayts.setOrPrintTag(setRows.getJSONObject(i).isNull("orPrintTag") ? null : setRows.getJSONObject(i).getString("orPrintTag"));
			inwClaimPayts.setRemarks(setRows.getJSONObject(i).isNull("remarks") ? null : setRows.getJSONObject(i).getString("remarks"));
			inwClaimPayts.setInputVATAmt(setRows.getJSONObject(i).isNull("inputVATAmt") ? null : ("".equals(setRows.getJSONObject(i).getString("inputVATAmt").trim())) ? null : new BigDecimal(setRows.getJSONObject(i).getString("inputVATAmt")));
			inwClaimPayts.setWholdingTaxAmt(setRows.getJSONObject(i).isNull("wholdingTaxAmt") ? null : ("".equals(setRows.getJSONObject(i).getString("wholdingTaxAmt").trim())) ? null : new BigDecimal(setRows.getJSONObject(i).getString("wholdingTaxAmt")));
			inwClaimPayts.setNetDisbAmt(setRows.getJSONObject(i).isNull("netDisbAmt") ? null : ("".equals(setRows.getJSONObject(i).getString("netDisbAmt").trim())) ? null : new BigDecimal(setRows.getJSONObject(i).getString("netDisbAmt")));
			
			inwClaimPaytsList.add(inwClaimPayts);
		}
		
		return inwClaimPaytsList;
	}
	
	private List<GIACInwClaimPayts> prepareGIACInwClaimPaytsForDelete(JSONArray setRows) 
	throws JSONException, ParseException{
		List<GIACInwClaimPayts> inwClaimPaytsList = new ArrayList<GIACInwClaimPayts>();
		GIACInwClaimPayts inwClaimPayts = null;
		
		for (int i = 0; i < setRows.length(); i++) {
			inwClaimPayts = new GIACInwClaimPayts();
			
			inwClaimPayts.setGaccTranId(setRows.getJSONObject(i).isNull("gaccTranId") ? null : setRows.getJSONObject(i).getInt("gaccTranId"));
			inwClaimPayts.setClaimId(setRows.getJSONObject(i).isNull("claimId") ? null : setRows.getJSONObject(i).getInt("claimId"));
			inwClaimPayts.setClmLossId(setRows.getJSONObject(i).isNull("clmLossId") ? null : setRows.getJSONObject(i).getInt("clmLossId"));
			inwClaimPayts.setTransactionType(setRows.getJSONObject(i).isNull("transactionType") ? null : setRows.getJSONObject(i).getInt("transactionType"));
			inwClaimPayts.setAdviceId(setRows.getJSONObject(i).isNull("adviceId") ? null : setRows.getJSONObject(i).getInt("adviceId"));
			
			inwClaimPaytsList.add(inwClaimPayts);
		}
		
		return inwClaimPaytsList;
	}
}
