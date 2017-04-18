package com.geniisys.giac.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

/**
 * The Class GIACOthFundOffCollns.
 */
public class GIACOthFundOffCollns extends BaseEntity {
	
	/** The gaccTranId. */
	private Integer gaccTranId;
	
	/** The gibrGfunFundCd. */
	private String gibrGfunFundCd;
	
	/** The gibrGfunFundDesc. */
	private String gibrGfunFundDesc;
	
	/** The gibrBranchCd. */
	private String gibrBranchCd;
	
	/** The gibrBranchName. */
	private String gibrBranchName;
	
	/** The itemNo. */
	private Integer itemNo;
	
	/** The transactionType. */
	private Integer transactionType;
	
	/** The transactionTypeDesc. */
	private String transactionTypeDesc;
	
	/** The collection amount. */
	private BigDecimal collectionAmt;
	
	/** The gofcGaccTranId. */
	private Integer gofcGaccTranId;
	
	/** The gofcGibrGfunFundCd. */
	private String gofcGibrGfunFundCd;
	
	/** The gofcGibrGfunFundDesc. */
	private String gofcGibrGfunFundDesc;
	
	/** The gofcGibrBranchCd. */
	private String gofcGibrBranchCd;
	
	/** The gofcGibrBranchName. */
	private String gofcGibrBranchName;
	
	/** The gofcItemNo. */
	private Integer gofcItemNo;
	
	/** The orPrintTag. */
	private String orPrintTag;
	
	/** The particulars. */
	private String particulars;
	
	/** The userId. */
	private String userId;
	
	/** The lastUpdate. */
	private Date lastUpdate;
	
	/** The old transaction No. */
	private String oldTransNo;
	
	public GIACOthFundOffCollns(){
	
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
	 * @return the gibrGfunFundCd
	 */
	public String getGibrGfunFundCd() {
		return gibrGfunFundCd;
	}
	
	/**
	 * @param gibrGfunFundCd the gibrGfunFundCd to set
	 */
	public void setGibrGfunFundCd(String gibrGfunFundCd) {
		this.gibrGfunFundCd = gibrGfunFundCd;
	}
	
	/**
	 * @return the gibrGfunFundDesc
	 */
	public String getGibrGfunFundDesc() {
		return gibrGfunFundDesc;
	}
	
	/**
	 * @param gibrGfunFundDesc the gibrGfunFundDesc to set
	 */
	public void setGibrGfunFundDesc(String gibrGfunFundDesc) {
		this.gibrGfunFundDesc = gibrGfunFundDesc;
	}

	/**
	 * @return the gibrBranchCd
	 */
	public String getGibrBranchCd() {
		return gibrBranchCd;
	}
	
	/**
	 * @param gibrBranchCd the gibrBranchCd to set
	 */
	public void setGibrBranchCd(String gibrBranchCd) {
		this.gibrBranchCd = gibrBranchCd;
	}
	
	/**
	 * @return the gibrBranchName
	 */
	public String getGibrBranchName() {
		return gibrBranchName;
	}
	
	/**
	 * @param gibrBranchName the gibrBranchName to set
	 */
	public void setGibrBranchName(String gibrBranchName) {
		this.gibrBranchName = gibrBranchName;
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
	 * @return the transactionType
	 */
	public Integer getTransactionType() {
		return transactionType;
	}
	
	/**
	 * @param transactionType the transactionType to set
	 */
	public void setTransactionType(Integer transactionType) {
		this.transactionType = transactionType;
	}
	
	/**
	 * @return the transactionTypeDesc
	 */
	public String getTransactionTypeDesc() {
		return transactionTypeDesc;
	}
	
	/**
	 * @param transactionTypeDesc the transactionTypeDesc to set
	 */
	public void setTransactionTypeDesc(String transactionTypeDesc) {
		this.transactionTypeDesc = transactionTypeDesc;
	}

	/**
	 * @return the collectionAmt
	 */
	public BigDecimal getCollectionAmt() {
		return collectionAmt;
	}
	
	/**
	 * @param collectionAmt the collectionAmt to set
	 */
	public void setCollectionAmt(BigDecimal collectionAmt) {
		this.collectionAmt = collectionAmt;
	}
	
	/**
	 * @return the gofcGaccTranId
	 */
	public Integer getGofcGaccTranId() {
		return gofcGaccTranId;
	}
	
	/**
	 * @param gofcGaccTranId the gofcGaccTranId to set
	 */
	public void setGofcGaccTranId(Integer gofcGaccTranId) {
		this.gofcGaccTranId = gofcGaccTranId;
	}
	
	/**
	 * @return the gofcGibrGfunFundCd
	 */
	public String getGofcGibrGfunFundCd() {
		return gofcGibrGfunFundCd;
	}
	
	/**
	 * @param gofcGibrGfunFundCd the gofcGibrGfunFundCd to set
	 */
	public void setGofcGibrGfunFundCd(String gofcGibrGfunFundCd) {
		this.gofcGibrGfunFundCd = gofcGibrGfunFundCd;
	}
	
	/**
	 * @return the gofcGibrGfunFundDesc
	 */
	public String getGofcGibrGfunFundDesc() {
		return gofcGibrGfunFundDesc;
	}
	
	/**
	 * @param gofcGibrGfunFundDesc the gofcGibrGfunFundDesc to set
	 */
	public void setGofcGibrGfunFundDesc(String gofcGibrGfunFundDesc) {
		this.gofcGibrGfunFundDesc = gofcGibrGfunFundDesc;
	}

	/**
	 * @return the gofcGibrBranchCd
	 */
	public String getGofcGibrBranchCd() {
		return gofcGibrBranchCd;
	}
	
	/**
	 * @param gofcGibrBranchCd the gofcGibrBranchCd to set
	 */
	public void setGofcGibrBranchCd(String gofcGibrBranchCd) {
		this.gofcGibrBranchCd = gofcGibrBranchCd;
	}
	
	/**
	 * @return the gofcGibrBranchName
	 */
	public String getGofcGibrBranchName() {
		return gofcGibrBranchName;
	}
	
	/**
	 * @param gofcGibrBranchName the gofcGibrBranchName to set
	 */
	public void setGofcGibrBranchName(String gofcGibrBranchName) {
		this.gofcGibrBranchName = gofcGibrBranchName;
	}

	/**
	 * @return the gofcItemNo
	 */
	public Integer getGofcItemNo() {
		return gofcItemNo;
	}
	
	/**
	 * @param gofcItemNo the gofcItemNo to set
	 */
	public void setGofcItemNo(Integer gofcItemNo) {
		this.gofcItemNo = gofcItemNo;
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
	 * @return the userId
	 */
	public String getUserId() {
		return userId;
	}
	
	/**
	 * @param userId the userId to set
	 */
	public void setUserId(String userId) {
		this.userId = userId;
	}
	
	/**
	 * @return the lastUpdate
	 */
	public Date getLastUpdate() {
		return lastUpdate;
	}
	
	/**
	 * @param lastUpdate the lastUpdate to set
	 */
	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
	}

	public void setOldTransNo(String oldTransNo) {
		this.oldTransNo = oldTransNo;
	}

	public String getOldTransNo() {
		return oldTransNo;
	}
}
