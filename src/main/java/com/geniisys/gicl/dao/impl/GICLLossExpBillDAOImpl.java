package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gicl.dao.GICLLossExpBillDAO;
import com.geniisys.gicl.entity.GICLLossExpBill;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLLossExpBillDAOImpl implements GICLLossExpBillDAO{
	
	private Logger log = Logger.getLogger(GICLLossExpBillDAOImpl.class);
	
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveLossExpBill(Map<String, Object> params)
			throws SQLException, Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GICLLossExpBill> setGiclLossExpBill = (List<GICLLossExpBill>) params.get("setGiclLossExpBill");
			List<GICLLossExpBill> delGiclLossExpBill = (List<GICLLossExpBill>) params.get("delGiclLossExpBill");
			
			for(GICLLossExpBill delBill : delGiclLossExpBill){
				log.info("Deleting gicl_loss_exp_bill record: claimId="+delBill.getClaimId()+", claim_loss_id="+delBill.getClaimLossId()+ ", payee_class_cd="+delBill.getPayeeClassCd()+
				    ", payee_cd="+delBill.getPayeeCd()+", doc_type="+delBill.getDocType()+" and doc_number="+delBill.getDocNumber());
				this.getSqlMapClient().delete("deleteGiclLossExpBill2", delBill);
				this.getSqlMapClient().executeBatch();
			}
			
			for(GICLLossExpBill setBill : setGiclLossExpBill){
				log.info("Saving gicl_loss_exp_bill record: claimId="+setBill.getClaimId()+", claim_loss_id="+setBill.getClaimLossId()+ ", payee_class_cd="+setBill.getPayeeClassCd()+
					", payee_cd="+setBill.getPayeeCd()+", doc_type="+setBill.getDocType()+" and doc_number="+setBill.getDocNumber());
				this.getSqlMapClient().update("setGiclLossExpBill", setBill);
				this.getSqlMapClient().executeBatch();
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			log.info("Saving Loss Expense Bill successful.");
		}catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
			log.info("End of Saving Loss Expense Bill");
		}
		
	}

	@Override
	public Map<String, Object> chkLossExpBill(Map<String, Object> params) throws SQLException,
			Exception {
		this.getSqlMapClient().queryForObject("chkGiclLossExpBIll",params);
		return params;
		//Added by: Jerome Bautista 05.28.2015 SR 3646
	}
}
