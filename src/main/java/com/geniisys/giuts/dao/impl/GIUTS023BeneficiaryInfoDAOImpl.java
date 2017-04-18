package com.geniisys.giuts.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIGroupedItems;
import com.geniisys.gipi.entity.GIPIGrpItemsBeneficiary;
import com.geniisys.giuts.dao.GIUTS023BeneficiaryInfoDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIUTS023BeneficiaryInfoDAOImpl implements GIUTS023BeneficiaryInfoDAO{
private SqlMapClient sqlMapClient;
	
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	@Override
	public String validateGroupedItemNo(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("GIUTS023ValidateGroupedItemNo", params);
	}
	
	@Override
	public String validateBeneficiarymNo(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("GIUTS023ValidateBeneficiaryNo", params);
	}
	
	@Override
	public void saveGIUTS023(Map<String, Object> allParams) throws SQLException {
		try {
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GIPIGroupedItems> setRowsGI = (List<GIPIGroupedItems>) allParams.get("setRowsGI");
			List<GIPIGroupedItems> delRowsGI = (List<GIPIGroupedItems>) allParams.get("delRowsGI");
			List<GIPIGrpItemsBeneficiary> setRowsBen = (List<GIPIGrpItemsBeneficiary>) allParams.get("setRowsBen");
			List<GIPIGrpItemsBeneficiary> delRowsBen = (List<GIPIGrpItemsBeneficiary>) allParams.get("delRowsBen");
			
			for(GIPIGrpItemsBeneficiary del : delRowsBen){
				this.getSqlMapClient().delete("GIUTS023DeleteBeneficiary", del);
			}
			this.getSqlMapClient().executeBatch();
			
			for(GIPIGroupedItems del : delRowsGI){
				this.getSqlMapClient().delete("GIUTS023DeleteAllBeneficiary", del);
				this.getSqlMapClient().delete("GIUTS023DeleteGroupedItems", del);
			}
			this.getSqlMapClient().executeBatch();
			
			for(GIPIGroupedItems set : setRowsGI){
				this.getSqlMapClient().insert("GIUTS023AddUpdateGroupedItems", set);
			}
			this.getSqlMapClient().executeBatch();
			
			for(GIPIGrpItemsBeneficiary set : setRowsBen){
				this.getSqlMapClient().insert("GIUTS023AddUpdateBeneficiary", set);
			}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
			
		} catch (Exception e) {
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getGIUTS023GroupedItems(Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("giuts023GetGroupedItems", params);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getGIUTS023BeneficiaryNos(Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("giuts023GetBeneficiaryNos", params);
	}
	@Override
	public String showOtherCert(String lineCd)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("GIUTS023ShowOtherCert", lineCd);
	}
	
}
