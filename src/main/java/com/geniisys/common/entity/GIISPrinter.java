package com.geniisys.common.entity;

import com.geniisys.framework.util.BaseEntity;

public class GIISPrinter extends BaseEntity {

	private Integer printerNo;
	private String printerName;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private String issCd;
	private String remarks;

	public GIISPrinter(){
		
	}

	public GIISPrinter(Integer printerNo, String printerName, Integer cpiRecNo,
			String cpiBranchCd, String issCd, String remarks) {
		super();
		this.printerNo = printerNo;
		this.printerName = printerName;
		this.cpiRecNo = cpiRecNo;
		this.cpiBranchCd = cpiBranchCd;
		this.issCd = issCd;
		this.remarks = remarks;
	}

	public Integer getPrinterNo() {
		return printerNo;
	}

	public void setPrinterNo(Integer printerNo) {
		this.printerNo = printerNo;
	}

	public String getPrinterName() {
		return printerName;
	}

	public void setPrinterName(String printerName) {
		this.printerName = printerName;
	}

	public Integer getCpiRecNo() {
		return cpiRecNo;
	}

	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}

	public String getCpiBranchCd() {
		return cpiBranchCd;
	}

	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}

	public String getIssCd() {
		return issCd;
	}

	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

}
