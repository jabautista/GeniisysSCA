/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.entity
	File Name: GICLReqdDocs.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Aug 5, 2011
	Description: 
*/


package com.geniisys.gicl.entity;

import com.geniisys.framework.util.BaseEntity;

public class GICLReqdDocs extends BaseEntity{
	private Integer claimId;
	private String lineCd;
	private String sublineCd;
	private String issCd;
	private Integer clmDocCd;
	private String clmDocDesc;
	private String docSbmttdDt;
	private String docCmpltdDt;
	private String rcvdBy;
	private String frwdBy;
	private String frwdFr;
	private String printSw;
	private String remarks;
	private Integer cpiRecNo;
	private String docPath;
	private String cpiBranchCd;
	private String sourceTag;
	private String lastupdate;
	
	public Integer getClaimId() {
		return claimId;
	}
	public void setClaimId(Integer claimId) {
		this.claimId = claimId;
	}
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public String getSublineCd() {
		return sublineCd;
	}
	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}
	public String getIssCd() {
		return issCd;
	}
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}
	public Integer getClmDocCd() {
		return clmDocCd;
	}
	public void setClmDocCd(Integer clmDocCd) {
		this.clmDocCd = clmDocCd;
	}
	public String getDocSbmttdDt() {
		return docSbmttdDt;
	}
	public void setDocSbmttdDt(String docSbmttdDt) {
		this.docSbmttdDt = docSbmttdDt;
	}
	public String getDocCmpltdDt() {
		return docCmpltdDt;
	}
	public void setDocCmpltdDt(String docCmpltdDt) {
		this.docCmpltdDt = docCmpltdDt;
	}
	public String getRcvdBy() {
		return rcvdBy;
	}
	public void setRcvdBy(String rcvdBy) {
		this.rcvdBy = rcvdBy;
	}

	public String getPrintSw() {
		return printSw;
	}
	public void setPrintSw(String printSw) {
		this.printSw = printSw;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public Integer getCpiRecNo() {
		return cpiRecNo;
	}
	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}
	public String getDocPath() {
		return docPath;
	}
	public void setDocPath(String docPath) {
		this.docPath = docPath;
	}
	public String getCpiBranchCd() {
		return cpiBranchCd;
	}
	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}
	public String getSourceTag() {
		return sourceTag;
	}
	public void setSourceTag(String sourceTag) {
		this.sourceTag = sourceTag;
	}
	/**
	 * @param clmDocDesc the clmDocDesc to set
	 */
	public void setClmDocDesc(String clmDocDesc) {
		this.clmDocDesc = clmDocDesc;
	}
	/**
	 * @return the clmDocDesc
	 */
	public String getClmDocDesc() {
		return clmDocDesc;
	}
	/**
	 * @param frwdBy the frwdBy to set
	 */
	public void setFrwdBy(String frwdBy) {
		this.frwdBy = frwdBy;
	}
	/**
	 * @return the frwdBy
	 */
	public String getFrwdBy() {
		return frwdBy;
	}
	/**
	 * @param frwdFr the frwdFr to set
	 */
	public void setFrwdFr(String frwdFr) {
		this.frwdFr = frwdFr;
	}
	/**
	 * @return the frwdFr
	 */
	public String getFrwdFr() {
		return frwdFr;
	}
	/**
	 * @param lastupdate the lastupdate to set
	 */
	public void setLastupdate(String lastupdate) {
		this.lastupdate = lastupdate;
	}
	/**
	 * @return the lastupdate
	 */
	public String getLastupdate() {
		return lastupdate;
	}
	
	
}
