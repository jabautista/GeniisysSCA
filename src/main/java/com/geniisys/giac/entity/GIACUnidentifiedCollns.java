/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.giac.entity;

import java.math.BigDecimal;
import java.util.List;

import com.geniisys.framework.util.BaseEntity;
/**
 * The Class GIACUnidentifiedCollns
 */
public class GIACUnidentifiedCollns extends BaseEntity{
	
	/** The GACC Tran ID. */
	private Integer gaccTranId;
	
	/** The Item No. */
	private Integer itemNo;
	
	/** The Tran Type. */
	private Integer tranType;
	
	/** The Collection Amt */
	private BigDecimal collAmt;
	
	/** The GL Acct ID. */
	private Integer glAcctId;
	
	/** The GL Acct Category. */
	private Integer glAcctCategory;
	
	/** The GL Control Acct. */
	private Integer glCtrlAcct;
	
	/** The GL Sub Acct 1. */
	private Integer glSubAcct1;
	
	/** The GL Sub Acct 2. */
	private Integer glSubAcct2;
	
	/** The GL Sub Acct 3. */
	private Integer glSubAcct3;
	
	/** The GL Sub Acct 4. */
	private Integer glSubAcct4;
	
	/** The GL Sub Acct 5. */
	private Integer glSubAcct5;
	
	/** The GL Sub Acct 6. */
	private Integer glSubAcct6;
	
	/** The GL Sub Acct 7. */
	private Integer glSubAcct7;
	
	/** The OR Print Tag. */
	private String orPrintTag;
	
	/** The SL CD. */
	private Integer slCd;
	
	/** The SL Name. */
	private String slName;
	
	/** The Gunc Tran Id. */
	private Integer guncTranId;
	
	/** The Gunc Item No. */
	private Integer guncItemNo;
	
	/** The particulars. */
	private String particulars;
	
	private String glAcctName;
	
	private String tranTypeDesc;

	/** The Old transaction nos */
	private List<GIACUnidentifiedCollns> oldTranNos;
	
	private String oldTranNos2;
	
	private String fundCode;
	

	public GIACUnidentifiedCollns(){
		
	}

	/**
	 * @return the gaccTranId
	 */
	public Integer getGaccTranId() {
		return gaccTranId;
	}

	/**
	 * @param gaccTranId the gaccTranId to set
	 */
	public void setGaccTranId(Integer gaccTranId) {
		this.gaccTranId = gaccTranId;
	}

	/**
	 * @return the itemNo
	 */
	public Integer getItemNo() {
		return itemNo;
	}

	/**
	 * @param itemNo the itemNo to set
	 */
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}

	/**
	 * @return the tranType
	 */
	public Integer getTranType() {
		return tranType;
	}

	/**
	 * @param tranType the tranType to set
	 */
	public void setTranType(Integer tranType) {
		this.tranType = tranType;
	}

	/**
	 * @return the collAmt
	 */
	public BigDecimal getCollAmt() {
		return collAmt;
	}

	/**
	 * @param collAmt the collAmt to set
	 */
	public void setCollAmt(BigDecimal collAmt) {
		this.collAmt = collAmt;
	}

	/**
	 * @return the glAcctId
	 */
	public Integer getGlAcctId() {
		return glAcctId;
	}

	/**
	 * @param glAcctId the glAcctId to set
	 */
	public void setGlAcctId(Integer glAcctId) {
		this.glAcctId = glAcctId;
	}

	/**
	 * @return the glAcctCategory
	 */
	public Integer getGlAcctCategory() {
		return glAcctCategory;
	}

	/**
	 * @param glAcctCategory the glAcctCategory to set
	 */
	public void setGlAcctCategory(Integer glAcctCategory) {
		this.glAcctCategory = glAcctCategory;
	}

	/**
	 * @return the glCtrlAcct
	 */
	public Integer getGlCtrlAcct() {
		return glCtrlAcct;
	}

	/**
	 * @param glCtrlAcct the glCtrlAcct to set
	 */
	public void setGlCtrlAcct(Integer glCtrlAcct) {
		this.glCtrlAcct = glCtrlAcct;
	}

	/**
	 * @return the glSubAcct1
	 */
	public Integer getGlSubAcct1() {
		return glSubAcct1;
	}

	/**
	 * @param glSubAcct1 the glSubAcct1 to set
	 */
	public void setGlSubAcct1(Integer glSubAcct1) {
		this.glSubAcct1 = glSubAcct1;
	}

	/**
	 * @return the glSubAcct2
	 */
	public Integer getGlSubAcct2() {
		return glSubAcct2;
	}

	/**
	 * @param glSubAcct2 the glSubAcct2 to set
	 */
	public void setGlSubAcct2(Integer glSubAcct2) {
		this.glSubAcct2 = glSubAcct2;
	}

	/**
	 * @return the glSubAcct3
	 */
	public Integer getGlSubAcct3() {
		return glSubAcct3;
	}

	/**
	 * @param glSubAcct3 the glSubAcct3 to set
	 */
	public void setGlSubAcct3(Integer glSubAcct3) {
		this.glSubAcct3 = glSubAcct3;
	}

	/**
	 * @return the glSubAcct4
	 */
	public Integer getGlSubAcct4() {
		return glSubAcct4;
	}

	/**
	 * @param glSubAcct4 the glSubAcct4 to set
	 */
	public void setGlSubAcct4(Integer glSubAcct4) {
		this.glSubAcct4 = glSubAcct4;
	}

	/**
	 * @return the glSubAcct5
	 */
	public Integer getGlSubAcct5() {
		return glSubAcct5;
	}

	/**
	 * @param glSubAcct5 the glSubAcct5 to set
	 */
	public void setGlSubAcct5(Integer glSubAcct5) {
		this.glSubAcct5 = glSubAcct5;
	}

	/**
	 * @return the glSubAcct6
	 */
	public Integer getGlSubAcct6() {
		return glSubAcct6;
	}

	/**
	 * @param glSubAcct6 the glSubAcct6 to set
	 */
	public void setGlSubAcct6(Integer glSubAcct6) {
		this.glSubAcct6 = glSubAcct6;
	}

	/**
	 * @return the glSubAcct7
	 */
	public Integer getGlSubAcct7() {
		return glSubAcct7;
	}

	/**
	 * @param glSubAcct7 the glSubAcct7 to set
	 */
	public void setGlSubAcct7(Integer glSubAcct7) {
		this.glSubAcct7 = glSubAcct7;
	}

	/**
	 * @return the orPrintTag
	 */
	public String getOrPrintTag() {
		return orPrintTag;
	}

	/**
	 * @param orPrintTag the orPrintTag to set
	 */
	public void setOrPrintTag(String orPrintTag) {
		this.orPrintTag = orPrintTag;
	}

	/**
	 * @return the slCd
	 */
	public Integer getSlCd() {
		return slCd;
	}

	/**
	 * @param slCd the slCd to set
	 */
	public void setSlCd(Integer slCd) {
		this.slCd = slCd;
	}

	/**
	 * @return the guncTranId
	 */
	public Integer getGuncTranId() {
		return guncTranId;
	}

	/**
	 * @param guncTranId the guncTranId to set
	 */
	public void setGuncTranId(Integer guncTranId) {
		this.guncTranId = guncTranId;
	}

	/**
	 * @return the guncItemNo
	 */
	public Integer getGuncItemNo() {
		return guncItemNo;
	}

	/**
	 * @param guncItemNo the guncItemNo to set
	 */
	public void setGuncItemNo(Integer guncItemNo) {
		this.guncItemNo = guncItemNo;
	}

	/**
	 * @return the particulars
	 */
	public String getParticulars() {
		return particulars;
	}

	/**
	 * @param particulars the particulars to set
	 */
	public void setParticulars(String particulars) {
		this.particulars = particulars;
	}

	/**
	 * @return the oldTranNos
	 */
	public List<GIACUnidentifiedCollns> getOldTranNos() {
		return oldTranNos;
	}

	/**
	 * @param oldTranNos the oldTranNos to set
	 */
	public void setOldTranNos(List<GIACUnidentifiedCollns> oldTranNos) {
		this.oldTranNos = oldTranNos;
	}

	/**
	 * @return the glAcctName
	 */
	public String getGlAcctName() {
		return glAcctName;
	}

	/**
	 * @param glAcctName the glAcctName to set
	 */
	public void setGlAcctName(String glAcctName) {
		this.glAcctName = glAcctName;
	}

	/**
	 * @return the slName
	 */
	public String getSlName() {
		return slName;
	}

	/**
	 * @param slName the slName to set
	 */
	public void setSlName(String slName) {
		this.slName = slName;
	}

	public String getTranTypeDesc() {
		return tranTypeDesc;
	}

	public void setTranTypeDesc(String tranTypeDesc) {
		this.tranTypeDesc = tranTypeDesc;
	}

	
	
	public String getOldTranNos2() {
		return oldTranNos2;
	}

	public void setOldTranNos2(String oldTranNos2) {
		this.oldTranNos2 = oldTranNos2;
	}
	
	public String getFundCode() {
		return fundCode;
	}

	public void setFundCode(String fundCode) {
		this.fundCode = fundCode;
	}

/*	public void setDelRows(Integer gaccTranId, Integer itemNo) {
		this.gaccTranId = gaccTranId;
		this.itemNo = itemNo;
	}*/		
}
