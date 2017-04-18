function setRiFromDistFrpsLOV(row, moduleId) {
	try {
		 objRiFrps.lineCd = row.lineCd;
		 objRiFrps.frpsYy = row.frpsYy;
		 objRiFrps.frpsSeqNo = row.frpsSeqNo;
		 objRiFrps.riSeqNo = row.riSeqNo;
		 
		 objRiFrps.frpsNo = row.frpsNo;
		 objRiFrps.premAmt = row.premAmt;
		 objRiFrps.tsiAmt = row.tsiAmt;
		 objRiFrps.endtNo = row.endtNo;
		 objRiFrps.policyNo = row.policyNo;
		 objRiFrps.currDesc = row.currDesc;
		 objRiFrps.totFacTsi = row.totFacTsi;
		 objRiFrps.totFacPrem = row.totFacPrem;
		 
		 objRiFrps.parNo = row.parNo;
		 objRiFrps.parType = row.parType;
		 objRiFrps.distNo = row.distNo;
		 objRiFrps.distSeqNo = row.distSeqNo;
		 objRiFrps.renewNo = row.renewNo;
		 
		 objRiFrps.parId = row.parId;
		 objRiFrps.issCd = row.issCd;
		 objRiFrps.parYy = row.parYy;
		 objRiFrps.parSeqNo = row.parSeqNo;
		 
		 objRiFrps.sublineCd = row.sublineCd;
		 objRiFrps.renewNo = row.renewNo;
		 objRiFrps.polSeqNo = row.polSeqNo;
		 objRiFrps.issueYy = row.issueYy;
			
		 if (moduleId == "GIRIS002") {
			 showEnterRIAcceptancePage();
		 }else if(moduleId == "GIRIS001") {
			 showCreateRiPlacementPage();
		 } 
	} catch(e) {
		showErrorMessage("setRiFromDistFrpsLOV", e);
	}
}