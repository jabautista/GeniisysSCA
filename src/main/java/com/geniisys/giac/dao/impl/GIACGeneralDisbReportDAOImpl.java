package com.geniisys.giac.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACGeneralDisbReportDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACGeneralDisbReportDAOImpl implements GIACGeneralDisbReportDAO{
	
	private static Logger log = Logger.getLogger(GIACGeneralDisbReportDAOImpl.class);
	
	public SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public String getGIACS273InitialFundCd() throws SQLException {
		log.info("Getting GIACS273 initial fund cd...");
		return (String) this.sqlMapClient.queryForObject("getGIACS273InitialFundCd");
	}

	@Override
	public String validateGIACS273DocCd(Map<String, Object> params) throws SQLException {
		log.info("Validating GIACS273 document cd...");
		return (String) this.sqlMapClient.queryForObject("validateDocCd2", params);
	}
	
	@Override
	public String getGiacs512CutOffDate(String extractYear) throws SQLException {
		log.info("DAO - Getting cut off date for extraction year...");
		return (String) this.getSqlMapClient().queryForObject("getGiacs512CutOffDate", extractYear);
	}

	@Override
	public String validateGiacs512BeforeExtract(Map<String, Object> params) throws SQLException {
		log.info("Validation before extracting...");
		return (String) this.getSqlMapClient().queryForObject("validateGiacs512BeforeExtract", params);
	}

	@Override
	public String validateGiacs512BeforePrint(Map<String, Object> params) throws SQLException {
		log.info("Validation before printing...");
		return (String) this.getSqlMapClient().queryForObject("validateGiacs512BeforePrint", params);
	}

	@Override
	public Map<String, Object> cpcExtractPremComm(Map<String, Object> params) throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			System.out.println("params before: "+params);
			log.info("Extracting claim records based on Paid Premium with Commission...");
			
			this.getSqlMapClient().queryForObject("cpcExtractPremComm", params);
			
			log.info("Extracted claim records based on Paid Premium with Commission.");
			System.out.println("params after: "+params);
		} catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}

	@Override
	public Map<String, Object> cpcExtractOsDtl(Map<String, Object> params) throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			System.out.println("params before: "+params);
			log.info("Extracting claim records based on Outstanding Loss...");
			
			this.getSqlMapClient().queryForObject("cpcExtractOsDtl", params);
			
			log.info("Extracted claim records based on Outstanding Loss.");
			System.out.println("params after: "+params);
		} catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}

	@Override
	public Map<String, Object> cpcExtractLossPaid(Map<String, Object> params) throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			System.out.println("params before: "+params);
			log.info("Extracting claim records based on Losses Paid...");
			
			this.getSqlMapClient().queryForObject("cpcExtractLossPaid", params);
			
			log.info("Extracted claim records based on Losses Paid.");
			System.out.println("params after: "+params);
		} catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}

	@Override
	public String getGiacs190SlTypeCd() throws SQLException {
		return (String) getSqlMapClient().queryForObject("getGiacs190SlTypeCd");
	}
	

	public String giacs149WhenNewFormInstance(String vUpdate) throws SQLException{
		log.info("GIACS149 when new form instance..");
		return(String) this.sqlMapClient.queryForObject("giacs149WhenNewFormInstance", vUpdate);
	}

	public Integer countTaggedVouchers (String intmNo) throws SQLException{
		return (Integer) this.sqlMapClient.queryForObject("countTaggedVouchers", intmNo);
	}
	
	public Map<String, Object> computeGIACS149Totals(Map<String, Object> params) throws SQLException{
		log.info("Computing GIACS149 Totals... ");
		this.sqlMapClient.update("computeGIACS149Totals", params);
		return params;
	}
	
	public String updateCommVoucherAmount(Map<String, Object> params) throws SQLException{
		String msg = "";
		
		try{			
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			this.getSqlMapClient().update("updateGIACS149DtlAmount", params);
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
			
			msg = "SUCCESS";
			
		}catch(Exception e){
			e.printStackTrace();
			params.put("message", "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		
		return msg;
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> updateCommVoucherPrintTag(Map<String, Object> params) throws SQLException{
		String msg = "";
		List<Map<String, Object>> tagged = null;
		String fundCd = null;
		String branchCd = null;
		Integer intmNo = null;
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<Map<String, Object>> vouchers = (List<Map<String, Object>>) params.get("vouchers");
			for (Map<String, Object> v: vouchers){
				//if(!v.get("printTag").equals(v.get("dspPrintTag"))){
					v.put("fromDate", params.get("fromDate"));
					v.put("toDate", params.get("toDate"));
					v.put("workflowColValue", params.get("workflowColValue"));
					v.put("userId", params.get("userId"));
					log.info(v.toString());
					log.info("Updating Print Tag of Commission Voucher with GACC_TRAN_ID of "+v.get("gaccTranId"));
					this.getSqlMapClient().update("updateGIACS149PrintTag", v);
					msg = "SUCCESS";
					fundCd = v.get("gfunFundCd").toString();
					branchCd = v.get("gibrBranchCd").toString();
					intmNo = Integer.parseInt(v.get("intmNo").toString());
				//}
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
			Map<String, Object> p = new HashMap<String, Object>();
			p.put("gfunFundCd", fundCd);
			p.put("gibrBranchCd", branchCd);
			p.put("intmNo", intmNo);
			p.put("fromDate", params.get("fromDate"));
			p.put("toDate", params.get("toDate"));
			p.put("workflowColValue", params.get("workflowColValue"));
			p.put("userId", params.get("userId"));
			
			tagged = (List<Map<String, Object>>) this.sqlMapClient.queryForList("getTaggedRecordsGIACS149", p);
		}catch(Exception e){
			e.printStackTrace();
			params.put("message", "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		
		return tagged;
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getCvPrefGIACS149(Map<String, Object> params) throws SQLException{
		log.info("Getting CV Pref Suf...");
		return (Map<String, Object>) this.sqlMapClient.queryForObject("getCvPrefGIACS149", params);
	}
	
	public Map<String, Object> checkCvSeqGIACS149(Map<String, Object> params) throws SQLException{
		log.info("check_cv_seq GIACS149...");
		this.sqlMapClient.update("checkCvSeqGIACS149", params);
		return params;
	}
	
	public String updateVatGIACS149(Map<String, Object> params) throws SQLException{
		String msg = "";
		
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> vouchers = (List<Map<String, Object>>) params.get("vouchers");
			for(Map<String, Object> v: vouchers){
				log.info("Updating VAT of voucher with gacc_tran_id of "+v.get("gaccTranId"));
				v.put("commissionDue", new BigDecimal(v.get("commissionDue").toString()));
				this.sqlMapClient.update("updateVatGIACS149", v);
				msg = "SUCCESS";
			}
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		}catch(Exception e){
			e.printStackTrace();
			params.put("message", "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.sqlMapClient.endTransaction();
		}
		return msg;
	}
	
	public Map<String, Object> populateCvSeqGIACS149(Map<String, Object> params) throws SQLException{
		Map<String, Object> ret = new HashMap<String, Object>();
		
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> vouchers = (List<Map<String, Object>>) params.get("vouchers");
			for(Map<String, Object> v: vouchers){				
				v.put("cvNo", params.get("cvNo"));
				v.put("cvPref", params.get("cvPref"));
				v.put("docName", params.get("docName"));
				v.put("userId", params.get("userId"));
				v.put("voucherNo",params.get("voucherNo"));
				log.info("populate_cv_seq GIACS149..."+v.toString());
				this.sqlMapClient.update("populateCvSeqGIACS149", v);
				
				ret.put("voucherNo", v.get("voucherNo"));
				ret.put("voucherDate", v.get("voucherDate"));
				ret.put("reprint", v.get("reprint"));
				
				break; // added to ensure that only 1 is being added in GIAC_DOC_SEQUENCE if many records are tagged
			}
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		}catch(Exception e){
			e.printStackTrace();
			params.put("message", "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.sqlMapClient.endTransaction();
		}
		
		return ret;
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> gpcvGetGIACS149(Integer intmNo) throws SQLException{
		log.info("GIACS149 gpcv_get...");
		return (List<Map<String, Object>>) this.sqlMapClient.queryForList("getGpcvGIACS149", intmNo);
	}
	
	public void updateGpcvGIACS169(Map<String, Object> params) throws SQLException{
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> gpcv = (List<Map<String, Object>>) params.get("gpcv");
			for (Map<String, Object> cv: gpcv){
				log.info("Updating GPCV with Gacc_tran_id of "+cv.get("gaccTranId"));
				cv.put("voucherNo", params.get("voucherNo"));
				cv.put("cvPref", params.get("cvPref"));
				cv.put("userId", params.get("userId"));
				this.sqlMapClient.update("updateGpcvGIACS149", cv);
			}
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		}catch(Exception e){
			e.printStackTrace();
			params.put("message", "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.sqlMapClient.endTransaction();
		}
	}
	
	public void delWorkflowRec(Map<String, Object> params) throws SQLException{
		/*log.info("Deleting GIACS149 workflow rec..");
		this.sqlMapClient.update("delWorkflowRecGIACS149", params);*/
		
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> vouchers = (List<Map<String, Object>>) params.get("vouchers");
			for (Map<String, Object> v: vouchers){
				String colValue = v.get("issCd").toString()+"-"+v.get("premSeqNo").toString();
				
				log.info("Deleting GIACS149 workflow rec..");
				v.put("eventDesc", params.get("eventDesc"));
				v.put("moduleId", params.get("moduleId"));
				v.put("userId", params.get("userId"));
				v.put("colValue", colValue);
				this.sqlMapClient.update("delWorkflowRecGIACS149", v);
			}
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		}catch(Exception e){
			e.printStackTrace();
			params.put("message", "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.sqlMapClient.endTransaction();
		}
	}
	
	public void gpcvRestore(Map<String, Object> params) throws SQLException{
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			String fundCd = null;
			String branchCd = null;
			Integer intmNo = null;
			BigDecimal commDue = new BigDecimal("0");
			BigDecimal netCommAmtDue = new BigDecimal("0");
			
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> vouchers = (List<Map<String, Object>>) params.get("vouchers");
			for (Map<String, Object> v: vouchers){
				v.put("appUser", params.get("appUser"));
				v.put("stat", params.get("stat"));
				log.info("GPCV Restore: "+v.toString());
				
				fundCd = v.get("gfunFundCd").toString();
				branchCd = v.get("gibrBranchCd").toString();
				intmNo = Integer.parseInt(v.get("intmNo").toString());
				commDue = commDue.add(new BigDecimal(v.get("commissionDue").toString()));
				netCommAmtDue = netCommAmtDue.add(new BigDecimal(v.get("netCommDue").toString()));
				
				this.sqlMapClient.update("gpcvRestoreGIACS149", v);				
			}
			
			if (params.get("stat").equals("2")){
				Map<String, Object> p = new HashMap<String, Object>();
				p.put("gfunFundCd", fundCd);
				p.put("gibrBranchCd", params.get("ocvBranch"));
				p.put("intmNo", intmNo);
				p.put("commDue", commDue);
				p.put("netCommAmtDue", netCommAmtDue);
				p.put("voucherNo", params.get("voucherNo"));
				p.put("voucherPrefSuf", params.get("voucherPrefSuf"));
				p.put("appUser", params.get("appUser"));
				System.out.println("================== \n INSERTING INTO GIAC_SPOILED_OCV : \n"+p.toString());
				this.sqlMapClient.update("insertSpoiledOCV", p);
			}
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		}catch(Exception e){
			e.printStackTrace();
			params.put("message", "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.sqlMapClient.endTransaction();
		}
	}
	
	@SuppressWarnings("unchecked")
	public String updateUnprintedVoucher(Map<String, Object> params) throws SQLException{
		String msg = "";
		
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<Map<String, Object>> vouchers = (List<Map<String, Object>>) params.get("vouchers");
			for (Map<String, Object> v: vouchers){
				v.put("voucherNo", params.get("voucherNo"));
				v.put("voucherPrefSuf", params.get("voucherPrefSuf"));
				v.put("userId", params.get("userId"));
				System.out.println("Updating unprinted voucher: =========== "+ v.toString());
				this.sqlMapClient.update("updateUnprintedVoucher", v);
			}
			
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
			
			msg = "SUCCESS";
			
		}catch(Exception e){
			e.printStackTrace();
			params.put("message", "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.sqlMapClient.endTransaction();
		}
		
		return msg;
	}
	
	@SuppressWarnings("unchecked")
	public String updateDocSeqGIACS149(Map<String, Object> params) throws SQLException{
		String msg = "";
		
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<Map<String, Object>> vouchers = (List<Map<String, Object>>) params.get("vouchers");
			for (Map<String, Object> v: vouchers){
				v.put("docName", params.get("docName"));
				v.put("userId", params.get("userId"));
				System.out.println("Updating giac_doc_sequence: =========== "+ v.toString());
				this.sqlMapClient.update("updateDocSeqGIACS149", v);
				
				break; // added to ensure that only 1 is being subtracted in GIAC_DOC_SEQUENCE if many records are tagged
			}			
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
			
			msg = "SUCCESS";
			
		}catch(Exception e){
			e.printStackTrace();
			params.put("message", "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.sqlMapClient.endTransaction();
		}
		
		return msg;
	}

	@Override
	public String checkViewRecords(Map<String, Object> params) throws SQLException {
		return (String) getSqlMapClient().queryForObject("checkViewRecords", params);
	}

	@Override
	public void invalidateBankFile(Map<String, Object> param) throws SQLException {
		try {
			log.info("Start of invalidation...");
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Setting paid_sw to I for : " + param);
			this.getSqlMapClient().update("invalidateBankFile", param); 
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e){
			e.printStackTrace();
			param.put("message", "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
		
	}

	@Override
	public void processViewRecords(Map<String, Object> param)throws SQLException {
		try {
			log.info("Start of processing...");
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Deleting records in giac_bank_comm_payt_dtl_ext for : " + param);
			this.getSqlMapClient().delete("deleteTempExt", param.get("appUser")); 
			this.getSqlMapClient().executeBatch();
			
			log.info("Inserting records into temp table...");
			this.getSqlMapClient().update("insertIntoTempTable", param);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e){
			e.printStackTrace();
			param.put("message", "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}

	@Override
	public String generateBankFile(Map<String, Object> params) throws SQLException {
		try {
			log.info("Start of generateBankFile...");
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			String userId = (String) params.get("userId");
			Integer bankFileNo = (Integer) getSqlMapClient().queryForObject("getMaxBankFileNo");
			
			log.info("Setting bank file no for : " + params);
			Map<String, Object> bankFile = new HashMap<String, Object>();
			bankFile.put("appUser", userId);
			bankFile.put("asOfDate", params.get("asOfDate"));
			bankFile.put("intmType", params.get("intmType"));
			bankFile.put("intm", params.get("intm"));
			bankFile.put("bankFileNo", bankFileNo);
			this.getSqlMapClient().insert("setBankFileNo", bankFile); 
			this.getSqlMapClient().executeBatch();
			
			if (params.get("viewSw").equals("Y")) {
				log.info("Inserting records to giacBankCommPayt for bankFileNo: " + bankFile.get("bankFileNo"));
				Map<String, Object> setParam = new HashMap<String, Object>();
				setParam.put("appUser", userId);
				setParam.put("parentIntmNo", params.get("parentIntmNo"));
				setParam.put("bankFileNo", bankFileNo);
				this.getSqlMapClient().insert("setGiacBankCommPayt", setParam); 
				this.getSqlMapClient().executeBatch();
			}
			
			log.info("Inserting records insertToSummTable for bankFileNo:: " + bankFile.get("bankFileNo"));
			Map<String, Object> summParam = new HashMap<String, Object>();
			summParam.put("appUser", userId);
			summParam.put("bankFileNo", bankFileNo);
			this.getSqlMapClient().insert("insertIntoSummTable", summParam); 
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
			return bankFileNo.toString();
		} catch (SQLException e){
			e.printStackTrace();
			params.put("message", "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}

	@Override
	public Map<String, Object> getDetailsTotalViaRecords(Map<String, Object> params) throws SQLException {
		log.info("Getting total ViaRecords...");
		List<?> list = this.getSqlMapClient().queryForList("getDetailsTotalViaRecords", params);
		params.put("list", list);
		return params;
	}

	@Override
	public Map<String, Object> getDetailsTotalViaBankFiles(Map<String, Object> params) throws SQLException {
		log.info("Getting total ViaBankFiles...");
		List<?> list = this.getSqlMapClient().queryForList("getDetailsTotalViaBankFiles", params);
		params.put("list", list);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getSummaryForBank(Map<String, Object> params) throws SQLException {
		return (List<Map<String, Object>>) this.getSqlMapClient().queryForList("getSummaryForBank", params);
	}

	@Override
	public String getCompanyCode() throws SQLException {
		return (String) getSqlMapClient().queryForObject("getCompanyCode");
	}

	@Override
	public void updateFileName(Map<String, Object> params) throws SQLException {
		try {
			log.info("Start of updating file name...");
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Updating file name for bankFileNo: "+params.get("bankFileNo"));
			this.getSqlMapClient().update("updateFileName", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e){
			e.printStackTrace();
			params.put("message", "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	
	@Override
	public Map<String, Object> getTotalViaBankFile(Map<String, Object> params)throws SQLException {
		List<?> list = this.getSqlMapClient().queryForList("getTotalViaBankFile", params);
		params.put("list", list);
		return params;
	}

	@Override
	public Map<String, Object> getTotalViaRecords(Map<String, Object> params)throws SQLException {
		List<?> list = this.getSqlMapClient().queryForList("getTotalViaRecords", params);
		params.put("list", list);
		return params;
	}
	
}
