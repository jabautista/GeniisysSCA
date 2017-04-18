package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIUploadTempDAO;
import com.geniisys.gipi.entity.GIPIUploadItmperil;
import com.geniisys.gipi.entity.GIPIUploadTemp;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIUploadTempDAOImpl implements GIPIUploadTempDAO{

	private Logger log = Logger.getLogger(GIPIUploadTempDAOImpl.class);
	
	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIUploadTempDAO#getGipiUploadTemp()
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIUploadTemp> getGipiUploadTemp() throws SQLException {
		return this.getSqlMapClient().queryForList("getGIPIUploadTemp");
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIUploadTempDAO#setGipiEnrolleeUpload(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void setGipiEnrolleeUpload(Map<String,Object> enrolleeUploads)
			throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			String uploadNo = "";
			List<GIPIUploadTemp> enrollee = (List<GIPIUploadTemp>) enrolleeUploads.get("enrolleeUploads");
			List<GIPIUploadItmperil> emrolleePerils = (List<GIPIUploadItmperil>) enrolleeUploads.get("enrolleeUploadsPerils");
			String doUpload = (String) enrolleeUploads.get("doUpload");
			SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
			
			this.sqlMapClient.delete("delGIPIErrorLog");
			this.getSqlMapClient().executeBatch();
			
			if (doUpload.equals("PERILS")){
				for (GIPIUploadTemp upload: enrollee) {
					uploadNo = upload.getUploadNo();
					System.out.println("Inserting: "+upload.getControlCd()+"\t"+upload.getControlTypeCd()+"\t"+upload.getGroupedItemTitle()+"\t"+upload.getSex()+"\t"+upload.getCivilStatus()+"\t"+(upload.getDateOfBirth() == null ? "null" :sdf.format(upload.getDateOfBirth()))+"\t"+(upload.getFromDate() == null ? "null" :sdf.format(upload.getFromDate()))+"\t"+(upload.getToDate() == null ? "null" :sdf.format(upload.getToDate()))+"\t"+upload.getAge()+"\t"+upload.getSalary()+"\t"+upload.getSalaryGrade()+"\t"+upload.getAmountCoverage()+"\t"+upload.getRemarks());
					this.getSqlMapClient().insert("setEnrolleeUploadPerils", upload);
					this.getSqlMapClient().executeBatch();
				}
				for (GIPIUploadItmperil uploadPerils: emrolleePerils) {
					if (uploadPerils.getPerilCd() != null){
						System.out.println("Inserting Peril: "+uploadPerils.getControlTypeCd()+"\t"+uploadPerils.getControlCd()+"\t"+uploadPerils.getPerilCd()+"\t"+uploadPerils.getNoOfDays()+"\t"+uploadPerils.getPremRt()+"\t"+uploadPerils.getTsiAmt()+"\t"+uploadPerils.getPremAmt()+"\t"+uploadPerils.getAggregateSw()+"\t"+uploadPerils.getBaseAmount()+"\t"+uploadPerils.getRiCommRate()+"\t"+uploadPerils.getRiCommAmt());
						this.getSqlMapClient().insert("setGIPIUploadItmperil", uploadPerils);
						this.getSqlMapClient().executeBatch();
					}
				}
			}else{
				for (GIPIUploadTemp upload: enrollee) {
					uploadNo = upload.getUploadNo();
					System.out.println("Inserting: "+upload.getControlCd()+"\t"+upload.getControlTypeCd()+"\t"+upload.getGroupedItemTitle()+"\t"+upload.getSex()+"\t"+upload.getCivilStatus()+"\t"+(upload.getDateOfBirth() == null ? "null" :sdf.format(upload.getDateOfBirth()))+"\t"+upload.getAge()+"\t"+upload.getSalary()+"\t"+upload.getSalaryGrade()+"\t"+upload.getAmountCoverage()+"\t"+upload.getRemarks());
					this.getSqlMapClient().insert("setEnrolleeUpload", upload);
					this.getSqlMapClient().executeBatch();
				}
			}
			
			this.sqlMapClient.update("insertValuesGIPIUploadTemp", uploadNo);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		log.info("Saving of Enrollee data is successful!");
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIUploadTempDAO#validateUploadFile(java.lang.String)
	 */
	@Override
	public String validateUploadFile(String fileName) throws SQLException {
		fileName = fileName.substring(0, fileName.indexOf("."));
		log.info("Validating uploaded file for filename: "+fileName);
		return (String) this.getSqlMapClient().queryForObject("validateUploadFileEnrollee", fileName);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIUploadTempDAO#getUploadNo(java.lang.String)
	 */
	@Override
	public String getUploadNo(String fileName) throws SQLException {
		log.info("Getting Upload No. for filename: "+fileName);
		return (String) this.getSqlMapClient().queryForObject("getUploadNo", fileName);
	}

	@Override
	public Integer getUploadCount(Integer uploadNo) throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("getUploadCount", uploadNo);
	}
	
}
