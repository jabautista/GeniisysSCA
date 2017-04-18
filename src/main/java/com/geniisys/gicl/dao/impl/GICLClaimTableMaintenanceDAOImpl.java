/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	Fons
 * Create Date	:	05.03.2013
 ***************************************************/
package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLClaimTableMaintenanceDAO;
import com.geniisys.gicl.entity.GICLClaimPayee;
import com.geniisys.gipi.exceptions.DistributionException;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLClaimTableMaintenanceDAOImpl implements
		GICLClaimTableMaintenanceDAO {
	private Logger log = Logger.getLogger(GICLClaimTableMaintenanceDAOImpl.class);
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	//Claim Payee
	public JSONObject getClaimPayeeClass(HttpServletRequest request,
			Map<String, Object> params) throws SQLException, JSONException {
		Map<String, Object> clmPayeeClassTableGrid = TableGridUtil
				.getTableGrid(request, params);
		JSONObject jsonClmPayeeClass = new JSONObject(clmPayeeClassTableGrid);
		return jsonClmPayeeClass;
	}

	@Override
	public JSONObject getClaimPayeeInfo(HttpServletRequest request,
			Map<String, Object> params) throws SQLException, JSONException {
		Map<String, Object> clmPayeeInfoTableGrid = TableGridUtil.getTableGrid(
				request, params);
		JSONObject jsonClmPayeeInfo = new JSONObject(clmPayeeInfoTableGrid);
		return jsonClmPayeeInfo;
	}
	
	@Override
	public JSONObject getBankAcctHstryField(HttpServletRequest request,
			Map<String, Object> params) throws SQLException, JSONException {
		Map<String, Object> bankAcctHstryFieldTableGrid = TableGridUtil
				.getTableGrid(request, params);
		JSONObject jsonBankAcctHstryField = new JSONObject(
				bankAcctHstryFieldTableGrid);
		return jsonBankAcctHstryField;
	}
	@Override
	public JSONObject getBankAcctHstryValue(HttpServletRequest request,
			Map<String, Object> params) throws SQLException, JSONException {
		Map<String, Object> bankAcctHstryValueTableGrid = TableGridUtil
				.getTableGrid(request, params);
		JSONObject jsonBankAcctHstryValue = new JSONObject(
				bankAcctHstryValueTableGrid);
		return jsonBankAcctHstryValue;
	}

	@Override
	public JSONObject getBankAcctApprovals(HttpServletRequest request,
			Map<String, Object> params) throws SQLException, JSONException {
		Map<String, Object> bankAcctApprovalsTableGrid = TableGridUtil
				.getTableGrid(request, params);
		JSONObject jsonBankAcctApprovals = new JSONObject(
				bankAcctApprovalsTableGrid);
		return jsonBankAcctApprovals;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> saveGicls150(Map<String, Object> params)
			throws SQLException {
		String message = "SUCCESS";
		List<GICLClaimPayee> setRows = (List<GICLClaimPayee>) params.get("setRows");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();			
			for(GICLClaimPayee set : setRows){					
				this.getSqlMapClient().insert("setGICLS150ClaimPayee", set);
				System.out.println(set.getMasterPayeeNo());
			}		
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (DistributionException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: "
					+ e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (SQLException e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: "
					+ e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (NullPointerException e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: "
					+ e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} catch (Exception e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: "
					+ e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		params.put("message", message);		
		return params;
	}
	
	@Override
	public Map<String, Object> validateMobileNo(Map<String, Object> params)
			throws SQLException {	
		HashMap<String, Object> param = new HashMap<String, Object>();	
		param.put("param", (String) params.get("param"));
		param.put("field", (String) params.get("field"));
		param.put("ctype", (String) params.get("ctype"));
		param.put("result", this.sqlMapClient.queryForObject("validateMobileNo",param));
		return param;
	}

	@Override
	public Map<String, Object> validateUserFunc(Map<String, Object> params)
			throws SQLException {
		HashMap<String, Object> param = new HashMap<String, Object>();	
		param.put("user", (String) params.get("user"));
		param.put("funcCode", (String) params.get("funcCode"));
		param.put("moduleName", (String) params.get("moduleName"));
		param.put("result", this.sqlMapClient.queryForObject("validateUserFunc",param));		
		return param;
	}
	
	@Override
	public Map<String, Object> getBankAcctDtls(
			Map<String, Object> params) throws SQLException {
		HashMap<String, Object> param = new HashMap<String, Object>();	
		param.put("payeeClassCd", (String) params.get("payeeClassCd"));		
		param.put("payeeNo", (String) params.get("payeeNo"));
		param.put("result", this.sqlMapClient.queryForObject("getBankAcctDtls",param));
		return param;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> saveBankAcctDtls(Map<String, Object> params)
			throws SQLException {
		String message = "SUCCESS";
		List<GICLClaimPayee> setRows = (List<GICLClaimPayee>) params.get("setRows");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();			
			for(GICLClaimPayee set : setRows){							
				this.sqlMapClient.update("updateBankAcctDtls", set);
			}		
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (DistributionException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: "
					+ e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (SQLException e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: "
					+ e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (NullPointerException e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: "
					+ e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} catch (Exception e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: "
					+ e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		params.put("message", message);		
		return params;
	}
	
	@Override
	public Map<String, Object> approveBankAcctDtls(Map<String, Object> params)
			throws SQLException {
		String message = "SUCCESS";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			HashMap<String, Object> param = new HashMap<String, Object>();	
			param.put("payeeClassCd", (String) params.get("payeeClassCd"));
			if(((String) params.get("payeeNo")).equals("")){
				param.put("payeeNo", null);				
			}else{
				param.put("payeeNo", Integer.parseInt((String) params.get("payeeNo")));
			}				
			param.put("bankAcctAppTag", (String) params.get("bankAcctAppTag"));	
			param.put("userId", (String) params.get("userId"));
			log.info("payeeClassCd: " + param.get("payeeClassCd"));
			log.info("payeeNo: " + param.get("payeeNo"));		
			log.info("bankAcctAppTag: " + param.get("bankAcctAppTag"));		
			log.info("userId: " + param.get("userId"));	
			this.getSqlMapClient().update("approveBankAcctDtls", param);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (DistributionException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: "
					+ e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (SQLException e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: "
					+ e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (NullPointerException e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: "
					+ e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} catch (Exception e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: "
					+ e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		params.put("message", message);		
		return params;
	}	
}
