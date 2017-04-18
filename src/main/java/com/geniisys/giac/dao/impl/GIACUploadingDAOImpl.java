package com.geniisys.giac.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.dao.GIACUploadingDAO;
import com.geniisys.giac.entity.GIACUploadCollnDtl;
import com.geniisys.giac.entity.GIACUploadDvPaytDtl;
import com.geniisys.giac.entity.GIACUploadJvPaytDtl;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACUploadingDAOImpl implements GIACUploadingDAO{
	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public String checkFileName(Map<String, Object> params) throws SQLException {
		// TODO Auto-generated method stub
		return (String) this.getSqlMapClient().queryForObject("checkFileName", params);
	}

	@Override
	public String getATMTag(String sourceCd) throws SQLException {
		// TODO Auto-generated method stub
		return (String) this.getSqlMapClient().queryForObject("getATMTag", sourceCd);
	}

	@Override
	public String getGIACS601ORTag(String sourceCd) throws SQLException {
		// TODO Auto-generated method stub
		return (String) this.getSqlMapClient().queryForObject("getGIACS601ORTag", sourceCd);
	}


	@Override
	public List<String> uploadExcel(Map<String, Object> params, List<Map<String, Object>> recordList)
			throws SQLException, Exception {
		System.out.println("PARAMS IN DAO : " + params);
		BigDecimal hashBill = new BigDecimal("0.00");
		BigDecimal hashCollection = new BigDecimal("0.00");
		String tranTypeCd = (String) params.get("tranTypeCd");
		String paytDate = "";
		String intmNo = "";
		String riCd = "";
		String depositDate = "";
		Integer counter = 1;
		String currency = "";
		String message = "";
		
		List<String> queryList = new ArrayList<String>();
		System.out.println("insert nieko : ");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			System.out.println("insert params nieko : " + params);
			this.getSqlMapClient().update("insertGIACUploadFile", params);
			this.getSqlMapClient().executeBatch();
			
			
			for(Map<String, Object> map : recordList) {
				
				counter++;
				Map<String, Object> paramsToInsert = new HashMap<String, Object>();
				paramsToInsert.put("row", String.valueOf(counter));
				paramsToInsert.put("userId", params.get("userId"));
				paramsToInsert.put("fileNo", params.get("fileNo"));
				paramsToInsert.put("sourceCd", params.get("sourceCd"));
				paramsToInsert.put("atmTag", params.get("atmTag"));
				paramsToInsert.put("hashBill", hashBill.toString());
				paramsToInsert.put("hashCollection", hashCollection.toString());
				
				for(Map.Entry<String, Object> entry : map.entrySet()) {
					
					paramsToInsert.put(entry.getKey(), entry.getValue());
					
					if(entry.getKey().equals("PAYMENT_DATE")){
						if(paytDate.equals(""))
							paytDate = (String) entry.getValue();
					}
					
					if(entry.getKey().equals("INTM_NO")){
						if(intmNo.equals(""))
							intmNo = (String) entry.getValue();
					}
					
					if(entry.getKey().equals("RI_CD")){
						if(riCd.equals(""))
							riCd = (String) entry.getValue();
					}
					
					if(entry.getKey().equals("CURRENCY_CD")){
						if(currency.equals(""))
							currency = (String) entry.getValue();
					}
					
					if(entry.getKey().equals("DEPOSIT_DATE")){
						if(depositDate.equals(""))
							depositDate = (String) entry.getValue();
					}
					
					System.out.println(entry.getKey() + " - " +  entry.getValue());
				}
				
				paramsToInsert.put("checkCurr", currency);
				System.out.println("checkCurr : " + paramsToInsert.get("checkCurr"));
				System.out.println("paramsToInsert : " + paramsToInsert);
				
				if(tranTypeCd.equals("1"))
					this.getSqlMapClient().update("uploadExcelType1", paramsToInsert);
				else if (tranTypeCd.equals("2"))
					this.getSqlMapClient().update("uploadExcelType2", paramsToInsert);
				else if (tranTypeCd.equals("3"))
					this.getSqlMapClient().update("uploadExcelType3", paramsToInsert);
				else if (tranTypeCd.equals("4"))
					this.getSqlMapClient().update("uploadExcelType4", paramsToInsert);
				else if (tranTypeCd.equals("5"))
					this.getSqlMapClient().update("uploadExcelType5", paramsToInsert);
				
				this.getSqlMapClient().executeBatch();
				
				System.out.println(paramsToInsert.get("query"));
				queryList.add((String) paramsToInsert.get("query"));
				
				hashBill = new BigDecimal(paramsToInsert.get("hashBill").toString());
				hashCollection = new BigDecimal(paramsToInsert.get("hashCollection").toString());
			}
			
			System.out.println("hashBill : " + hashBill);
			System.out.println("hashCollection : " + hashCollection);
			System.out.println("paytDate : " + paytDate);
			System.out.println("depositDate : " + depositDate);
			//System.out.println("PARAMS AFTER : " + params);
			
			Map <String, Object> params2 = new HashMap<String, Object>();
			params2.put("userId", params.get("userId"));
			params2.put("orTag", params.get("orTag"));
			params2.put("fileNo", params.get("fileNo"));
			params2.put("sourceCd", params.get("sourceCd"));
			params2.put("atmTag", params.get("atmTag"));
			params2.put("recordsConverted", params.get("recordsConverted"));
			params2.put("hashBill", hashBill.toString());
			params2.put("hashCollection", hashCollection.toString());
			params2.put("paytDate", paytDate);
			params2.put("depositDate", depositDate);
			params2.put("intmNo", intmNo);
			params2.put("riCd", riCd);
			
			System.out.println("params2 nieko: " + params2);
			
			if(tranTypeCd.equals("1"))
				this.getSqlMapClient().update("uploadExcelType1B", params2);
			else if(tranTypeCd.equals("2"))
				this.getSqlMapClient().update("uploadExcelType2B", params2);
			else if (tranTypeCd.equals("3"))
				this.getSqlMapClient().update("uploadExcelType3B", params2);
			else if (tranTypeCd.equals("4"))
				this.getSqlMapClient().update("uploadExcelType4B", params2);
			else if(tranTypeCd.equals("5"))
				this.getSqlMapClient().update("uploadExcelType5B", params2);
				
				
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
			
			return queryList;
			
		} catch (SQLException e) {
			System.out.println("SQLException ROLLBACK!!");
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			System.out.println("Exception ROLLBACK!!");
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> showGiacs603Head(Map<String, Object> params)
			throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getGiacs603Head", params);
	}

	@SuppressWarnings("unchecked")
	public List<String> showGiacs603Legend() throws SQLException {
		return (List<String>) this.getSqlMapClient().queryForList("getGiacs603Legend");
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> showGiacUploadDvPaytDtl(Map<String, Object> params)
			throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getGiacUploadDvPaytDtl", params);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void setGiacs603DVPaytDtl(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACUploadDvPaytDtl> setList = (List<GIACUploadDvPaytDtl>) params.get("setRows");
			for(GIACUploadDvPaytDtl s: setList){
				this.sqlMapClient.update("setGiacs603DVPaytDtl", s);
			}
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	
	@Override
	public void delGiacs603DVPaytDtl(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			this.sqlMapClient.update("delGiacs603DVPaytDtl", params);
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> showGiacUploadJvPaytDtl(Map<String, Object> params)
			throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getGiacUploadJvPaytDtl", params);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void setGiacs603JVPaytDtl(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACUploadJvPaytDtl> setList = (List<GIACUploadJvPaytDtl>) params.get("setRows");
			for(GIACUploadJvPaytDtl s: setList){
				this.sqlMapClient.update("setGiacs603JVPaytDtl", s);
			}
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	
	@Override
	public void delGiacs603JVPaytDtl(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			this.sqlMapClient.update("delGiacs603JVPaytDtl", params);
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	
	@Override
	public void checkDataGiacs603(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			this.sqlMapClient.update("checkDataGiacs603", params);
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	
	@Override
	public void cancelFileGiacs603(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			this.sqlMapClient.update("cancelFileGiacs603", params);
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	
	@Override
	public void validateUploadGiacs603(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("validateUploadGiacs603", params);
	}
	
	public Map<String, Object> getDefaultBank(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("getGiacs603DefaultBank", params);
		return params;
	}
	
	public Map<String, Object> processGiacs603(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("processGiacs603", params);
		return params;
	}
	
	public Map<String, Object> giacs603CheckForOverride(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("giacs603CheckForOverride", params);
		return params;
	}
	
	@Override
	public void giacs603UploadPayments(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("giacs603UploadPayments", params);
	}
	
	@Override
	public Map<String, Object> checkPaymentDetails(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("checkPaymentDetails", params);
		return params;
	}
	
	@Override
	public Map<String, Object> validatePrintOr(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("validatePrintOr", params);
		return params;
	}
	
	@Override
	public Map<String, Object> validatePrintDv(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("validatePrintDv", params);
		return params;
	}
	
	@Override
	public Map<String, Object> validatePrintJv(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("validatePrintJv", params);
		return params;
	}
	
	public Map<String, Object> getGIACS607Parameters(Map<String, Object> params) throws SQLException{	//shan 06.09.2015 : conversion of GIACS607
		System.out.println("Retrieving GIACS607 parameters : " + params.toString());
		this.sqlMapClient.update("getGIACS607Parameters", params);	
		return params;
	}
	
	public String getGIACS607Legend(String rvDomain) throws SQLException{
		System.out.println("Retrieving legend for " + rvDomain);
		return (String) this.sqlMapClient.queryForObject("getGIACS607Legend", rvDomain);
	}
	
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getGIACS607GUFDetails(Map<String, Object> params) throws SQLException{
		System.out.println("Retrieving GIACS607 GUF Details : " + params.toString());
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getGIACS607GUFDetails", params);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getGIACS607GUDVDetails(Map<String, Object> params) throws SQLException{
		System.out.println("Retrieving GIACS607 GUDV Details : " + params.toString());
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getGIACS607GUDVDetails", params);
	}
	
	@SuppressWarnings("unchecked")
	public void saveGIACS607Gudv(Map<String, Object> params) throws SQLException{
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACUploadDvPaytDtl> delList = (List<GIACUploadDvPaytDtl>) params.get("delRows");
			for(GIACUploadDvPaytDtl d: delList){
				System.out.println("Deleting GUDV : " + d.getSourceCd() + "-" + d.getFileNo());
				this.sqlMapClient.update("deleteGIACS607Gudv", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACUploadDvPaytDtl> setList = (List<GIACUploadDvPaytDtl>) params.get("setRows");
			for(GIACUploadDvPaytDtl s: setList){
				System.out.println("Inserting/Updating GUDV : " + s.getSourceCd() + "-" + s.getFileNo());
				this.sqlMapClient.update("setGIACS607Gudv", s);
			}
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getGIACS607GUJVDetails(Map<String, Object> params) throws SQLException{
		System.out.println("Retrieving GIACS607 GUJV Details : " + params.toString());
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getGIACS607GUJVDetails", params);
	}
	
	@SuppressWarnings("unchecked")
	public void saveGIACS607Gujv(Map<String, Object> params) throws SQLException{
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACUploadJvPaytDtl> delList = (List<GIACUploadJvPaytDtl>) params.get("delRows");
			for(GIACUploadJvPaytDtl d: delList){
				System.out.println("Deleting GUJV : " + d.getSourceCd() + "-" + d.getFileNo());
				this.sqlMapClient.update("deleteGIACS607Gujv", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACUploadJvPaytDtl> setList = (List<GIACUploadJvPaytDtl>) params.get("setRows");
			for(GIACUploadJvPaytDtl s: setList){
				System.out.println("Inserting/Updating GUJV : " + s.getSourceCd() + "-" + s.getFileNo());
				this.sqlMapClient.update("setGIACS607Gujv", s);
			}
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	
	@SuppressWarnings("unchecked")
	public void saveGIACS607Gucd(Map<String, Object> params) throws SQLException{
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACUploadCollnDtl> delList = (List<GIACUploadCollnDtl>) params.get("delRows");
			for(GIACUploadCollnDtl d: delList){
				System.out.println("Deleting GUCD : " + d.getSourceCd() + "-" + d.getFileNo() + "-" + d.getItemNo());
				this.sqlMapClient.update("deleteGIACS607Gucd", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACUploadCollnDtl> setList = (List<GIACUploadCollnDtl>) params.get("setRows");
			for(GIACUploadCollnDtl s: setList){
				System.out.println("Inserting/Updating GUCD : " + s.getSourceCd() + "-" + s.getFileNo() + "-" + s.getItemNo());
				this.sqlMapClient.update("setGIACS607Gucd", s);
			}
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	
	public void checkNetCollnGIACS607(Map<String, Object> params) throws SQLException{
		System.out.println("checkNetCollnGIACS607 : " + params.toString());
		this.sqlMapClient.update("checkNetCollnGIACS607", params);
	}
	
	public void updateGIACS607GrossTag(Map<String, Object> params) throws SQLException{
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			System.out.println("updateGIACS607GrossTag : " + params.toString());
			this.sqlMapClient.update("updateGIACS607GrossTag", params);
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	
	public void cancelFileGIACS607(Map<String, Object> params) throws SQLException{
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			System.out.println("cancelFileGIACS607 : " + params.toString());
			this.sqlMapClient.update("cancelFileGIACS607", params);
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	
	public String checkOrPaytsGIACS607(String tranId) throws SQLException{
		System.out.println("checkOrPaytsGIACS607: " + tranId);
		return (String) this.sqlMapClient.queryForObject("checkOrPaytsGIACS607", tranId);
	}
	
	public Map<String, Object> validatePolicyGIACS607(Map<String, Object> params) throws SQLException{
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			System.out.println("validatePolicyGIACS607 : " + params.toString());
			this.sqlMapClient.update("validatePolicyGIACS607", params);
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
		
		return params;
	}
	
	public String checkUserBranchAccessGIACS607(Map<String, Object> params) throws SQLException{
		System.out.println("checkUserBranchAccessGIACS607: " + params.toString());
		return (String) this.sqlMapClient.queryForObject("checkUserBranchAccessGIACS607", params);
	}
	
	public Map<String, Object> checkUploadGIACS607(Map<String, Object> params) throws SQLException{
		System.out.println("checkPaymentBeforeUploadGIACS607: " + params.toString());
		this.sqlMapClient.update("checkPaymentBeforeUploadGIACS607", params);
		
		System.out.println("checkClaimAndOverrideGIACS607: " + params.toString());
		this.sqlMapClient.update("checkClaimAndOverrideGIACS607", params);
		
		return params;
	}
	
	public Integer getParentIntmNoGIACS607(String intmNo) throws SQLException{
		System.out.println("getParentIntmNoGIACS607: " + intmNo);
		
		return (Integer) this.sqlMapClient.queryForObject("getParentIntmNoGIACS607", intmNo);
	}
	
	public void uploadPaymentsGIACS607(Map<String, Object> params) throws SQLException{
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			System.out.println("uploadPaymentsGIACS607 : " + params.toString());
			this.sqlMapClient.update("uploadPaymentsGIACS607", params);
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	
	public void validateBeforeUploadGIACS607(Map<String, Object> params) throws SQLException{
		System.out.println("validateBeforeUploadGIACS607: " + params.toString());
		this.sqlMapClient.update("validateBeforeUploadGIACS607", params);
	}
	
	public Map<String, Object> validateOnPrintBtnGIACS607(Map<String, Object> params) throws SQLException{
		System.out.println("validateOnPrintBtnGIACS607 : " + params.toString());
		this.sqlMapClient.update("validateOnPrintBtnGIACS607", params);
		
		return params;
	} 	//end conversion of GIACS607
	
	
	//john 9.3.2015 - conversion of GIACS604
	@SuppressWarnings("unchecked")
	public Map<String, Object> showGiacs604Head(Map<String, Object> params)
			throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getGiacs604Head", params);
	}
	
	@Override
	public void checkDataGiacs604(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			this.sqlMapClient.update("checkDataGiacs604", params);
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	
	@Override
	public Map<String, Object> giacs604ValidatePrintOr(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("giacs604ValidatePrintOr", params);
		System.out.println("test giacs604 nieko : " + params); //nieko 0824
		return params;
	}
	
	@Override
	public Map<String, Object> giacs604ValidatePrintDv(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("giacs604ValidatePrintDv", params);
		return params;
	}
	
	@Override
	public Map<String, Object> giacs604ValidatePrintJv(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("giacs604ValidatePrintJv", params);
		return params;
	}
	
	@Override
	public void cancelFileGiacs604(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			this.sqlMapClient.update("cancelFileGiacs604", params);
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> showGiacUploadDvPaytDtlGiacs604(Map<String, Object> params)
			throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getGiacs604DvPaytDtl", params);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> showGiacUploadJvPaytDtlGiacs604(Map<String, Object> params)
			throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getGiacs604JvPaytDtl", params);
	}
	
	@Override
	public void checkForClaim(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("checkForClaim", params);
	}
	
	@Override
	public void checkForOverride(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("checkForOverride", params);
	}
	
	@Override
	public void giacs604UploadPayments(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			this.sqlMapClient.update("giacs604UploadPayments", params);
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	
	//john 9.3.2015 - conversion of GIACS608
	@SuppressWarnings("unchecked")
	public List<String> showGiacs608Legend() throws SQLException {
		return (List<String>) this.getSqlMapClient().queryForList("getGiacs608Legend");
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> giacs608Guf(Map<String, Object> params)
			throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getGiacs608Guf", params);
	}
	
	public Map<String, Object> giacs608GiupTableTotal(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("getGiacs608GiupTableTotal", params);
		return params;
	}
	
	@SuppressWarnings("unchecked")
	public void saveGIACS608Gucd(Map<String, Object> params) throws SQLException{
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACUploadCollnDtl> delList = (List<GIACUploadCollnDtl>) params.get("delRows");
			for(GIACUploadCollnDtl d: delList){
				System.out.println("Deleting GUCD : " + d.getSourceCd() + "-" + d.getFileNo() + "-" + d.getItemNo());
				this.sqlMapClient.update("deleteGIACS608Gucd", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACUploadCollnDtl> setList = (List<GIACUploadCollnDtl>) params.get("setRows");
			for(GIACUploadCollnDtl s: setList){
				System.out.println("Inserting/Updating GUCD : " + s.getSourceCd() + "-" + s.getFileNo() + "-" + s.getItemNo());
				this.sqlMapClient.update("setGIACS608Gucd", s);
			}
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> showGiacUploadDvPaytDtlGiacs608(Map<String, Object> params)
			throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getGiacs608DvPaytDtl", params);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> showGiacUploadJvPaytDtlGiacs608(Map<String, Object> params)
			throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getGiacs608JvPaytDtl", params);
	}
	
	@Override
	public void checkDataGiacs608(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			this.sqlMapClient.update("checkDataGiacs608", params);
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	
	@Override
	public void checkCollectionAmountGiacs608(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("checkCollectionAmountGiacs608", params);
	}
	
	@Override
	public void checkPaymentDetailsGiacs608(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("checkPaymentDetailsGiacs608", params);
	}
	
	public Map<String, Object> getParametersGiacs608(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("getParametersGiacs608", params);
		return params;
	}
	
	@Override
	public void proceedUploadGiacs608(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("proceedUploadGiacs608", params);
	}
	
	//GIACS610
	@SuppressWarnings("unchecked")
	public List<String> showGiacs610Legend() throws SQLException {
		return (List<String>) this.getSqlMapClient().queryForList("getGiacs610Legend");
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> showGiacs610Guf(Map<String, Object> params)
			throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getGiacs610Guf", params);
	}
	
	@Override
	public void checkDataGiacs610(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			this.sqlMapClient.update("checkDataGiacs610", params);
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	
	@Override
	public void checkValidatedGiacs610(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("checkValidatedGiacs610", params);
	}
	
	public Map<String, Object> getDefaultBankGiacs610(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("getDefaultBankGiacs610", params);
		return params;
	}
	
	@Override
	public void checkDcbNoGiacs610(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("checkDcbNoGiacs610", params);
	}
	
	/*@Override
	public void uploadPaymentsGiacs610(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("uploadPaymentsGiacs610", params);
	}*/ //Deo [10.06.2016]: comment out
	
	//Deo [10.06.2016]: add start
	@Override
	public void uploadPaymentsGiacs610(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			this.sqlMapClient.update("uploadPaymentsGiacs610", params);
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	
	@Override
	public void validateUploadTranDate(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("validateUploadTranDate", params);
	}
	
	@Override
	public void cancelFileGiacs610(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			this.sqlMapClient.update("cancelFileGiacs610", params);
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	
	@Override
	public Map<String, Object> giacs610ValidatePrintOr(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("giacs610ValidatePrintOr", params);
		return params;
	}
	
	@Override
	public void preUploadCheck(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("preUploadCheck", params);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getValidRecords(Map<String, Object> params) throws SQLException {
		return (List<String>) this.getSqlMapClient().queryForList("getValidRecords", params);
	}
	
	@SuppressWarnings("unchecked")
	public void saveGiacs610JVDtls(Map<String, Object> params) throws SQLException{
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACUploadJvPaytDtl> delList = (List<GIACUploadJvPaytDtl>) params.get("delRows");
			for(GIACUploadJvPaytDtl d: delList){
				System.out.println("Deleting GUJV : " + d.getSourceCd() + "-" + d.getFileNo());
				this.sqlMapClient.update("deleteGiacs610JVDtls", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACUploadJvPaytDtl> setList = (List<GIACUploadJvPaytDtl>) params.get("setRows");
			for(GIACUploadJvPaytDtl s: setList){
				System.out.println("Inserting/Updating GUJV : " + s.getSourceCd() + "-" + s.getFileNo());
				this.sqlMapClient.update("setGiacs610JVDtls", s);
			}
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	//Deo [10.06.2016]: add ends
	
	//Deo: GIACS609 conversion start
	@SuppressWarnings("unchecked")
	public Map<String, Object> showGiacs609Head(Map<String, Object> params) throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getGiacs609Head", params);
	}
	
	@Override
	public String getGiacs609legend() throws SQLException{
		System.out.println("Retrieving GIACS609 Legend");
		return (String) this.sqlMapClient.queryForObject("getGiacs609legend");
	}
	
	@Override
	public Map<String, Object> getGiacs609Parameters(Map<String, Object> params) throws SQLException{
		System.out.println("Retrieving GIACS609 parameters : " + params.toString());
		this.sqlMapClient.update("getGiacs609Parameters", params);
		return params;
	}
	
	@SuppressWarnings("unchecked")
	public void saveGiacs609CollnDtls(Map<String, Object> params) throws SQLException{
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();

			if (params.get("delAll").equals("Y")) {
				Map<String, Object> params2 = new HashMap<String, Object>();
				params2.put("sourceCd", params.get("sourceCd"));
				params2.put("fileNo", params.get("fileNo"));
				System.out.println("Deleting all previous Collection Detail");
				this.sqlMapClient.update("deleteAllGiacs609CollnDtls", params2);
			}
			
			List<GIACUploadCollnDtl> delList = (List<GIACUploadCollnDtl>) params.get("delRows");
			for(GIACUploadCollnDtl d: delList){
				System.out.println("Deleting GUCD : " + d.getSourceCd() + "-" + d.getFileNo() + "-" + d.getItemNo());
				this.sqlMapClient.update("deleteGiacs609CollnDtls", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACUploadCollnDtl> setList = (List<GIACUploadCollnDtl>) params.get("setRows");
			for(GIACUploadCollnDtl s: setList){
				System.out.println("Inserting/Updating GUCD : " + s.getSourceCd() + "-" + s.getFileNo() + "-" + s.getItemNo());
				this.sqlMapClient.update("setGiacs609CollnDtls", s);
			}
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getGiacs609ORCollnDtls(Map<String, Object> params) throws SQLException {
		System.out.println("Retrieving selected OR Collection Details : " + params.toString());
		return this.sqlMapClient.queryForList("getGiacs609ORCollnDtls", params);
	}
	
	@Override
	public void validateCollnAmtGiacs609(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("validateCollnAmtGiacs609", params);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getGiacs609DVDtls(Map<String, Object> params) throws SQLException{
		System.out.println("Retrieving GIACS609 DV Details : " + params.toString());
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getGiacs609DVDtls", params);
	}
	
	@SuppressWarnings("unchecked")
	public void saveGiacs609DVDtls(Map<String, Object> params) throws SQLException{
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACUploadDvPaytDtl> delList = (List<GIACUploadDvPaytDtl>) params.get("delRows");
			for(GIACUploadDvPaytDtl d: delList){
				System.out.println("Deleting GUDV : " + d.getSourceCd() + "-" + d.getFileNo());
				this.sqlMapClient.update("deleteGiacs609DVDtls", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACUploadDvPaytDtl> setList = (List<GIACUploadDvPaytDtl>) params.get("setRows");
			for(GIACUploadDvPaytDtl s: setList){
				System.out.println("Inserting/Updating GUDV : " + s.getSourceCd() + "-" + s.getFileNo());
				this.sqlMapClient.update("setGiacs609DVDtls", s);
			}
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getGiacs609JVDtls(Map<String, Object> params) throws SQLException{
		System.out.println("Retrieving GIACS609 JV Details : " + params.toString());
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getGiacs609JVDtls", params);
	}
	
	@SuppressWarnings("unchecked")
	public void saveGiacs609JVDtls(Map<String, Object> params) throws SQLException{
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACUploadJvPaytDtl> delList = (List<GIACUploadJvPaytDtl>) params.get("delRows");
			for(GIACUploadJvPaytDtl d: delList){
				System.out.println("Deleting GUJV : " + d.getSourceCd() + "-" + d.getFileNo());
				this.sqlMapClient.update("deleteGiacs609JVDtls", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACUploadJvPaytDtl> setList = (List<GIACUploadJvPaytDtl>) params.get("setRows");
			for(GIACUploadJvPaytDtl s: setList){
				System.out.println("Inserting/Updating GUJV : " + s.getSourceCd() + "-" + s.getFileNo());
				this.sqlMapClient.update("setGiacs609JVDtls", s);
			}
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	
	@Override
	public void checkDataGiacs609(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			this.sqlMapClient.update("checkDataGiacs609", params);
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	
	@Override
	public Map<String, Object> validatePrintGiacs609(Map<String, Object> params) throws SQLException{
		this.sqlMapClient.update("validatePrintGiacs609", params);
		return params;
	}
	
	@Override
	public Map<String, Object> uploadBeginGiacs609(Map<String, Object> params) throws SQLException{
		this.sqlMapClient.update("uploadBeginGiacs609", params);
		return params;
	}
	
	@Override
	public Map<String, Object> validateTranDateGiacs609(Map<String, Object> params) throws SQLException{
		this.sqlMapClient.update("validateTranDateGiacs609", params);
		return params;
	}
	
	@Override
	public Map<String, Object> checkUploadAllGiacs609(Map<String, Object> params) throws SQLException{
		this.sqlMapClient.update("checkUploadAllGiacs609", params);
		return params;
	}
	
	@Override
	public void uploadPaymentsGiacs609(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			this.sqlMapClient.update("uploadPaymentsGiacs609", params);
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	
	@Override
	public void cancelFileGiacs609(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			this.sqlMapClient.update("cancelFileGiacs609", params);
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	//Deo: GIACS609 conversion ends
	
	@Override
	public Map<String, Object> giacs608ValidatePrintOr(
			Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("giacs608ValidatePrintOr", params);
		System.out.println("test giacs608 nieko : " + params); //nieko Accounting Uploading GIACS608
		return params;
	}

	@Override
	public void checkDcbNoGiacs604(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("checkDcbNoGiacs604", params);
	}

	@Override
	public void checkDcbNoGiacs603(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("checkDcbNoGiacs603", params);
	}

	@Override
	public void checkDcbNoGiacs608(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("checkDcbNoGiacs608", params);		
	}

	@Override
	public void checkDcbNoGiacs607(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("checkDcbNoGiacs607", params);			
	}

	@Override
	public void checkNetCollnGIACS608(Map<String, Object> params) throws SQLException {
		System.out.println("checkNetCollnGIACS608 : " + params.toString());
		this.sqlMapClient.update("checkNetCollnGIACS608", params);		
	}
}