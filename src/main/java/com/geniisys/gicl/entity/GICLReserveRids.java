/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	GICLS024
 * Created By	:	rencela
 * Create Date	:	Apr 13, 2012
 ***************************************************/
package com.geniisys.gicl.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;

public class GICLReserveRids extends BaseEntity {
	private Integer acctTrtyType;
	private Integer claimId;
	private Integer clmDistNo;
	private Integer clmResHistId;
	private Integer distYear;
	private Integer groupedItemNo; 
	private Integer grpSeqNo;
	private Integer histSeqNo;
	private Integer itemNo;
	private String lineCd;
	private Integer perilCd;
	private Integer plaId;
	private Integer printRiCd;
	private Integer resPlaId;
	private Integer riCd;
	private String shareType;
	private BigDecimal shrExpRiResAmt;
	private BigDecimal shrLossRiResAmt;
	private BigDecimal shrRiPct;
	private BigDecimal shrRiPctReal;
	
	// non-column member properties
	private String riName;
	
	public GICLReserveRids(){
		// empty constructor
	}

	public Integer getAcctTrtyType() {
		return acctTrtyType;
	}

	public void setAcctTrtyType(Integer acctTrtyType) {
		this.acctTrtyType = acctTrtyType;
	}

	public Integer getClaimId() {
		return claimId;
	}

	public void setClaimId(Integer claimId) {
		this.claimId = claimId;
	}

	public Integer getClmDistNo() {
		return clmDistNo;
	}

	public void setClmDistNo(Integer clmDistNo) {
		this.clmDistNo = clmDistNo;
	}

	public Integer getClmResHistId() {
		return clmResHistId;
	}

	public void setClmResHistId(Integer clmResHistId) {
		this.clmResHistId = clmResHistId;
	}

	public Integer getDistYear() {
		return distYear;
	}

	public void setDistYear(Integer distYear) {
		this.distYear = distYear;
	}

	public Integer getGroupedItemNo() {
		return groupedItemNo;
	}

	public void setGroupedItemNo(Integer groupedItemNo) {
		this.groupedItemNo = groupedItemNo;
	}

	public Integer getGrpSeqNo() {
		return grpSeqNo;
	}

	public void setGrpSeqNo(Integer grpSeqNo) {
		this.grpSeqNo = grpSeqNo;
	}

	public Integer getHistSeqNo() {
		return histSeqNo;
	}

	public void setHistSeqNo(Integer histSeqNo) {
		this.histSeqNo = histSeqNo;
	}

	public Integer getItemNo() {
		return itemNo;
	}

	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}

	public String getLineCd() {
		return lineCd;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	public Integer getPerilCd() {
		return perilCd;
	}

	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}

	public Integer getPrintRiCd() {
		return printRiCd;
	}

	public void setPrintRiCd(Integer printRiCd) {
		this.printRiCd = printRiCd;
	}

	public Integer getResPlaId() {
		return resPlaId;
	}

	public void setResPlaId(Integer resPlaId) {
		this.resPlaId = resPlaId;
	}

	public Integer getRiCd() {
		return riCd;
	}

	public void setRiCd(Integer riCd) {
		this.riCd = riCd;
	}

	public BigDecimal getShrLossRiResAmt() {
		return shrLossRiResAmt;
	}

	public void setShrLossRiResAmt(BigDecimal shrLossRiResAmt) {
		this.shrLossRiResAmt = shrLossRiResAmt;
	}

	public BigDecimal getShrRiPct() {
		return shrRiPct;
	}

	public void setShrRiPct(BigDecimal shrRiPct) {
		this.shrRiPct = shrRiPct;
	}

	public BigDecimal getShrRiPctReal() {
		return shrRiPctReal;
	}

	public void setShrRiPctReal(BigDecimal shrRiPctReal) {
		this.shrRiPctReal = shrRiPctReal;
	}

	public void setRiName(String riName) {
		this.riName = riName;
	}

	public String getRiName() {
		return riName;
	}

	public void setShrExpRiResAmt(BigDecimal shrExpRiResAmt) {
		this.shrExpRiResAmt = shrExpRiResAmt;
	}

	public BigDecimal getShrExpRiResAmt() {
		return shrExpRiResAmt;
	}

	public void setShareType(String shareType) {
		this.shareType = shareType;
	}

	public String getShareType() {
		return shareType;
	}

	public void setPlaId(Integer plaId) {
		this.plaId = plaId;
	}

	public Integer getPlaId() {
		return plaId;
	}
}