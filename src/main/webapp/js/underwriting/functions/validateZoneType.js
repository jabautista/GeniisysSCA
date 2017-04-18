//Gzelle 05062015
function validateZoneType(perilCd,tran) {
	var lineCd = getLineCd();
	new Ajax.Request(contextPath+"/GIISPerilController?", {
		method: "GET",
		parameters: {
			action: "chkPerilZoneType",
			parPolId : (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")),
			lineCd : lineCd,
			perilCd : perilCd,
			itemNo : $F("itemNo")
		},
		evalScripts: true,
		asynchronous: false,
		onComplete: function (response) {
			if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
				var hasMaintained = response.responseText;
				if (tran == "Del") {
					hasMaintained = "NO";
					perilCd = "";
				}
				if (hasMaintained == "YES") {
					$("eqZoneDesc").addClassName("required");
					$("eqZoneDesc").up("div", 0).addClassName("required");
					$("typhoonZoneDesc").addClassName("required");
					$("typhoonZoneDesc").up("div", 0).addClassName("required");
					$("floodZoneDesc").addClassName("required");
					$("floodZoneDesc").up("div", 0).addClassName("required");
					if ($F("eqZoneDesc") == "" || $F("typhoonZoneDesc") == "" || $F("floodZoneDesc") == "") {
						$("eqZoneDesc").up("div", 0).setAttribute("zoned","changed");
						$("typhoonZoneDesc").up("div", 0).setAttribute("zoned","changed");
						$("floodZoneDesc").up("div", 0).setAttribute("zoned","changed");
					}
				}else {
					if (perilCd == null || perilCd == "") {
						$("eqZoneDesc").removeClassName("required");
						$("eqZoneDesc").up("div", 0).removeClassName("required");
						$("typhoonZoneDesc").removeClassName("required");
						$("typhoonZoneDesc").up("div", 0).removeClassName("required");
						$("floodZoneDesc").removeClassName("required");
						$("floodZoneDesc").up("div", 0).removeClassName("required");
					}
				}
			}
		}
	});
}