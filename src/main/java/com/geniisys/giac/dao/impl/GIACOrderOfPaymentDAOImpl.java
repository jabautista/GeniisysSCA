package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.apache.log4j.Logger;
import org.json.JSONException;

import com.geniisys.framework.util.DateUtil;
import com.geniisys.framework.util.Debug;
import com.geniisys.giac.dao.GIACOrderOfPaymentDAO;
import com.geniisys.giac.entity.GIACAccTrans;
import com.geniisys.giac.entity.GIACCollectionDtl;
import com.geniisys.giac.entity.GIACCollnBatch;
import com.geniisys.giac.entity.GIACOrRel;
import com.geniisys.giac.entity.GIACOrderOfPayment;
import com.geniisys.giac.entity.GIACParameter;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.StringFormatter;

public class GIACOrderOfPaymentDAOImpl implements GIACOrderOfPaymentDAO{
	
	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIACOrderOfPaymentDAOImpl.class);
	
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

	@SuppressWarnings("unchecked")
	@Override
	public Integer saveORInformation(Map<String, Object> allParam, Integer gaccTranId)	throws Exception {
		
		Integer tranId;
		if (gaccTranId == 0) {
			tranId = this.getNewTranId(); 
		}else{
			tranId = gaccTranId;
		}
		GIACCollnBatch giacCollnBatch = (GIACCollnBatch) allParam.get("giacCollnBatchDtl");
		GIACAccTrans  giacAcctrans = (GIACAccTrans) allParam.get("giacAcctransDtl");
		GIACOrderOfPayment giacOrderOfPayment = (GIACOrderOfPayment) allParam.get("giacOrderOfPaymentDtl");
		List<GIACCollectionDtl> giacCollectionDtl = (List<GIACCollectionDtl>) allParam.get("giacCollectionDtl");
		String[] itemNoList = (String[]) allParam.get("itemNoList");
		String[] pdcItemIdList = (String[]) allParam.get("pdcItemIdList");
		Map<String, Object> acctEntriesDtl = (Map<String, Object>) allParam.get("acctEntriesDtl");
		acctEntriesDtl.put("gaccTranId", tranId);
		GIACOrRel giacOrRel = (GIACOrRel) allParam.get("giacOrRel");
		Debug.print("ACCT ENTRIES PARAMS: " + acctEntriesDtl);
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.deleteGiacCollectionDetails(tranId, itemNoList, pdcItemIdList);
			this.saveGiacCollnBatchDetails(giacCollnBatch);
			this.saveGiacAcctransDetails(giacAcctrans, tranId);
			this.saveGiacOrderOfPaymentDetails(giacOrderOfPayment, tranId);
			this.saveGiacCollectionDetails(giacCollectionDtl, tranId, giacOrderOfPayment);
			if(allParam.get("cancelledOrPrefSuf") != ""){
				this.saveGiacOrRel(giacOrRel, tranId, giacOrderOfPayment); //added john 10.22.2014
			}
			
			this.getSqlMapClient().executeBatch(); // andrew - 03.20.2013
			this.getSqlMapClient().update("updateGIACOrderOfPaytCollectionAmt", tranId); // andrew - 03.20.2013 - update the giac_order_of_payt collection_amt gross_amt 
			
			this.getSqlMapClient().insert("aegParametersGIACS001", acctEntriesDtl);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
		}catch (SQLException e) {
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
	    return tranId;
	}

	public boolean saveGiacCollnBatchDetails(GIACCollnBatch giacCollnBatch) throws SQLException{
		log.info("Saving GIACCollnBatch Details...");
		boolean result = true;
		Debug.print("DCB NO: " + giacCollnBatch.getDcbNo() + " DCB YEAR: " + giacCollnBatch.getDcbYear() + " fundCd: " + giacCollnBatch.getFundCd() + " branch: " + giacCollnBatch.getBranchCd());
		this.getSqlMapClient().insert("saveGiacCollnBatchDetails", giacCollnBatch);	
		log.info("Saving Result:"+result);
		return result;
	}
	
	public boolean saveGiacOrderOfPaymentDetails(GIACOrderOfPayment giacOrderOfPayment, int newTranId) throws SQLException{
		log.info("Saving GIACOrderOfPayment Details...");
		boolean result = true;
		giacOrderOfPayment.setGaccTranId(newTranId);
		System.out.println("APPUSER DAO: " + giacOrderOfPayment.getUserId());
		this.getSqlMapClient().insert("saveGIACOrderOfPaymentDetails", giacOrderOfPayment);	
		log.info("Saving Result:"+result);
		return result;
	}
	
	public boolean saveGiacAcctransDetails(GIACAccTrans giacAcctrans, int newTranId) throws SQLException{
		log.info("Saving GIACAcctrans Details...");
		boolean result = true;
		giacAcctrans.setTranId(newTranId);
		this.getSqlMapClient().insert("saveGiacAcctransDetails", giacAcctrans);	
		log.info("Saving Result:"+result);
		return result;
	}
	
	public Integer getNewTranId() throws SQLException{
		Integer newTranId = 0;
		newTranId = (Integer) this.getSqlMapClient().queryForObject("getNewTranId");
		return newTranId;
	}
	
	/**
	 * added orDate and dcbNo - irwin 7.23.2012
	 * */
	
	public boolean saveGiacCollectionDetails(List<GIACCollectionDtl> giacCollectionDtl, int newTranId, GIACOrderOfPayment giacOrderOfPayment) throws SQLException{
		log.info("Saving GIACCollectionDtl Details...");
		boolean result = true;
		System.out.println("no and date: "+giacOrderOfPayment.getDcbNo()+" "+giacOrderOfPayment.getOrDate());
		Date orDate = DateUtil.setZeroTimeValues(giacOrderOfPayment.getOrDate());
		Date checkDate = null;
		for(GIACCollectionDtl giacCollection: giacCollectionDtl){
			checkDate = null;
			if(!giacCollection.getPayMode().equals("PDC")){
				
				System.out.println("payment mode: "+ giacCollection.getPayMode());
				System.out.println("orDate: "+orDate);
				
				if(giacCollection.getPayMode().equals("CHK")) {
					checkDate = DateUtil.setZeroTimeValues(giacCollection.getCheckDate());
					System.out.println("checkDAte: "+checkDate);
					if(giacCollection.getCheckDate().compareTo(giacOrderOfPayment.getOrDate()) > 0){
						giacCollection.setDueDcbDate(null);
						giacCollection.setDueDcbNo(null);
					}else{
						giacCollection.setDueDcbDate(giacOrderOfPayment.getOrDate());
						giacCollection.setDueDcbNo(giacOrderOfPayment.getDcbNo());
					}
				}else{
					giacCollection.setDueDcbDate(giacOrderOfPayment.getOrDate());
					giacCollection.setDueDcbNo(giacOrderOfPayment.getDcbNo());
				}
				
				if(!giacCollection.getParticulars().isEmpty() ) { //robert 10.21.2013
					String particulars = StringFormatter.unescapeHtmlJava(giacCollection.getParticulars());
					giacCollection.setParticulars(particulars);
				}
				if(!giacCollection.getCheckNo().isEmpty() ) { //robert 11.12.14 
					String checkNo = StringFormatter.unescapeHtmlJava(giacCollection.getCheckNo());
					giacCollection.setCheckNo(checkNo);
				}
			} else if (giacCollection.getPayMode().equals("PDC")){
				Map<String, Object> params = new HashMap<String, Object>();
				if(giacOrderOfPayment.getOrTag().equals("M")){
					params.put("refNo", giacOrderOfPayment.getOrPrefSuf()+"-"+giacOrderOfPayment.getOrNo());
				}
				params.put("itemId", giacCollection.getItemId());
				params.put("gaccTranId", newTranId);
				params.put("bankCd", giacCollection.getBankCd());
				params.put("checkNo", giacCollection.getCheckNo());
				params.put("checkDate", giacCollection.getCheckDate());
				params.put("amount", giacCollection.getAmt());
				params.put("currencyCd", giacCollection.getCurrencyCd());
				params.put("currencyRt", giacCollection.getCurrencyRt());
				params.put("fcurrencyAmt", giacCollection.getfCurrencyAmt());
				params.put("userId", giacCollection.getAppUser());
				params.put("particulars", giacCollection.getParticulars());
				params.put("itemNo", giacCollection.getItemNo());
				params.put("fundCd", giacOrderOfPayment.getGibrGfunFundCd());
				params.put("branchCd", giacOrderOfPayment.getGibrBranchCd());
				
				this.getSqlMapClient().insert("insertGiacPdcChecks", params);
			}
			
			giacCollection.setGaccTranId(newTranId);
			Debug.print(giacCollection);
			this.getSqlMapClient().insert("saveGiacCollectionDetails", giacCollection);	
		}
		log.info("Saving Result:"+result);
		return result;
	}
	
	public boolean deleteGiacCollectionDetails(Integer gaccTranId, String[] itemList, String[] pdcItemIdList) throws SQLException{
		log.info("Deleting CollectionDtl Details...");
		boolean result = true;
		for (int i=0;i<itemList.length;i++){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("gaccTranId", gaccTranId);
			params.put("itemNo", itemList[i]);
			System.out.println("itemNo"+ itemList[i]);
			this.getSqlMapClient().insert("deleteGiacCollectionDetails", params);	
		}
		
		for (int i=0;i<pdcItemIdList.length;i++){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("itemId", pdcItemIdList[i]);
			this.getSqlMapClient().insert("deletePdcChecks", params);	
		}
		
		log.info("Delete Result:"+result);
		return result;
	}
	
	public boolean updateGiacOrderOfPaymentDetails(Integer gaccTranId) throws SQLException{
		log.info("Updating CollectionDtl Details...");
		boolean result = true;
		this.getSqlMapClient().insert("updateGiacOrderOfPaymentDetails", gaccTranId);	
		log.info("Update Result:"+result);
		return result;
	}

	@Override
	public GIACOrderOfPayment validateCancelledORInput(String orPrefSuf, Integer orNo) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("orPrefSuf", orPrefSuf);
		params.put("orNo", orNo);
		return (GIACOrderOfPayment) this.getSqlMapClient().queryForObject("validateCancelledORInput", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACOrderOfPaymentDAO#getGIACOrderOfPaymentDtl(int)
	 */
	@Override
	public GIACOrderOfPayment getGIACOrderOfPaymentDtl(int tranId)
			throws SQLException {
		return (GIACOrderOfPayment) this.getSqlMapClient().queryForObject("getGIACOrderOfPayts", tranId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACOrderOfPaymentDAO#getRVMeaning(java.lang.String, java.lang.String)
	 */
	@Override
	public String getRVMeaning(String rvDomain, String rvLowValue)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("rvDomain", rvDomain);
		params.put("rvLowValue", rvLowValue);
		return (String) this.getSqlMapClient().queryForObject("getRVMeaning", params);
	}

	@Override
	public String getOrTag(Integer tranID) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getOrTag", tranID);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getORList(Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getORList", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACOrderOfPaymentDAO#getGIACOrDtl(int)
	 */
	@Override
	public GIACOrderOfPayment getGIACOrDtl(int tranId) throws SQLException {
		return (GIACOrderOfPayment) this.getSqlMapClient().queryForObject("getGIACOrDtl", tranId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACOrderOfPaymentDAO#updateAllPayorItmDtls(java.util.Map)
	 */
	@Override
	//public Map<String, Object> updateAllPayorItmDtls(Map<String, Object> params)	throws SQLException {
	public void updateAllPayorItmDtls(List<Map<String, Object>> params)	throws Exception {
		Debug.print(params);
		//return ( Map<String, Object>) this.getSqlMapClient().queryForObject("updateAllPayorItmDtls", params);
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			for (int p=0; p<params.size();p++) {
				this.getSqlMapClient().update("updateAllPayorItmDtls", params.get(p));
			}
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
		}catch (SQLException e) {
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
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACOrderOfPaymentDAO#updateSelectedPayorItmDtls(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> updateSelectedPayorItmDtls(Map<String, Object> params) throws SQLException {
		Debug.print(params);
		return ( Map<String, Object>) this.getSqlMapClient().queryForObject("updateSelectedPayorItmDtls", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACOrderOfPaymentDAO#spoilOR(java.util.Map)
	 */
	@Override
	public void spoilOR(Map<String, Object> params) throws SQLException, Exception {
		try{
		this.getSqlMapClient().startTransaction();
		this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
		this.getSqlMapClient().startBatch();
		System.out.println("BEFORE SPOIL: " + params);
		this.getSqlMapClient().queryForObject("spoilOR", params);
		this.getSqlMapClient().executeBatch();
		System.out.println("After SPOIL: " + params);
		if (params.get("message") == null || params.get("message").toString().equals("")){
			this.getSqlMapClient().getCurrentConnection().commit();
		}else{
			this.getSqlMapClient().getCurrentConnection().rollback();
		}
		
		}catch (SQLException e) {
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
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACOrderOfPaymentDAO#getORListTableGrid(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getORListTableGrid(
			Map<String, Object> params) throws SQLException {
		System.out.println(params);
		return this.getSqlMapClient().queryForList("getORListTableGrid", params); // replaced by: Nica 06.15.2012
		//return this.getSqlMapClient().queryForList("getORListTableGrid2", params);
	}

	@Override
	public Map<String, Object> giacs050InsUpdGIOP(Map<String, Object> params)
			throws SQLException {
		String isCommit = "Y";
		try{
			log.info("Updating giac order of payts OR Flag...");
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().queryForObject("giacs050InsUpdGIOP", params);
			
			isCommit = (String) params.get("pResult");
			log.info("IS GIOP UPDATED - "+isCommit);
			
			this.getSqlMapClient().executeBatch();
			if("Y".equals(isCommit.toUpperCase())) {
				insUpdORGiacs050(params);
				
				GIACParameter giacp = (GIACParameter) this.getSqlMapClient().queryForObject("getGIACParamValueV", "UPLOAD_IMPLEMENTATION_SW");
				String giacpV = giacp.getParamValueV();
				System.out.println("GIACPARAMETER.V === "+giacpV);
				
				this.getSqlMapClient().startBatch();
				if(giacpV == "Y") {
					Integer gaccTranId = (Integer) params.get("tranId");
					this.getSqlMapClient().update("uploadDCPGIACS050", gaccTranId);
				} else {
					Debug.print("giacs050InsUpdGIOP DAO - "+params);
					this.getSqlMapClient().update("updateAccGiacs050", params);
				}
				this.getSqlMapClient().executeBatch();
				this.getSqlMapClient().getCurrentConnection().commit();
			} else {
				this.getSqlMapClient().getCurrentConnection().rollback();
			}
		}catch (SQLException e) {
			if(e.getMessage().indexOf("ORA-00001") > 0 && e.getErrorCode() == 1) {
				log.error("error code : "+e.getErrorCode());
				isCommit="ORA1";
			} else {
				isCommit = "N";
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			}
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (Exception e) {
			isCommit = "N";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} finally {
			params.put("pResult", isCommit);
			this.getSqlMapClient().endTransaction();
		}	
		return params;
	}
	
	@Override
	public String getUpdatedPayorIntmDtls(Map<String, Object> params)
			throws SQLException {
		
		return (String) this.getSqlMapClient().queryForObject("getUpdatedPayorItmDtls", params);
	}

	@Override
	public Map<String, Object> spoilPrintedOR(Map<String, Object> params)
			throws SQLException {
		try{
			log.info("DAO - Spoil printed OR...");
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			this.getSqlMapClient().startBatch();
			
			GIACParameter giacp = (GIACParameter) this.getSqlMapClient().queryForObject("getGIACParamValueV", "UPLOAD_IMPLEMENTATION_SW");
			String giacpV = giacp.getParamValueV();
			System.out.println("GIACPARAMETER.V === "+giacpV);
			
			this.getSqlMapClient().queryForObject("giacs050InsUpdGIOP", params);
			String isCommit = (String) params.get("pResult");
			log.info("IS GIOP UPDATED - "+isCommit);
			
			this.getSqlMapClient().executeBatch();
			
			if(isCommit.toUpperCase().equals("Y")) {
				insUpdORGiacs050(params);
				params.remove("pResult");
				Debug.print(params);
				this.getSqlMapClient().startBatch();
				this.getSqlMapClient().queryForObject("spoilPrintedOR", params);
				System.out.println("Is OR spoiled??? --- "+params.get("pResult"));
				this.getSqlMapClient().executeBatch();
			}
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}
	
	private void insUpdORGiacs050(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startBatch();
			log.info("Update/Insert to Doc Sequence - "+params.get("orType"));
			Map<String, Object> newMap = new HashMap<String, Object>();
			
			newMap.put("tranId", params.get("tranId"));
			newMap.put("branchCd", (String) params.get("branchCd"));
			newMap.put("fundCd", (String) params.get("fundCd"));
			newMap.put("userId", (String) params.get("userId"));
			newMap.put("orNo", (Integer) params.get("orNo"));
			newMap.put("orPRef", (String) params.get("orPref"));
			String orType = (String) params.get("orType");
			orType = orType.toUpperCase();
			if(orType.equals("V")) {
				newMap.put("docName", "VAT OR");
			} else if(orType.equals("N")) {
				newMap.put("docName", "NON VAT OR");
			} else {
				newMap.put("docName", "MISC_OR");
			}
			System.out.println("doc name for update : "+newMap.get("docName"));
			this.getSqlMapClient().insert("insUpdORGiacs050", newMap);
			this.getSqlMapClient().executeBatch();
		}catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} 
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getCreditMemoDtls(String fundCd) throws SQLException {
		return this.getSqlMapClient().queryForList("getCreditMemoDtls", fundCd);
	}

	@Override
	public String checkAttachedOR(Map<String, Object> params)
			throws SQLException {
		log.info("Checking if an attached O.R. exists...");
		return (String) this.getSqlMapClient().queryForObject("checkAttachedOR", params);
	}

	@Override
	public String validateOr(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateOr", params);
	}

	@Override
	public Map<String, Object> insUpdGIOPNewOR(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("getNewOrOnError", params);
		log.info("insUpdGIOPNewOR :: "+params);
		Map<String, Object> params2 = this.giacs050InsUpdGIOP(params);
		return params2;
	}

	/*@Override
	public void validateOR2(Map<String, Object> params)
			throws SQLException, InterruptedException {
		try{
			Random generator = new Random();
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			int roll = generator.nextInt(99)*10;
			Thread.sleep(roll); //random delay
			
			String editOrNo = (String) params.get("editOrNo");
			
			if(editOrNo.equals("N")) {
				this.getSqlMapClient().startBatch();
				this.getSqlMapClient().update("updateGIOPGiacs050", params);
				this.getSqlMapClient().executeBatch();
				System.out.println("[DAO] updateGIOPGiacs050 results - "+params);
			}
			
			roll = generator.nextInt(99)*10;
			Thread.sleep(roll);
			
			System.out.println("[DAO] validateOR2 - "+params);
			this.getSqlMapClient().update("validateOR2", params);
			System.out.println("[DAO] validateOR2 results - "+params);
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			e.printStackTrace();
			log.info("error code : "+e.getErrorCode());
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}*/
	@Override
	public void validateOR2(Map<String, Object> params)
			throws SQLException, InterruptedException {
		try{
			Random generator = new Random();
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			int roll = generator.nextInt(99)*10;
			Thread.sleep(roll); //random delay
			
			String editOrNo = (String) params.get("editOrNo");
			
			if(editOrNo.equals("N")) {
				Integer orFlagSw = 0;
				int i=0;
				while (i==0) {
					orFlagSw = (Integer) this.getSqlMapClient().queryForObject("getGIACParamValueN", "OR_FLAG_SW");
					orFlagSw = orFlagSw == null ? 0 : orFlagSw;
					System.out.println("OR FLAG SW - "+orFlagSw);
					
					if(orFlagSw == null || orFlagSw == 0) {
						this.getSqlMapClient().startBatch();
						this.getSqlMapClient().update("toggleOrFlagSw", 1);
						this.getSqlMapClient().executeBatch();
						
						this.getSqlMapClient().startBatch();
						this.getSqlMapClient().update("updateGIOPGiacs050Part1", params);
						this.getSqlMapClient().executeBatch();
						
						System.out.println("[DAO] updateGIOPGiacs050 results part 1 - "+params);
						orFlagSw = (Integer) this.getSqlMapClient().queryForObject("getGIACParamValueN", "OR_FLAG_SW");
						orFlagSw = orFlagSw == null ? 0 : orFlagSw;
						i=1;
						break;
					}
				}
				
				System.out.println("Updating GIOP, part 2 - "+params);
				this.getSqlMapClient().startBatch();
				this.getSqlMapClient().update("updateGIOPGiacs050Part2", params);
				System.out.println("[DAO] updateGIOPGiacs050 results part 2 - "+params);
				this.getSqlMapClient().executeBatch();
				
				System.out.println("Updating GIOP, part 3 - "+params);
				this.getSqlMapClient().startBatch();
				this.getSqlMapClient().update("updateGIOPGiacs050Part3", params);
				System.out.println("[DAO] updateGIOPGiacs050 results part 3 - "+params);
				this.getSqlMapClient().executeBatch();
			}
			/*if(editOrNo.equals("N")) {
				this.getSqlMapClient().startBatch();
				this.getSqlMapClient().update("updateGIOPGiacs050", params);
				this.getSqlMapClient().executeBatch();
				System.out.println("[DAO] updateGIOPGiacs050 results - "+params);
			}
			*/
			
			System.out.println("[DAO] validateOR2 - "+params);
			this.getSqlMapClient().update("validateOR2", params);
			System.out.println("[DAO] validateOR2 results - "+params);
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			e.printStackTrace();
			log.info("error code : "+e.getErrorCode());
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			// added this codes, 12/3/2012, para hindi maglock ang printing kung sakaling may mag-error
			// sa mga procedure 
			this.getSqlMapClient().startBatch();
			this.getSqlMapClient().update("toggleOrFlagSw", 0);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public Map<String, Object> generateNewOR(Map<String, Object> params)
			throws SQLException, InterruptedException {
		try{
			Random generator = new Random();
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			int roll = generator.nextInt(99)*10;
			Thread.sleep(roll); //random delay
			//this.getSqlMapClient().update("getNewOrOnError", params); 
			this.getSqlMapClient().startBatch();
			this.getSqlMapClient().update("updateGIOPGiacs050", params);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			e.printStackTrace();
			log.info("error code : "+e.getErrorCode());
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
		return params;
	}

	@Override
	public void processPrintedOR(Map<String, Object> params)
			throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			this.getSqlMapClient().startBatch();
			this.getSqlMapClient().update("insUpdGIOP", params);
			this.getSqlMapClient().executeBatch();
			
			insUpdORGiacs050(params);
			
			GIACParameter giacp = (GIACParameter) this.getSqlMapClient().queryForObject("getGIACParamValueV", "UPLOAD_IMPLEMENTATION_SW");
			String giacpV = giacp.getParamValueV();
			System.out.println("GIACPARAMETER.V === "+giacpV);
			if(giacpV.equals("Y")) {
				this.getSqlMapClient().update("uploadDCPGIACS050", (Integer) params.get("tranId"));
			} 
			this.getSqlMapClient().startBatch();	
			this.getSqlMapClient().update("updateAccGiacs050", params);
			this.getSqlMapClient().executeBatch();	
			
			this.getSqlMapClient().startBatch();
			this.getSqlMapClient().update("updGORRGiacs050", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			e.printStackTrace();
			log.info("error code : "+e.getErrorCode());
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
	}

	@Override
	public void checkCommPayts(Integer gaccTranId) throws SQLException {
		this.getSqlMapClient().update("checkCommPayts", gaccTranId);
	}

	@Override
	public void delOR(Map<String, Object> params) throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Printing was not successful: Deleting OR No. tranId="+params.get("tranId"));
			this.getSqlMapClient().delete("delGIACS050OR", params);
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			e.printStackTrace();
			log.info("error code : "+e.getErrorCode());
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
		
	}
	
	@Override
	public String getPayorIntmDtls(int tranId) throws SQLException,
			JSONException {
		return (String) this.getSqlMapClient().queryForObject("getPayor", tranId);
	}
	
	@Override
	public void populateBatchORTempTable(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("populateBatchORTempTable", params);
	}

	@Override
	public String checkOR(String gaccTranId) throws SQLException {
		try{
			return (String) this.getSqlMapClient().queryForObject("checkOR", gaccTranId);
		}catch(SQLException e){
			e.printStackTrace();
			throw e;
		}
	}
	
	@Override
	public Map<String, Object> checkAllORs(Map<String, Object> params)
			throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Tagging all ORs...");
			this.getSqlMapClient().update("checkAllORs", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
			return params;
		} catch (SQLException e) {
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	
	@Override
	public void uncheckAllORs() throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Untagging all ORs...");
			this.getSqlMapClient().update("uncheckAllORs");
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public Map<String, Object> getDefaultORValues(Map<String, Object> params)
			throws SQLException {
		try{
			String oneORSequence = (String) params.get("oneORSequence");
			String vatNonVatSeries = (String) params.get("vatNonVatSeries");
			
			if(oneORSequence.equals("Y")){
				if(vatNonVatSeries.equals("V")){
					this.getSqlMapClient().update("getDefaultVatOR", params);
				}else if(vatNonVatSeries.equals("N")){
					this.getSqlMapClient().update("getDefaultNonVatOR", params);
				}else if(vatNonVatSeries.equals("M")){
					this.getSqlMapClient().update("getDefaultOtherOR", params);
				}
			}else{
				this.getSqlMapClient().update("getDefaultVatOR", params);
				this.getSqlMapClient().update("getDefaultNonVatOR", params);
			}
			
			return params;
		}catch(SQLException e){
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public void generateOrNumbers(Map<String, Object> params)
			throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Generating OR Numbers...");
			this.getSqlMapClient().update("generateOrNumbers", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getBatchORReportParams(
			Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<Map<String, Object>> batchORReportParams = new ArrayList<Map<String, Object>>();
			Integer orFlagSw = (Integer) this.getSqlMapClient().queryForObject("getGIACParamValueN", "OR_FLAG_SW");
			orFlagSw = orFlagSw == null ? 0 : orFlagSw;
			
			if(orFlagSw == 0){
				log.info("Retrieving Batch ORs...");
				this.getSqlMapClient().update("toggleOrFlagSw", 1);
				batchORReportParams = this.getSqlMapClient().queryForList("getBatchORReportParams", params);
				this.getSqlMapClient().update("toggleOrFlagSw", 0);
			}
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
			return batchORReportParams;
		}catch(SQLException e){
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGenerateFlag(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Saving Generate Flag...");
			
			List<Map<String, Object>> setRows = (List<Map<String, Object>>) params.get("setRows");
			Map<String, Object> param = new HashMap<String, Object>();
			for(Map<String, Object> row : setRows){
				param.put("gaccTranId", row.get("gaccTranId"));
				param.put("generateFlag", row.get("generateFlag"));
				this.getSqlMapClient().update("updateGenerateFlag", param);
			}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public void processPrintedBatchOR(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Processing printed OR's...");
			this.getSqlMapClient().update("processPrintedBatchOR", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public String checkLastPrintedOR(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkLastPrintedOR", params);
	}

	@Override
	public void spoilBatchOR(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Spoiling Batch OR...");
			this.getSqlMapClient().update("spoilBatchOR", params);
			this.getSqlMapClient().executeBatch();
			
			if(params.get("lastOrNo") != null || !params.get("lastOrNo").toString().equals("")){
				log.info("Processing printed OR's...");
				this.getSqlMapClient().update("processPrintedBatchOR", params);
				this.getSqlMapClient().executeBatch();
			}
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public void spoilSelectedOR(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Spoiling Selected OR...");
			this.getSqlMapClient().update("spoilSelectedOR", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}
	
	@Override
	public Map<String, Object> getBatchCommSlipParams() throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		this.getSqlMapClient().update("getBatchCommSlipParams", params);
		return params;
	}
	
	public Integer countVehiclesInsured(Integer assdNo) throws SQLException{
		return (Integer) this.sqlMapClient.queryForObject("countVehiclesInsured", assdNo);
	}

	@Override
	public String checkAPDCPaytDtl(Integer gaccTranId) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkAPDCPaytDtl", gaccTranId);
	}
	
	//john 10.15.2014
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getCnclCollnBreakDown(Integer gaccTranId) throws SQLException {
		return this.sqlMapClient.queryForList("getCnclCollnBreakDown", gaccTranId);
	}
	
	//john 10.20.2014
	public GIACOrRel getGiacOrRel(Integer gaccTranId) throws SQLException {
		return (GIACOrRel) this.getSqlMapClient().queryForObject("getGiacOrRel", gaccTranId);
	}
	
	//john 10.22.2014
	public void saveGiacOrRel(GIACOrRel giacOrRel, Integer tranId, GIACOrderOfPayment giacOrderOfPayment) throws SQLException{
		log.info("Saving GIACOrRel...");
		giacOrRel.setTranId(tranId);
		/*if(!giacOrderOfPayment.getOrTag().equals("M")){ //Commented out by Jerome Bautista 11.26.2015 SR 20817
			giacOrRel.setNewOrPrefSuf(null);
			giacOrRel.setNewOrNo(null);
		}*/
		Debug.print("JOHN [saving giacOrRel]: tranId:" + giacOrRel.getTranId()+ " newOrDate: " + giacOrRel.getNewOrDate() + " oldTranId: " + 
					giacOrRel.getOldTranId() + " oldOrNo: " + giacOrRel.getOldOrNo() + " oldOrdate: " + giacOrRel.getOldOrDate() +
					" newOrPrefSuf: " + giacOrRel.getNewOrPrefSuf() + " newOrNo: " + giacOrRel.getNewOrNo() + 
					" newOrTag: " + giacOrRel.getNewOrTag() + " oldOrPrefSuf: " + giacOrRel.getOldOrPrefSuf() +  " oldOrTag: " + giacOrRel.getOldOrTag());
		this.getSqlMapClient().insert("saveGiacOrRel", giacOrRel);	
	}
	
	@Override
	public void checkRecordStatus(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().queryForObject("checkAcctRecordStatus", params);
	}
}
