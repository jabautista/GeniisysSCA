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

import com.geniisys.giac.dao.GIACOvrideCommPaytsDAO;
import com.geniisys.giac.entity.GIACOvrideCommPayts;
import com.geniisys.giac.service.GIACOvrideCommPaytsService;

public class GIACOvrideCommPaytsServiceImpl implements
		GIACOvrideCommPaytsService {

	/** The GIACOvrideCommPayts DAO */
	private GIACOvrideCommPaytsDAO giacOvrideCommPaytsDAO;
	
	/** The log */
	private Logger log = Logger.getLogger(GIACOvrideCommPaytsServiceImpl.class);

	public void setGiacOvrideCommPaytsDAO(GIACOvrideCommPaytsDAO giacOvrideCommPaytsDAO) {
		this.giacOvrideCommPaytsDAO = giacOvrideCommPaytsDAO;
	}

	public GIACOvrideCommPaytsDAO getGiacOvrideCommPaytsDAO() {
		return giacOvrideCommPaytsDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOvrideCommPaytsService#getGIACOvrideCommPayts(java.lang.Integer)
	 */
	@Override
	public List<GIACOvrideCommPayts> getGIACOvrideCommPayts(Integer gaccTranId)
			throws SQLException {
		log.info("");
		return this.getGiacOvrideCommPaytsDAO().getGIACOvrideCommPayts(gaccTranId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOvrideCommPaytsService#chckPremPayts(java.util.Map)
	 */
	@Override
	public void chckPremPayts(Map<String, Object> params) throws SQLException {
		this.getGiacOvrideCommPaytsDAO().chckPremPayts(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOvrideCommPaytsService#chckBalance(java.util.Map)
	 */
	@Override
	public void chckBalance(Map<String, Object> params) throws SQLException {
		this.getGiacOvrideCommPaytsDAO().chckBalance(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOvrideCommPaytsService#validateGiacs040ChildIntmNo(java.util.Map)
	 */
	@Override
	public void validateGiacs040ChildIntmNo(Map<String, Object> params)
			throws SQLException {
		this.getGiacOvrideCommPaytsDAO().validateGiacs040ChildIntmNo(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOvrideCommPaytsService#validateGiacs040CommAmt(java.util.Map)
	 */
	@Override
	public void validateGiacs040CommAmt(Map<String, Object> params)
			throws SQLException {
		this.getGiacOvrideCommPaytsDAO().validateGiacs040CommAmt(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOvrideCommPaytsService#validateGiacs040ForeignCurrAmt(java.util.Map)
	 */
	@Override
	public void validateGiacs040ForeignCurrAmt(Map<String, Object> params)
			throws SQLException {
		this.getGiacOvrideCommPaytsDAO().validateGiacs040ForeignCurrAmt(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOvrideCommPaytsService#saveGIACOvrideCommPayts(org.json.JSONArray, org.json.JSONArray, java.util.Map)
	 */
	@Override
	public String saveGIACOvrideCommPayts(JSONArray setOvrideCommPayts, JSONArray delOvrideCommPayts, Map<String, Object> params) 
			throws SQLException, JSONException, ParseException {
		List<GIACOvrideCommPayts> setRows = this.prepareGIACOvrideCommPaytsForInsert(setOvrideCommPayts, params.get("appUser").toString());
		List<GIACOvrideCommPayts> delRows = this.prepareGIACOvrideCommPaytsForDelete(delOvrideCommPayts);
		
		return this.getGiacOvrideCommPaytsDAO().saveGIACOvrideCommPayts(setRows, delRows, params);
	}
	
	private List<GIACOvrideCommPayts> prepareGIACOvrideCommPaytsForInsert(JSONArray setRows, String appUser) 
		throws JSONException, ParseException {
		List<GIACOvrideCommPayts> ovrideCommPaytsList = new ArrayList<GIACOvrideCommPayts>();
		GIACOvrideCommPayts ovrideCommPayts = null;
		
		for (int i = 0; i < setRows.length(); i++) {
			ovrideCommPayts = new GIACOvrideCommPayts();
			
			ovrideCommPayts.setGaccTranId(setRows.getJSONObject(i).isNull("gaccTranId") ? null : setRows.getJSONObject(i).getInt("gaccTranId"));
			ovrideCommPayts.setTransactionType(setRows.getJSONObject(i).isNull("transactionType") ? null : setRows.getJSONObject(i).getInt("transactionType"));
			ovrideCommPayts.setIssCd(setRows.getJSONObject(i).isNull("issCd") ? null : setRows.getJSONObject(i).getString("issCd"));
			ovrideCommPayts.setPremSeqNo(setRows.getJSONObject(i).isNull("premSeqNo") ? null : setRows.getJSONObject(i).getInt("premSeqNo"));
			ovrideCommPayts.setIntmNo(setRows.getJSONObject(i).isNull("intmNo") ? null : setRows.getJSONObject(i).getInt("intmNo"));
			ovrideCommPayts.setChildIntmNo(setRows.getJSONObject(i).isNull("childIntmNo") ? null : setRows.getJSONObject(i).getInt("childIntmNo"));
			ovrideCommPayts.setCommAmt(setRows.getJSONObject(i).isNull("commAmt") ? null : ("".equals(setRows.getJSONObject(i).getString("commAmt").trim())) ? null : new BigDecimal(setRows.getJSONObject(i).getString("commAmt")));
			ovrideCommPayts.setWtaxAmt(setRows.getJSONObject(i).isNull("wtaxAmt") ? null : ("".equals(setRows.getJSONObject(i).getString("wtaxAmt").trim())) ? null : new BigDecimal(setRows.getJSONObject(i).getString("wtaxAmt")));
			ovrideCommPayts.setCurrencyCd(setRows.getJSONObject(i).isNull("currencyCd") ? null : setRows.getJSONObject(i).getInt("currencyCd"));
			ovrideCommPayts.setConvertRt(setRows.getJSONObject(i).isNull("convertRt") ? null : ("".equals(setRows.getJSONObject(i).getString("convertRt").trim())) ? null : new BigDecimal(setRows.getJSONObject(i).getString("convertRt")));
			ovrideCommPayts.setForeignCurrAmt(setRows.getJSONObject(i).isNull("foreignCurrAmt") ? null : ("".equals(setRows.getJSONObject(i).getString("foreignCurrAmt").trim())) ? null : new BigDecimal(setRows.getJSONObject(i).getString("foreignCurrAmt")));
			ovrideCommPayts.setInputVAT(setRows.getJSONObject(i).isNull("inputVAT") ? null : ("".equals(setRows.getJSONObject(i).getString("inputVAT").trim())) ? null : new BigDecimal(setRows.getJSONObject(i).getString("inputVAT")));
			ovrideCommPayts.setParticulars(setRows.getJSONObject(i).isNull("particulars") ? null : setRows.getJSONObject(i).getString("particulars"));
			ovrideCommPayts.setAppUser(appUser);
			
			ovrideCommPaytsList.add(ovrideCommPayts);
		}
		
		return ovrideCommPaytsList;
	}
	
	/**
	 * 
	 * @param delRows
	 * @return
	 * @throws JSONException
	 * @throws ParseException
	 */
	private List<GIACOvrideCommPayts> prepareGIACOvrideCommPaytsForDelete(JSONArray delRows) 
		throws JSONException, ParseException {
		List<GIACOvrideCommPayts> ovrideCommPaytsList = new ArrayList<GIACOvrideCommPayts>();
		GIACOvrideCommPayts ovrideCommPayts = null;
		
		for (int i = 0; i < delRows.length(); i++) {
			ovrideCommPayts = new GIACOvrideCommPayts();
			
			ovrideCommPayts.setGaccTranId(delRows.getJSONObject(i).isNull("gaccTranId") ? null : delRows.getJSONObject(i).getInt("gaccTranId"));
			ovrideCommPayts.setIssCd(delRows.getJSONObject(i).isNull("issCd") ? null : delRows.getJSONObject(i).getString("issCd"));
			ovrideCommPayts.setPremSeqNo(delRows.getJSONObject(i).isNull("premSeqNo") ? null : delRows.getJSONObject(i).getInt("premSeqNo"));
			ovrideCommPayts.setIntmNo(delRows.getJSONObject(i).isNull("intmNo") ? null : delRows.getJSONObject(i).getInt("intmNo"));
			ovrideCommPayts.setChildIntmNo(delRows.getJSONObject(i).isNull("childIntmNo") ? null : delRows.getJSONObject(i).getInt("childIntmNo"));
			
			ovrideCommPaytsList.add(ovrideCommPayts);
		}
		
		return ovrideCommPaytsList;
	}
	
	public String validateTranRefund(Map<String, Object> params) throws SQLException{
		return this.giacOvrideCommPaytsDAO.validateTranRefund(params);
	}
	
	public Map<String, Object> getInputVAT(Map<String, Object> params) throws SQLException{
		return this.giacOvrideCommPaytsDAO.getInputVAT(params);
	}
	
	public void valDeleteRec(Map<String, Object> params) throws SQLException{
		this.giacOvrideCommPaytsDAO.valDeleteRec(params);
	}
	
	public String validateBill(Map<String, Object> params) throws SQLException{
		return this.giacOvrideCommPaytsDAO.validateBill(params);
	}
}
