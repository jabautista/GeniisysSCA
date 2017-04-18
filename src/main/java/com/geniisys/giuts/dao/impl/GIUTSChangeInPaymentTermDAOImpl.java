package com.geniisys.giuts.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.framework.util.Debug;
import com.geniisys.gipi.entity.GIPIInstallment;
import com.geniisys.giuts.dao.GIUTSChangeInPaymentTermDAO;
import com.geniisys.giuts.entity.GIUTSChangeInPaymentTerm;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIUTSChangeInPaymentTermDAOImpl implements GIUTSChangeInPaymentTermDAO {
	private SqlMapClient sqlMapClient;

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/*@Override
	public GIUTSChangeInPaymentTerm getGIUTS022InvoiceInfo(Integer policyId) throws SQLException {
		return (GIUTSChangeInPaymentTerm) getSqlMapClient().queryForObject("getGIUTS022InvoiceInfo", policyId);
	}*/

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> updatePaymentTerm(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			System.out.println("updatePaymentTerm: "+params);
			
			this.getSqlMapClient().update("updatePaymentTerm", params);
			this.getSqlMapClient().executeBatch();
			
			List<GIPIInstallment> newItems = this.sqlMapClient.queryForList("getInstallmentChange", params);
			System.out.println("Size: "+newItems.size());
			params.put("newItems", newItems);
			Debug.print("HERE:" +params);
			
			String commitChanges = (String) params.get("commitChanges");
			if(commitChanges.equals("Y")){
				this.getSqlMapClient().getCurrentConnection().commit();
			}else if(commitChanges.equals("N")){
				this.getSqlMapClient().getCurrentConnection().rollback();
			}
			
			
		}catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch(Exception e){	
			this.getSqlMapClient().getCurrentConnection().rollback();
		}finally{
			this.getSqlMapClient().endTransaction();
		} 
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public String updateDueDate(Map<String, Object> allParams) throws SQLException {
		String message = "SUCCESS";
		List<GIPIInstallment> setRows = (List<GIPIInstallment>) allParams.get("setRows");
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			System.out.println("updateDueDate: "+allParams);
			
			for(GIPIInstallment set : setRows){	
				this.sqlMapClient.insert("updateDueDate", set);
			}
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
		}catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
		}catch(Exception e){	
			this.getSqlMapClient().getCurrentConnection().rollback();
		}finally{
			this.getSqlMapClient().endTransaction();
		} 
		return message;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIInstallment> getInstallmentChange(String issCd, Integer premSeqNo) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("issCd", issCd);
		params.put("premSeqNo", premSeqNo);
		return this.getSqlMapClient().queryForList("getInstallmentChange", params);
	}

	@Override
	public String validateFullyPaid(Map<String, Object> params) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("validateFullyPaid", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> validateInceptExpiry(Map<String, Object> params) throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getDates", params);
	}

	@Override
	public String updateDueDateInvoice(Map<String, Object> allParams) throws SQLException {
		String message = "SUCCESS";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			System.out.println("updateDueDateInvoice: "+allParams);
			
			this.sqlMapClient.insert("updateDueDateInvoice", allParams);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
		}catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
		}catch(Exception e){	
			this.getSqlMapClient().getCurrentConnection().rollback();
		}finally{
			this.getSqlMapClient().endTransaction();
		} 
		return message;
	}

	@Override
	public String checkIfCanChange(Map<String, Object> params) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("checkIfCanChange", params);
	}

	@Override
	public String updateWorkflowSwitch(Map<String, Object> allParams)throws SQLException {
		String message = "SUCCESS(Update Workflow)";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			System.out.println("updateWorkflowSwitch: "+allParams);
			
			this.sqlMapClient.insert("updateWorkflowSwitch", allParams);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
		}catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
		}catch(Exception e){	
			this.getSqlMapClient().getCurrentConnection().rollback();
		}finally{
			this.getSqlMapClient().endTransaction();
		} 
		return message;
	}

	@SuppressWarnings("unchecked")
	@Override
		public Map<String, Object> updateAllocation(Map<String, Object> params) throws SQLException {
		List<GIUTSChangeInPaymentTerm> setRows = (List<GIUTSChangeInPaymentTerm>) params.get("setRows");
		
			try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			for(GIUTSChangeInPaymentTerm set : setRows){	
				this.sqlMapClient.update("updateTaxAllocation", set);
				this.getSqlMapClient().executeBatch();
			}
			
			this.getSqlMapClient().getCurrentConnection().commit();
			
		}catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
		}catch(Exception e){	
			this.getSqlMapClient().getCurrentConnection().rollback();
		}finally{
			this.getSqlMapClient().endTransaction();
		} 
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> updateTaxAllocation(Map<String, Object> allParams) throws SQLException {
		List<GIUTSChangeInPaymentTerm> setRows = (List<GIUTSChangeInPaymentTerm>) allParams.get("setRows");
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			System.out.println("updateTaxAllocation: "+allParams);
			
			this.getSqlMapClient().update("updatePaymentTerm", allParams);
			this.getSqlMapClient().executeBatch();
			
			for(GIUTSChangeInPaymentTerm set : setRows){	
				this.sqlMapClient.update("updateTaxAllocation", set);
				this.getSqlMapClient().executeBatch();
			}
			
			this.getSqlMapClient().update("updateTaxAmt", allParams);
			this.getSqlMapClient().executeBatch();
			
			List<GIPIInstallment> newItems = this.sqlMapClient.queryForList("getInstallmentChange", allParams);
			System.out.println("Size: "+newItems.size());
			allParams.put("newItems", newItems);
			Debug.print("HERE:" +allParams);
			
			this.getSqlMapClient().getCurrentConnection().rollback();
		}catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
		}catch(Exception e){	
			this.getSqlMapClient().getCurrentConnection().rollback();
		}finally{
			this.getSqlMapClient().endTransaction();
		} 
		return allParams;
	}
	
	@Override
	public Map<String, Object> getDueDate(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("getDueDate", params);
		return params;
	}
}
