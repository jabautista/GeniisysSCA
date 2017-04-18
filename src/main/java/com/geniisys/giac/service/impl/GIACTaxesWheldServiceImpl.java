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

import com.geniisys.giac.dao.GIACTaxesWheldDAO;
import com.geniisys.giac.entity.GIACTaxesWheld;
import com.geniisys.giac.service.GIACTaxesWheldService;

public class GIACTaxesWheldServiceImpl implements GIACTaxesWheldService {

	/** The logger */
	private static Logger log = Logger.getLogger(GIACTaxesWheldServiceImpl.class);
	
	/** The GIACTaxesWheld DAO */
	private GIACTaxesWheldDAO giacTaxesWheldDAO;

	public void setGiacTaxesWheldDAO(GIACTaxesWheldDAO giacTaxesWheldDAO) {
		this.giacTaxesWheldDAO = giacTaxesWheldDAO;
	}

	public GIACTaxesWheldDAO getGiacTaxesWheldDAO() {
		return giacTaxesWheldDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACTaxesWheldService#getGiacTaxesWheld(java.lang.Integer)
	 */
	@Override
	public List<GIACTaxesWheld> getGiacTaxesWheld(Integer gaccTranId)
			throws SQLException {
		return this.getGiacTaxesWheldDAO().getGiacTaxesWheld(gaccTranId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACTaxesWheldService#saveGIACTaxesWheld(org.json.JSONArray, org.json.JSONArray, java.util.Map)
	 */
	@Override
	public String saveGIACTaxesWheld(JSONArray setRows, JSONArray delRows,
			Map<String, Object> params) throws SQLException, JSONException, ParseException {
		log.info("saveGIACTaxesWheld");
		List<GIACTaxesWheld> setTaxesWheldList = this.prepareGIACTaxesWheldForInsert(setRows, params.get("appUser").toString());
		List<GIACTaxesWheld> delTaxesWheldList = this.prepareGIACTaxesWheldForDelete(delRows);
		
		return this.getGiacTaxesWheldDAO().saveGIACTaxesWheld(setTaxesWheldList, delTaxesWheldList, params);
	}
	
	/**
	 * 
	 * @param setRows
	 * @return
	 * @throws JSONException
	 * @throws ParseException
	 */
	private List<GIACTaxesWheld> prepareGIACTaxesWheldForInsert(JSONArray setRows, String appUser)
		throws JSONException, ParseException {
		List<GIACTaxesWheld> taxesWheldList = new ArrayList<GIACTaxesWheld>();
		GIACTaxesWheld taxesWheld;
		
		for (int i = 0; i < setRows.length(); i++) {
			taxesWheld = new GIACTaxesWheld();
			
			taxesWheld.setGaccTranId(setRows.getJSONObject(i).isNull("gaccTranId") ? null : setRows.getJSONObject(i).getInt("gaccTranId"));
			taxesWheld.setItemNo(setRows.getJSONObject(i).isNull("itemNo") ? null : setRows.getJSONObject(i).getInt("itemNo"));
			taxesWheld.setPayeeClassCd(setRows.getJSONObject(i).isNull("payeeClassCd") ? null : setRows.getJSONObject(i).getString("payeeClassCd"));
			taxesWheld.setPayeeCd(setRows.getJSONObject(i).isNull("payeeCd") ? null : setRows.getJSONObject(i).getInt("payeeCd"));
			taxesWheld.setSlCd(setRows.getJSONObject(i).isNull("slCd") ? null : setRows.getJSONObject(i).getInt("slCd"));
			taxesWheld.setIncomeAmt(setRows.getJSONObject(i).isNull("gaccTranId") ? null : (setRows.getJSONObject(i).getString("incomeAmt").isEmpty() ? null : new BigDecimal(setRows.getJSONObject(i).getString("incomeAmt"))));
			taxesWheld.setWholdingTaxAmt(setRows.getJSONObject(i).isNull("wholdingTaxAmt") ? null : (setRows.getJSONObject(i).getString("gaccTranId").isEmpty() ? null : new BigDecimal(setRows.getJSONObject(i).getString("wholdingTaxAmt"))));
			taxesWheld.setRemarks(setRows.getJSONObject(i).isNull("remarks") ? null : setRows.getJSONObject(i).getString("remarks"));
			taxesWheld.setGwtxWhtaxId(setRows.getJSONObject(i).isNull("gwtxWhtaxId") ? null : setRows.getJSONObject(i).getInt("gwtxWhtaxId"));
			taxesWheld.setSlTypeCd(setRows.getJSONObject(i).isNull("slTypeCd") ? null : setRows.getJSONObject(i).getString("slTypeCd"));
			taxesWheld.setOrPrintTag(setRows.getJSONObject(i).isNull("orPrintTag") ? null : setRows.getJSONObject(i).getString("orPrintTag"));
			taxesWheld.setGenType(setRows.getJSONObject(i).isNull("genType") ? null : setRows.getJSONObject(i).getString("genType"));
			taxesWheld.setUserId(appUser);
			
			taxesWheldList.add(taxesWheld);
		}
		
		return taxesWheldList;
	}
	
	/**
	 * 
	 * @param delRows
	 * @return
	 * @throws JSONException
	 * @throws ParseException
	 */
	private List<GIACTaxesWheld> prepareGIACTaxesWheldForDelete(JSONArray delRows)
		throws JSONException, ParseException {
		List<GIACTaxesWheld> taxesWheldList = new ArrayList<GIACTaxesWheld>();
		GIACTaxesWheld taxesWheld;
		
		for (int i = 0; i < delRows.length(); i++) {
			taxesWheld = new GIACTaxesWheld();
			
			taxesWheld.setGaccTranId(delRows.getJSONObject(i).isNull("gaccTranId") ? null : delRows.getJSONObject(i).getInt("gaccTranId"));
			taxesWheld.setItemNo(delRows.getJSONObject(i).isNull("itemNo") ? null : delRows.getJSONObject(i).getInt("itemNo"));
			taxesWheld.setPayeeClassCd(delRows.getJSONObject(i).isNull("payeeClassCd") ? null : delRows.getJSONObject(i).getString("payeeClassCd"));
			taxesWheld.setPayeeCd(delRows.getJSONObject(i).isNull("payeeCd") ? null : delRows.getJSONObject(i).getInt("payeeCd"));
			
			taxesWheldList.add(taxesWheld);
		}
		
		return taxesWheldList;
	}
	//Added by pjsantos 12/27/2016, GENQA 5898
	@Override
	public String saveBir2307History(Map<String, Object> params)
			throws SQLException {
		return this.getGiacTaxesWheldDAO().saveBir2307History(params);
	}
}
