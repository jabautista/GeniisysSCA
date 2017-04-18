/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONArray;

import com.geniisys.gipi.dao.GIPIWPolbasDiscountDAO;
import com.geniisys.gipi.entity.GIPIWItemDiscount;
import com.geniisys.gipi.entity.GIPIWItemPeril;
import com.geniisys.gipi.entity.GIPIWPerilDiscount;
import com.geniisys.gipi.entity.GIPIWPolbasDiscount;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIWPolbasDiscountDAOImpl.
 */
public class GIPIWPolbasDiscountDAOImpl implements GIPIWPolbasDiscountDAO{
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWPolbasDiscountDAOImpl.class);
	
	/** The sql map client. */
	private SqlMapClient sqlMapClient;

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
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDiscountDAO#getGipiWPolbasDiscount(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWPolbasDiscount> getGipiWPolbasDiscount(Integer parId)
			throws SQLException {
		log.info("Getting policy discount/surcharge...");
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		return (List<GIPIWPolbasDiscount>) this.getSqlMapClient().queryForList("selectGIPIWPolbasDiscount", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDiscountDAO#getOrigPremAmt(java.lang.Integer)
	 */
	@Override
	public Map<String, String> getOrigPremAmt(Integer parId)
			throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		this.sqlMapClient.update("getOrigPremAmt", params);
		return params;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDiscountDAO#getOrigPremAmt2(java.lang.Integer)
	 */
	@Override
	public Map<String, String> getOrigPremAmt2(Integer parId)
			throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		this.sqlMapClient.update("getOrigPremAmt2", params);
		return params;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolbasDiscountDAO#getNetPolPrem(java.lang.Integer)
	 */
	@Override
	public Map<String, String> getNetPolPrem(Integer parId) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		this.sqlMapClient.update("getNetPolPrem", params);
		return params;
	}

	@Override
	public void saveAllDiscount(HashMap<String, Object> mainParams) throws SQLException {
		log.info("DAO calling saveAllDiscount...");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Integer parId = (Integer) mainParams.get("parId");
			String lineCd = (String) mainParams.get("lineCd");
			String issCd = (String) mainParams.get("issCd");
			
			if (!saveDiscount(mainParams)){
				throw new Exception();
			}
			
			this.getSqlMapClient().executeBatch();
			
			Map<String, String> paramsPostForm = new HashMap<String, String>();
			paramsPostForm.put("parId", parId.toString());
			paramsPostForm.put("lineCd", lineCd);
			paramsPostForm.put("issCd", issCd);
			System.out.println("Start post-form-commit trigger...");
			this.getSqlMapClient().update("postFormCommit", paramsPostForm);
			System.out.println("End post-form-commit trigger...");
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
		log.info("Done saving saveAllDiscount details...");
	}
	
	@SuppressWarnings("unchecked")
	public Boolean saveDiscount(HashMap<String, Object> mainParams){
		try{
			List<GIPIWPolbasDiscount> wpolbasDisc = (List<GIPIWPolbasDiscount>) mainParams.get("wpolbasDisc");
			List<GIPIWItemDiscount> witemDisc = (List<GIPIWItemDiscount>) mainParams.get("witemDisc");
			List<GIPIWPerilDiscount> wperilDisc = (List<GIPIWPerilDiscount>) mainParams.get("wperilDisc");
			Integer parId = (Integer) mainParams.get("parId");
			String toDo = (String) mainParams.get("toDo");//added by steven 10/03/2012 for adding or updating condition
			if (toDo == null){toDo = "Save";}
				
			Map<String, String> paramsGet = new HashMap<String, String>();
			paramsGet.put("parId", parId.toString());
			
			Map<String, String> paramsIn = new HashMap<String, String>();
			paramsIn.put("parId", parId.toString());
			
			List<GIPIWPolbasDiscount> gipiWPolbasDiscount = this.getSqlMapClient().queryForList("selectGIPIWPolbasDiscount", paramsGet);
			List<GIPIWItemDiscount> gipiWItemDiscount = this.getSqlMapClient().queryForList("selectGIPIWItemDiscount", paramsGet);
			List<GIPIWPerilDiscount> gipiWPerilDiscount = this.getSqlMapClient().queryForList("selectGIPIWPerilDiscount", paramsGet);
			String var = "Y";
			
			System.out.println("=======================================================================================");
			System.out.println("Deleting Discount at POL/s");
			for (int i=0; i < gipiWPolbasDiscount.size(); i++)	{
				if (wpolbasDisc.size() > 0) {
					for(GIPIWPolbasDiscount wpolbas : wpolbasDisc){
						if (gipiWPolbasDiscount.get(i).getSequenceNo().equals(wpolbas.getSequenceNo())){
							var = "N";
							break;
						}
					}
					Map<String, String> params = new HashMap<String, String>();
					params.put("parId", parId.toString());
					params.put("sequence", gipiWPolbasDiscount.get(i).getSequenceNo());
					params.put("var", var);
					System.out.println("Deleting discount at policy: "+params);				
					this.getSqlMapClient().update("deleteDiscountAtPol", params);
					var = "Y";
				}else{
					Map<String, String> params = new HashMap<String, String>();
					params.put("parId", parId.toString());
					params.put("sequence", gipiWPolbasDiscount.get(i).getSequenceNo());
					params.put("var", "Y");
					System.out.println("Deleting discount at policy: "+params);				
					this.getSqlMapClient().update("deleteDiscountAtPol", params);
				}
			}
			
			System.out.println("Deleting Records in GIPI_WPOLBAS_DISCOUNT: "+parId);
			this.sqlMapClient.update("deleteGIPIWPolbasDiscount", parId);
			
			System.out.println("Saving Wpolbas Discount record/s");
			for(GIPIWPolbasDiscount wpolbas : wpolbasDisc){
				Map<String, String> params = new HashMap<String, String>();
				params.put("parId", Integer.toString(wpolbas.getParId()));
				params.put("netGrossTag", wpolbas.getNetGrossTag());
				params.put("discRt", wpolbas.getDiscountRt()==null?"":wpolbas.getDiscountRt().toString());
				params.put("surcRt", wpolbas.getSurchargeRt()==null?"":wpolbas.getSurchargeRt().toString());
				params.put("lineCd", wpolbas.getLineCd());
				params.put("sublineCd", wpolbas.getSublineCd());
				params.put("sequence", wpolbas.getSequenceNo());
				params.put("discAmt", wpolbas.getDiscountAmt()==null?"":wpolbas.getDiscountAmt().toString());
				params.put("surcAmt", wpolbas.getSurchargeAmt()==null?"":wpolbas.getSurchargeAmt().toString());
				System.out.println("Adding discount at POL : "+ params);
				this.getSqlMapClient().update("addDiscountPol", params);
				this.getSqlMapClient().insert("setGipiWPolbasDiscount", wpolbas);				
			}
			System.out.println("=======================================================================================");
			
			System.out.println("Deleting Discount at ITEM/s");
			for (int i=0; i < gipiWItemDiscount.size(); i++)	{
				if (witemDisc.size() > 0) {
					for(GIPIWItemDiscount witem : witemDisc){
						if (gipiWItemDiscount.get(i).getSequenceNo().equals(witem.getSequenceNo())){
							Map<String, String> params = new HashMap<String, String>();
							params.put("parId", parId.toString());
							params.put("itemNo", witem.getItemNo());
							params.put("origItemNo", gipiWItemDiscount.get(i).getItemNo());
							params.put("sequence", gipiWItemDiscount.get(i).getSequenceNo());
							if (gipiWItemDiscount.get(i).getItemNo().equals(witem.getItemNo())){
								params.put("var", "N");
								System.out.println("Deleting discount at item: "+params);
								this.sqlMapClient.update("deleteDiscountAtItem", params);
							} else {
								params.put("var", "Y");
								System.out.println("Deleting discount at item: "+params);
								this.sqlMapClient.update("deleteDiscountAtItem", params);
							}
							break;
						}
					}
					if (i >= witemDisc.size()){
						Map<String, String> params = new HashMap<String, String>();
						params.put("parId", parId.toString());
						params.put("itemNo", gipiWItemDiscount.get(i).getItemNo());
						params.put("origItemNo", gipiWItemDiscount.get(i).getItemNo());
						params.put("sequence", gipiWItemDiscount.get(i).getSequenceNo());
						params.put("var", "Y");
						System.out.println("Deleting discount at item: "+params);
						this.sqlMapClient.update("deleteDiscountAtItem", params);
					}
				}else{
					Map<String, String> params = new HashMap<String, String>();
					params.put("parId", parId.toString());
					params.put("itemNo", gipiWItemDiscount.get(i).getItemNo());
					params.put("origItemNo", gipiWItemDiscount.get(i).getItemNo());
					params.put("sequence", gipiWItemDiscount.get(i).getSequenceNo());
					params.put("var", "Y");
					System.out.println("Deleting discount at item: "+params);
					this.sqlMapClient.update("deleteDiscountAtItem", params);
				}
			}
			
			System.out.println("Deleting Records in GIPI_WITEM_DISCOUNT: "+parId);
			this.sqlMapClient.update("deleteGIPIWItemDiscount", parId);
			
			System.out.println("Saving Witem Discount record/s");
			for(GIPIWItemDiscount witem : witemDisc){	
				Map<String, String> params = new HashMap<String, String>();
				params.put("parId", Integer.toString(witem.getParId()));
				params.put("itemNo", witem.getItemNo());
				params.put("lineCd", witem.getLineCd());
				params.put("discRt", witem.getDiscountRt()==null?"":witem.getDiscountRt().toString());
				params.put("netGrossTag", witem.getNetGrossTag());
				params.put("sublineCd", witem.getSublineCd());
				params.put("sequence", witem.getSequenceNo());
				params.put("surcRt", witem.getSurchargeRt()==null?"":witem.getSurchargeRt().toString());
				params.put("discAmt", witem.getDiscountAmt()==null?"":witem.getDiscountAmt().toString());
				params.put("surcAmt", witem.getSurchargeAmt()==null?"":witem.getSurchargeAmt().toString());
				System.out.println("Adding discount at ITEM : "+ params);				
				this.getSqlMapClient().update("addDiscountItem", params);
				this.getSqlMapClient().insert("setGipiWItemDiscount", witem);				
			}
			System.out.println("=======================================================================================\t");
			
			/*remove by steven 10/05/2012; it causes wrong computation in the premium amt
			 * 								I editted the procedure "deleteGIPIWPerilDiscount2",so that before it deletes all the peril discount/surcharge 
			 * 								it returns the value of the premium amt,just like there is no peril discount/surcharge added.
			 * System.out.println("Updating Discount At Peril ");
			for (int i=0; i < gipiWPerilDiscount.size(); i++)	{
				if (wperilDisc.size() > 0) {
					for(GIPIWPerilDiscount wperil : wperilDisc){	
						if (gipiWPerilDiscount.get(i).getSequenceNo().equals(wperil.getSequenceNo())){
							Map<String, String> params = new HashMap<String, String>();
							params.put("parId", parId.toString());
							params.put("itemNo", wperil.getItemNo());
							params.put("origItemNo", gipiWPerilDiscount.get(i).getItemNo());
							params.put("perilCd", wperil.getPerilCd());
							params.put("origPerilCd", gipiWPerilDiscount.get(i).getPerilCd());
							params.put("discAmt", wperil.getDiscountAmt()==null?"":wperil.getDiscountAmt().toString());
							params.put("origDiscAmt", gipiWPerilDiscount.get(i).getDiscountAmt()==null?"":gipiWPerilDiscount.get(i).getDiscountAmt().toString());
							params.put("surcAmt", wperil.getSurchargeAmt()==null?"":wperil.getSurchargeAmt().toString());
							params.put("origSurcAmt", gipiWPerilDiscount.get(i).getSurchargeAmt()==null?"":gipiWPerilDiscount.get(i).getSurchargeAmt().toString());
							System.out.println("Updating Discount at peril: "+params);
							this.sqlMapClient.update("updateDiscountAtPeril", params);
							break;
						}
					}
					if (i >= wperilDisc.size()){
						Map<String, String> params = new HashMap<String, String>();
						params.put("parId", parId.toString());
						params.put("itemNo", gipiWPerilDiscount.get(i).getItemNo());
						params.put("origItemNo", gipiWPerilDiscount.get(i).getItemNo());
						params.put("perilCd", gipiWPerilDiscount.get(i).getPerilCd());
						params.put("origPerilCd", gipiWPerilDiscount.get(i).getPerilCd());
						params.put("sequence", gipiWPerilDiscount.get(i).getSequenceNo());
						params.put("var", "Y");
						System.out.println("Deleting Discount At Peril : "+ params);
						this.sqlMapClient.update("deleteDiscountAtPeril", params);
					}
				}else{
					Map<String, String> params = new HashMap<String, String>();
					params.put("parId", parId.toString());
					params.put("itemNo", gipiWPerilDiscount.get(i).getItemNo());
					params.put("origItemNo", gipiWPerilDiscount.get(i).getItemNo());
					params.put("perilCd", gipiWPerilDiscount.get(i).getPerilCd());
					params.put("origPerilCd", gipiWPerilDiscount.get(i).getPerilCd());
					params.put("sequence", gipiWPerilDiscount.get(i).getSequenceNo());
					params.put("var", "Y");
					System.out.println("Deleting Discount At Peril : "+ params);
					this.sqlMapClient.update("deleteDiscountAtPeril", params);
				}
			}*/
			
			System.out.println("Deleting Records in GIPI_WPERIL_DISCOUNT: "+parId);
			this.sqlMapClient.update("deleteGIPIWPerilDiscount2", parId);
			
			System.out.println("Saving Wperil Discount record/s");
			int cnt = 0;					
			int perilSize = wperilDisc.size();
			for(GIPIWPerilDiscount wperil : wperilDisc){
				Map<String, String> params = new HashMap<String, String>();
				params.put("parId", Integer.toString(wperil.getParId()));
				params.put("itemNo", wperil.getItemNo());
				params.put("perilCd", wperil.getPerilCd());
				params.put("discAmt", wperil.getDiscountAmt()==null?"":wperil.getDiscountAmt().toString());
				params.put("surcAmt", wperil.getSurchargeAmt()==null?"":wperil.getSurchargeAmt().toString());
				cnt++;
				if (toDo.equalsIgnoreCase("Update")){ // added by steve 10/03/2012 condition when updating.
					if (cnt != perilSize-1){
						System.out.println("to " +toDo+ " : Validating discount at PERIL: "+params);	
						this.getSqlMapClient().update("addDiscountAtPeril", params);
						this.getSqlMapClient().insert("setGipiWPerilDiscount", wperil);	
					}
				}else{
					System.out.println("to " +toDo+ " : Adding discount at PERIL: "+params);	
					this.getSqlMapClient().update("addDiscountAtPeril", params);
					this.getSqlMapClient().insert("setGipiWPerilDiscount", wperil);		
				}
			}
			System.out.println("=======================================================================================");
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			return false;
		}
		return true;
	}

	@Override
	public String validateSurchargeAmt(HashMap<String, Object> mainParams)
			throws SQLException{
		String message = "";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Integer parId = (Integer) mainParams.get("parId");
			String lineCd = (String) mainParams.get("lineCd");
			
			if (!saveDiscount(mainParams)){
				throw new Exception();
			}
			
			this.getSqlMapClient().executeBatch();
			Map<String, String> paramsValidate = new HashMap<String, String>();
			paramsValidate.put("parId", parId.toString());
			paramsValidate.put("lineCd", lineCd);
			System.out.println("Start validate surcharge...");
			message = (String) this.getSqlMapClient().queryForObject("validateSurchargeAmtPolDisc", paramsValidate);
			System.out.println("End validate surcharge...");
			
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (SQLException e) {
			message = "SQL Exception occured while validating surcharge amount...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (NullPointerException e) {
			message = "SQL Exception occured while validating surcharge amount...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} catch (Exception e) {
			message = "SQL Exception occured while validating surcharge amount...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().getCurrentConnection().rollback();
			this.getSqlMapClient().endTransaction();
		}	
		return message;
	}

	@Override
	public Map<String, String> getNetItemPrem(HashMap<String, Object> mainParams)
			throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Integer parId = (Integer) mainParams.get("parId");
			String itemNo = (String) mainParams.get("itemNo");
			
			if (!saveDiscount(mainParams)){
				throw new Exception();
			}
			this.getSqlMapClient().executeBatch();
			params.put("parId", parId.toString());
			params.put("itemNo", itemNo);
			this.sqlMapClient.queryForObject("getNetItemPrem", params);
			System.out.println(params);
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().getCurrentConnection().rollback();
			this.getSqlMapClient().endTransaction();
		}	
		return params;
	}

	@Override
	public String validateDiscSurcAmtItem(HashMap<String, Object> mainParams)
			throws SQLException {
		String message = "";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Integer parId = (Integer) mainParams.get("parId");
			String lineCd = (String) mainParams.get("lineCd");
			String itemNo = (String) mainParams.get("itemNo");
			
			if (!saveDiscount(mainParams)){
				throw new Exception();
			}
			
			this.getSqlMapClient().executeBatch();
			Map<String, String> paramsValidate = new HashMap<String, String>();
			paramsValidate.put("parId", parId.toString());
			paramsValidate.put("lineCd", lineCd);
			paramsValidate.put("itemNo", itemNo);
			System.out.println("Start validate discount/surcharge...");
			message = (String) this.getSqlMapClient().queryForObject("validateDiscSurcAmtItemDisc", paramsValidate);
			System.out.println("End validate discount/surcharge...");
			
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (SQLException e) {
			message = "SQL Exception occured while validating surcharge amount...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (NullPointerException e) {
			message = "SQL Exception occured while validating surcharge amount...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} catch (Exception e) {
			message = "SQL Exception occured while validating surcharge amount...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().getCurrentConnection().rollback();
			this.getSqlMapClient().endTransaction();
		}	
		return message;
	}

	@SuppressWarnings("unchecked")
	@Override
	public String getItemPerilsPerItem(HashMap<String, Object> mainParams)
			throws SQLException {
		String message = "";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Integer parId = (Integer) mainParams.get("parId");
			String lineCd = (String) mainParams.get("lineCd");
			String itemNo = (String) mainParams.get("itemNo");
			
			if (!saveDiscount(mainParams)){
				throw new Exception();
			}
			
			this.getSqlMapClient().executeBatch();
			
			Map<String, String> params = new HashMap<String, String>();
			params.put("param1", parId.toString());
			params.put("param2", lineCd);
			params.put("param3", itemNo);
			List<GIPIWItemPeril> list = (List<GIPIWItemPeril>) this.getSqlMapClient().queryForList("getWPerilListing4", params);
			message = new JSONArray((List<GIPIWItemPeril>) StringFormatter.replaceQuotesInList(list)).toString();
			
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (SQLException e) {
			message = "SQL Exception occured while validating surcharge amount...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (NullPointerException e) {
			message = "SQL Exception occured while validating surcharge amount...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} catch (Exception e) {
			message = "SQL Exception occured while validating surcharge amount...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().getCurrentConnection().rollback();
			this.getSqlMapClient().endTransaction();
		}	
		return message;
	}

	@Override
	public Map<String, String> getNetPerilPrem(
			HashMap<String, Object> mainParams) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Integer parId = (Integer) mainParams.get("parId");
			String itemNo = (String) mainParams.get("itemNo");
			String perilCd = (String) mainParams.get("perilCd");
			
			if (!saveDiscount(mainParams)){
				throw new Exception();
			}
			this.getSqlMapClient().executeBatch();
			params.put("parId", parId.toString());
			params.put("itemNo", itemNo);
			params.put("perilCd", perilCd);
			params.put("sequenceNoPeril", mainParams.get("sequenceNoPeril") != null ? mainParams.get("sequenceNoPeril").toString() : "");//Added by Apollo Cruz
			this.sqlMapClient.queryForObject("getNetPerilPrem", params);
			System.out.println(params);
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().getCurrentConnection().rollback();
			this.getSqlMapClient().endTransaction();
		}	
		return params;
	}

	@Override
	public String validateDiscSurcAmtPeril(HashMap<String, Object> mainParams)
			throws SQLException {
		String message = "";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Integer parId = (Integer) mainParams.get("parId");
			String lineCd = (String) mainParams.get("lineCd");
			String itemNo = (String) mainParams.get("itemNo");
			String perilCd = (String) mainParams.get("perilCd");
			
			if (!saveDiscount(mainParams)){
				throw new Exception();
			}
			
			this.getSqlMapClient().executeBatch();
			Map<String, String> paramsValidate = new HashMap<String, String>();
			paramsValidate.put("parId", parId.toString());
			paramsValidate.put("lineCd", lineCd);
			paramsValidate.put("itemNo", itemNo);
			paramsValidate.put("perilCd", perilCd);
			System.out.println("Start validate discount/surcharge...");
			message = (String) this.getSqlMapClient().queryForObject("validateDiscSurcAmtPerilDisc", paramsValidate);
			System.out.println("End validate discount/surcharge...");
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (SQLException e) {
			message = "SQL Exception occured while validating surcharge amount...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (NullPointerException e) {
			message = "SQL Exception occured while validating surcharge amount...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} catch (Exception e) {
			message = "SQL Exception occured while validating surcharge amount...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().getCurrentConnection().rollback();
			this.getSqlMapClient().endTransaction();
		}	
		return message;
	}
}