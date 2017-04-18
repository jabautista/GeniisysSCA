package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIISReports extends BaseEntity {

	private String reportId;
	private String reportTitle;
	private String lineCd;
	private String prevLineCd; //added John Daniel 04.07.2016 for updating line cd
	private String sublineCd;
	private String reportType;
	private String reportDesc;
	private String destype;
	private String desname;
	private String desformat;
	private String paramform;
	private Integer copies;
	private String reportMode;
	private String orientation;
	private String background;
	private String generationFrequency;
	private String eisTag;
	private String remarks;
	private String moduleTag;
	private String documentTag;
	private String version;
	private String docType;
	private String birTag;
	private String birFormType;
	private String birFreqTag;
	private String pagesize;
	private String addSource;
	private String birWithReport;
	private String disableFileSw;
	private String csvFileSw;
	
	public String getReportId() {
		return reportId;
	}
	public void setReportId(String reportId) {
		this.reportId = reportId;
	}
	public String getReportTitle() {
		return reportTitle;
	}
	public void setReportTitle(String reportTitle) {
		this.reportTitle = reportTitle;
	}
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public String getPrevLineCd() {
		return prevLineCd;
	}
	public void setPrevLineCd(String prevLineCd) {
		this.prevLineCd = prevLineCd;
	}
	public String getVersion() {
		return version;
	}
	public void setVersion(String version) {
		this.version = version;
	}
	public String getDocType() {
		return docType;
	}
	public void setDocType(String docType) {
		this.docType = docType;
	}
	public String getSublineCd() {
		return sublineCd;
	}
	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}
	public String getReportType() {
		return reportType;
	}
	public void setReportType(String reportType) {
		this.reportType = reportType;
	}
	public String getReportDesc() {
		return reportDesc;
	}
	public void setReportDesc(String reportDesc) {
		this.reportDesc = reportDesc;
	}
	public String getDestype() {
		return destype;
	}
	public void setDestype(String destype) {
		this.destype = destype;
	}
	public String getDesname() {
		return desname;
	}
	public void setDesname(String desname) {
		this.desname = desname;
	}
	public String getDesformat() {
		return desformat;
	}
	public void setDesformat(String desformat) {
		this.desformat = desformat;
	}
	public String getParamform() {
		return paramform;
	}
	public void setParamform(String paramform) {
		this.paramform = paramform;
	}
	public Integer getCopies() {
		return copies;
	}
	public void setCopies(Integer copies) {
		this.copies = copies;
	}
	public String getReportMode() {
		return reportMode;
	}
	public void setReportMode(String reportMode) {
		this.reportMode = reportMode;
	}
	public String getOrientation() {
		return orientation;
	}
	public void setOrientation(String orientation) {
		this.orientation = orientation;
	}
	public String getBackground() {
		return background;
	}
	public void setBackground(String background) {
		this.background = background;
	}
	public String getGenerationFrequency() {
		return generationFrequency;
	}
	public void setGenerationFrequency(String generationFrequency) {
		this.generationFrequency = generationFrequency;
	}
	public String getEisTag() {
		return eisTag;
	}
	public void setEisTag(String eisTag) {
		this.eisTag = eisTag;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public String getModuleTag() {
		return moduleTag;
	}
	public void setModuleTag(String moduleTag) {
		this.moduleTag = moduleTag;
	}
	public String getDocumentTag() {
		return documentTag;
	}
	public void setDocumentTag(String documentTag) {
		this.documentTag = documentTag;
	}
	public String getBirTag() {
		return birTag;
	}
	public void setBirTag(String birTag) {
		this.birTag = birTag;
	}
	public String getBirFormType() {
		return birFormType;
	}
	public void setBirFormType(String birFormType) {
		this.birFormType = birFormType;
	}
	public String getBirFreqTag() {
		return birFreqTag;
	}
	public void setBirFreqTag(String birFreqTag) {
		this.birFreqTag = birFreqTag;
	}
	public String getPagesize() {
		return pagesize;
	}
	public void setPagesize(String pagesize) {
		this.pagesize = pagesize;
	}
	public String getAddSource() {
		return addSource;
	}
	public void setAddSource(String addSource) {
		this.addSource = addSource;
	}
	public String getBirWithReport() {
		return birWithReport;
	}
	public void setBirWithReport(String birWithReport) {
		this.birWithReport = birWithReport;
	}
	public String getDisableFileSw() {
		return disableFileSw;
	}
	public void setDisableFileSw(String disableFileSw) {
		this.disableFileSw = disableFileSw;
	}
	public String getCsvFileSw() {
		return csvFileSw;
	}
	public void setCsvFileSw(String csvFileSw) {
		this.csvFileSw = csvFileSw;
	}
}
