package com.geniisys.giis.entity;

import java.math.BigDecimal;

public class GIISPeril extends BaseEntity{

		private String lineCd;   
		private Integer perilCd; 
		private Integer sequence; 
		private String perilSname;
		private String perilName;
		private String perilType;
		private String sublineCd;
		private BigDecimal riCommRt;
		private String prtFlag; 
		private String expiryPrintTag;    
		private Integer bascPerlCd;
		private String profCommTag; 
		private String perilLname; 
		private String remarks;  
		private String zoneType;
		private String evalSw;
		private String defaultTag;
		private BigDecimal defaultRate;
		private BigDecimal defaultTsi;
		
		private String strRiCommRt;
		private String eqZoneType; //edgar 03/10/2015
		
		public GIISPeril() {
			super();
		}

		public GIISPeril(String lineCd, Integer perilCd, Integer sequence,
				String perilSname, String perilName, String perilType,
				String sublineCd, BigDecimal riCommRt, String prtFlag,
				String expiryPrintTag, Integer bascPerlCd, String profCommTag,
				String perilLname, String remarks, String zoneType, String evalSw,
				String defaultTag, BigDecimal defaultRate, BigDecimal defaultTsi) {
			super();
			this.lineCd = lineCd;
			this.perilCd = perilCd;
			this.sequence = sequence;
			this.perilSname = perilSname;
			this.perilName = perilName;
			this.perilType = perilType;
			this.sublineCd = sublineCd;
			this.riCommRt = riCommRt;
			this.prtFlag = prtFlag;
			this.expiryPrintTag = expiryPrintTag;
			this.bascPerlCd = bascPerlCd;
			this.profCommTag = profCommTag;
			this.perilLname = perilLname;
			this.remarks = remarks;
			this.zoneType = zoneType;
			this.evalSw = evalSw;
			this.defaultTag = defaultTag;
			this.defaultRate = defaultRate;
			this.defaultTsi = defaultTsi;
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

		public Integer getSequence() {
			return sequence;
		}

		public void setSequence(Integer sequence) {
			this.sequence = sequence;
		}

		public String getPerilSname() {
			return perilSname;
		}

		public void setPerilSname(String perilSname) {
			this.perilSname = perilSname;
		}

		public String getPerilName() {
			return perilName;
		}

		public void setPerilName(String perilName) {
			this.perilName = perilName;
		}

		public String getPerilType() {
			return perilType;
		}

		public void setPerilType(String perilType) {
			this.perilType = perilType;
		}

		public String getSublineCd() {
			return sublineCd;
		}

		public void setSublineCd(String sublineCd) {
			this.sublineCd = sublineCd;
		}

		public BigDecimal getRiCommRt() {
			return riCommRt;
		}

		public void setRiCommRt(BigDecimal riCommRt) {
			this.riCommRt = riCommRt;
		}

		public String getPrtFlag() {
			return prtFlag;
		}

		public void setPrtFlag(String prtFlag) {
			this.prtFlag = prtFlag;
		}

		public String getExpiryPrintTag() {
			return expiryPrintTag;
		}

		public void setExpiryPrintTag(String expiryPrintTag) {
			this.expiryPrintTag = expiryPrintTag;
		}

		public Integer getBascPerlCd() {
			return bascPerlCd;
		}

		public void setBascPerlCd(Integer bascPerlCd) {
			this.bascPerlCd = bascPerlCd;
		}

		public String getProfCommTag() {
			return profCommTag;
		}

		public void setProfCommTag(String profCommTag) {
			this.profCommTag = profCommTag;
		}

		public String getPerilLname() {
			return perilLname;
		}

		public void setPerilLname(String perilLname) {
			this.perilLname = perilLname;
		}

		public String getRemarks() {
			return remarks;
		}

		public void setRemarks(String remarks) {
			this.remarks = remarks;
		}
		
		public String getZoneType() {
			return zoneType;
		}

		public void setZoneType(String zoneType) {
			this.zoneType = zoneType;
		}
		
		public String getEvalSw() {
			return evalSw;
		}

		public void setEvalSw(String evalSw) {
			this.evalSw = evalSw;
		}

		public String getDefaultTag() {
			return defaultTag;
		}

		public void setDefaultTag(String defaultTag) {
			this.defaultTag = defaultTag;
		}

		public BigDecimal getDefaultRate() {
			return defaultRate;
		}

		public void setDefaultRate(BigDecimal defaultRate) {
			this.defaultRate = defaultRate;
		}

		public BigDecimal getDefaultTsi() {
			return defaultTsi;
		}

		public void setDefaultTsi(BigDecimal defaultTsi) {
			this.defaultTsi = defaultTsi;
		}

		public String getStrRiCommRt() {
			return strRiCommRt;
		}

		public void setStrRiCommRt(String strRiCommRt) {
			this.strRiCommRt = strRiCommRt;
		}

		public String getEqZoneType() {
			return eqZoneType;
		}

		public void setEqZoneType(String eqZoneType) {
			this.eqZoneType = eqZoneType;
		}

	}

