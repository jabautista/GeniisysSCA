/*	Created by	: mark jm 07.28.2011
 * 	Moved from	: peril information page
 */
function getPostTextTsiAmtDetails2(){
	try {
		var tsiValue =$F("perilTsiAmt").replace(/,/g, "");
		var nbtPremAmt = ($F("premiumAmt")).replace(/,/g, "");
		var perilCd = "";
		
		$("perilTsiAmt").value = formatCurrency(tsiValue);
		$("premiumAmt").value =  computePerilPremAmount($F("prorateFlag"), $F("perilTsiAmt"), $F("perilRate"));
		$("perilRiCommAmt").value = formatCurrency(($F("premiumAmt")).replace(/,/g, "")*$F("perilRiCommRate")/100);		
		
		$("premiumAmt").value = "";		
		perilCd = $F("perilCd").empty() ? $("txtPerilName").getAttribute("perilCd") : $F("perilCd");
		
		
		//if ("" != $("perilCd").value){  
		if ("" != perilCd){
			new Ajax.Request(contextPath+"/GIPIWItemPerilController?action=getPostTextTsiAmtDetails",{
				method: "POST",
				evalScripts: true,
				asynchronous: true,
				parameters:{
					globalParId: (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")),
					itemNo: $F("itemNo"),
					perilCd: perilCd, 
					premRt: $F("perilRate").replace(/,/g, ""),
					tsiAmt: $F("perilTsiAmt").replace(/,/g, ""),
					premAmt: nbtPremAmt,
					annTsiAmt: $F("perilAnnTsiAmt").replace(/,/g, ""),
					annPremAmt: $F("perilAnnPremAmt").replace(/,/g, ""),
					itemTsiAmt: $F("tsiAmt").replace(/,/g, ""),
					itemPremAmt: $F("premAmt").replace(/,/g, ""),
					itemAnnTsiAmt: $F("annTsiAmt").replace(/,/g, ""),
					itemAnnPremAmt: $F("annPremAmt").replace(/,/g, "")
						},
				onCreate: function () {
					disableButton("btnAddItemPeril");
				},
				onComplete: function (response)	{	
					var rt = response.responseText;
					if (rt.include("ORA-06502")){
						$("perilTsiAmt").value = "";
						$("premiumAmt").value = "";
						$("perilTsiAmt").focus();
						showMessageBox("The computed premium amount exceeds the maximum allowable value. Please enter a different TSI amount.", imgMessage.ERROR);
					} else if (checkErrorOnResponse(response)){
						var dtls = rt.split(",");
						$("premiumAmt").value = formatCurrency(dtls[0]);
						$("perilAnnPremAmt").value = formatCurrency(dtls[1]);
						$("perilAnnTsiAmt").value = formatCurrency(dtls[2]);
						$("premAmt").value = formatCurrency(dtls[3]);
						$("annPremAmt").value = formatCurrency(dtls[4]);
						$("tsiAmt").value = formatCurrency(dtls[5]);
						$("annTsiAmt").value = formatCurrency(dtls[6]);
						$("perilTsiAmt").value = formatCurrency(dtls[7]);
						$("premiumAmt").focus();
						var tsiAmt = $F("perilTsiAmt").replace(/,/g, "");
						tsiAmt = (tsiAmt == "") ? 0.00 : parseFloat(tsiAmt);
						$("varPerilTsiAmt").value = formatCurrency(tsiAmt);
						if($F("perilRate") == "" || unformatCurrencyValue($F("perilRate")) == 0){
							$("perilRate").value = computeItmPerilRate(); // To compute for peril rate again. For default rates of perils - irwin 9.6.2012
						}
						if ($F("perilRate") == ""){
							$("perilRate").value = "0.000000000";
						}
					}
					enableButton("btnAddItemPeril");
					setCursor("default");
			}});
		} else {			
			if ($F("perilRate") == ""){
				$("perilRate").value = "0.000000000";
			}
			$("perilTsiAmt").value = formatCurrency(tsiValue);
			$("premiumAmt").value =  computePerilPremAmount($F("prorateFlag"), $F("perilTsiAmt"), $F("perilRate"));
			
		}
	} catch (e){
		showErrorMessage("getPostTextTsiAmtDetails2", e);
	}
}