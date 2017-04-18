package com.geniisys.common.entity;

import com.geniisys.framework.util.BaseEntity;

public class GIISFbndrSeq extends BaseEntity{
	
	private String  lineCd;
	private Integer fbndrYy; 
	private Integer fbndrSeqNo;
	private String  remarks;
	
	public GIISFbndrSeq(){
		
	}

	/**
	 * @return the lineCd
	 */
	public String getLineCd() {
		return lineCd;
	}

	/**
	 * @param lineCd the lineCd to set
	 */
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	/**
	 * @return the fbndrYy
	 */
	public Integer getFbndrYy() {
		return fbndrYy;
	}

	/**
	 * @param fbndrYy the fbndrYy to set
	 */
	public void setFbndrYy(Integer fbndrYy) {
		this.fbndrYy = fbndrYy;
	}

	/**
	 * @return the fbndrSeqNo
	 */
	public Integer getFbndrSeqNo() {
		return fbndrSeqNo;
	}

	/**
	 * @param fbndrSeqNo the fbndrSeqNo to set
	 */
	public void setFbndrSeqNo(Integer fbndrSeqNo) {
		this.fbndrSeqNo = fbndrSeqNo;
	}

	/**
	 * @return the remarks
	 */
	public String getRemarks() {
		return remarks;
	}

	/**
	 * @param remarks the remarks to set
	 */
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	
	

}
