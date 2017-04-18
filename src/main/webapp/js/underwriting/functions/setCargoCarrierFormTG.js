/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	09.23.2011	mark jm			set values on cargo carrier form (tablegrid version)
 * 	11.18.2011	mark jm			remove changed attribute by invoking
 */
function setCargoCarrierFormTG(obj){
	try{		
		$("carrierVesselCd").value 		= obj == null ? "" : obj.vesselCd;
		$("carrierVesselName").value	= obj == null ? "" : unescapeHTML2(obj.vesselName);
		$("carrierPlateNo").value 		= obj == null ? "" : unescapeHTML2(obj.plateNo);
		$("carrierMotorNo").value 		= obj == null ? "" : unescapeHTML2(obj.motorNo);
		$("carrierSerialNo").value 		= obj == null ? "" : unescapeHTML2(obj.serialNo);
		$("carrierLimitLiab").value 	= obj == null ? "" : (obj.vesselLimitOfLiab == null ? "" : formatCurrency(obj.vesselLimitOfLiab));
		//$("carrierEtd").value 			= (obj == null || nvl(obj.etd, "") == "" ? "" : dateFormat(Date.parse(obj.etd), "mm-dd-yyyy"));
		//$("carrierEta").value 			= (obj == null || nvl(obj.eta, "") == "" ? "" : dateFormat(Date.parse(obj.eta), "mm-dd-yyyy"));		
		$("carrierOrigin").value 		= obj == null ? "" : unescapeHTML2(obj.origin);
		$("carrierDestn").value 		= obj == null ? "" : unescapeHTML2(obj.destn);
		$("carrierDeleteSw").value 		= obj == null ? "" : obj.deleteSw;
		$("carrierVoyLimit").value 		= obj == null ? "" : unescapeHTML2(obj.voyLimit);
		
		$("btnAddCarrier").value		= obj == null ? "Add" : "Update";		
		
		if(obj == null){
			$("hrefCarrierVessel").show();
			disableButton($("btnDeleteCarrier"));
			
			$("carrierEtd").value = "";
			$("carrierEta").value = "";
		}else{
			$("hrefCarrierVessel").hide();
			enableButton($("btnDeleteCarrier"));
			
			var dateformatting = /^\d{1,2}(\-)\d{1,2}\1\d{4}$/; // format : mm-dd-yyyy
			 
			if((obj.etd != null || obj.etd != undefined) && !(dateformatting.test(obj.etd))){			 
				$("carrierEtd").value = dateFormat(obj.etd, "mm-dd-yyyy");
			}else{
				$("carrierEtd").value = "";
			}
			
			if((obj.eta != null || obj.eta != undefined) && !(dateformatting.test(obj.eta))){			 
				$("carrierEta").value = dateFormat(obj.eta, "mm-dd-yyyy");				
			}else{
				$("carrierEta").value = "";
			}
		}
		
		$("carrierEtd").setAttribute("lastValidValue", $F("carrierEtd").blank() ? "" : $F("carrierEtd"));
		$("carrierEta").setAttribute("lastValidValue", $F("carrierEta").blank() ? "" : $F("carrierEta"));
		
		if($("txtTotalLimitOfLiability") != null && $("txtTotalLimitOfLiability") != undefined){
			$("txtTotalLimitOfLiability").value = computeTotalAmt(objGIPIWCargoCarrier,
					function(o){ return nvl(o.recordStatus, 0) != -1 && o.itemNo == ((objCurrItem != null && objCurrItem.recordStatus != -1) ? objCurrItem.itemNo : 0); }, "vesselLimitOfLiab");
		}
		
		//hideToolbarButtonInTG(tbgCargoCarriers);
		($$("div#listOfCarriersInfo [changed=changed]")).invoke("removeAttribute", "changed");
	}catch(e){
		showErrorMessage("setCargoCarrierFormTG", e);
	}
}