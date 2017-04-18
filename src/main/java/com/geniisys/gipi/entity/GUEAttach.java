package com.geniisys.gipi.entity;

import com.geniisys.common.entity.BaseFile;

public class GUEAttach extends BaseFile {

	private Integer tranId;
	private Integer itemNo;
	private String remarks;
	
	public GUEAttach(){
		super();
	}

	public GUEAttach(Integer tranId, Integer itemNo, String remarks) {
		super();
		this.tranId = tranId;
		this.itemNo = itemNo;
		this.remarks = remarks;
	}

	public Integer getTranId() {
		return tranId;
	}

	public void setTranId(Integer tranId) {
		this.tranId = tranId;
	}

	public Integer getItemNo() {
		return itemNo;
	}

	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}	
	
/*	public String getFileName(){		
		String filePath = this.getFilePath();
		return filePath.substring(filePath.lastIndexOf("/")+1, filePath.length());
	}*/
	
}
