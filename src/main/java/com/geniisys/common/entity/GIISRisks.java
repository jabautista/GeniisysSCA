/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.entity;

import com.geniisys.framework.util.BaseEntity;


/**
 * The Class GIISRisks.
 */
public class GIISRisks extends BaseEntity {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 4561029787967632903L;

	/** The block id. */
	private int blockId;
	
	/** The risk cd. */
	private String riskCd;
	
	/** The risk desc. */
	private String riskDesc;

	/**
	 * Gets the block id.
	 * 
	 * @return the block id
	 */
	public int getBlockId() {
		return blockId;
	}

	/**
	 * Sets the block id.
	 * 
	 * @param blockId the new block id
	 */
	public void setBlockId(int blockId) {
		this.blockId = blockId;
	}

	/**
	 * Gets the risk cd.
	 * 
	 * @return the risk cd
	 */
	public String getRiskCd() {
		return riskCd;
	}

	/**
	 * Sets the risk cd.
	 * 
	 * @param riskCd the new risk cd
	 */
	public void setRiskCd(String riskCd) {
		this.riskCd = riskCd;
	}

	/**
	 * Gets the risk desc.
	 * 
	 * @return the risk desc
	 */
	public String getRiskDesc() {
		return riskDesc;
	}

	/**
	 * Sets the risk desc.
	 * 
	 * @param riskDesc the new risk desc
	 */
	public void setRiskDesc(String riskDesc) {
		this.riskDesc = riskDesc;
	}

}
