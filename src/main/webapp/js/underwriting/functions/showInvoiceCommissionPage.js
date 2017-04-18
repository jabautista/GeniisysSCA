//mrobes 02.19.10 shows Invoice Commission Page
function showInvoiceCommissionPage(){
	try	{
		if ($("uwParParametersForm") == null){
			if($F("globalParId").blank()){
				showMessageBox("Please select a policy.", imgMessage.ERROR);
				return;
			} else {
				updateParParameters();
			}
		}
		var lineCd = getLineCd();
		var ok = false;
		var parId;
		var parNo;
		var assdNo;
		var assdName;
		var lineCd;
		var issCd;
		var isPack = "N";
		var action = "showCommInvoicePage";
		
		if (objUWGlobal != null) {
			if (String(nvl(objUWGlobal.packParId, "")).blank()) {
				if ($F("globalParStatus") < 6 && (lineCd != "SU" || nvl(objUWGlobal.menuLineCd,lineCd) != "SU")) { //added nvl by robert  SR 5253 02.01.16
					ok = false;
				} else {
					ok = true;
					isPack = "N";
					
					parId = $F("globalParId");
					parNo = $F("globalParNo");
					assdNo = $F("globalAssdNo");
					assdName = $F("globalAssdName");
					lineCd = $F("globalLineCd");
					issCd = $F("globalIssCd");
				}
			} else {
				// pack (emman 06.28.2011)
				if (objUWGlobal.parType == "P" && objUWGlobal.parStatus < 6 && (objUWGlobal.lineCd != "SU" || nvl(objUWGlobal.menuLineCd,objUWGlobal.lineCd) != "SU")) {  //added nvl by robert  SR 5253 02.01.16
					ok = false;
				} else {
					ok = true;
					isPack = "Y";
					
					parId = objUWGlobal.packParId;
					parNo = objUWGlobal.parNo;
					assdNo = objUWGlobal.assdNo;
					assdName = objUWGlobal.assdName;
					lineCd = objUWGlobal.lineCd;
					issCd = objUWGlobal.issCd;
				}
			}
		} else {
			if ($F("globalParStatus") < 6 && (lineCd != "SU" || nvl(objUWGlobal.menuLineCd,lineCd) != "SU")) {  //added nvl by robert  SR 5253 02.01.16
				ok = false;
			} else {
				ok = true;
				isPack = "N";
				
				parId = $F("globalParId");
				parNo = $F("globalParNo");
				assdNo = $F("globalAssdNo");
				assdName = $F("globalAssdName");
				lineCd = $F("globalLineCd");
				issCd = $F("globalIssCd");
			}
		}
		
		if (!ok) {
			showMessageBox("Invoice Commission menu is not yet accessible due to selected PAR status.", imgMessage.ERROR);
			return;
		}
		
		if (objUWGlobal.lineCd == "SU" || objUWGlobal.menuLineCd == "SU") {
			action = "showEndtBondCommInvoicePage";
		}
		
		new Ajax.Updater("parInfoDiv", contextPath+"/GIPIWCommInvoiceController?action="+action,{
			method: "GET",
			parameters: {parId:    parId,
						 parNo:    parNo,
						 assdNo:   assdNo,
						 assdName: assdName,
						 lineCd:   lineCd,
						 issCd:	   issCd,
						 isPack:   isPack
						 },
			evalScripts: true,
			asynchronous: true,
			onCreate: function() {
				showNotice("Getting invoice commission, please wait...");
			},
			onComplete: function () {
				hideNotice("");
				Effect.Appear($("parInfoDiv").down("div", 0), { //liabilityMainDiv 
					duration: .001
				});
			}
		});
	} catch (e) {
		showErrorMessage("showInvoiceCommissionPage", e);
		/*if("element is null" == e.message){
			showMessageBox("Some parameters needed to open this page is missing.", imgMessage.ERROR);
		} else {
			showMessageBox(e.message);
		}*/
	}
}