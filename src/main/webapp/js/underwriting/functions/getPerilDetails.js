/*	Created by	: mark jm 07.28.2011
 * 	Moved from	: peril information page
 */
function getPerilDetails()	{
	try {		
		//var index				 = $("perilCd").selectedIndex;
		var itemNo				 = $F("itemNo");
		var riCommRt			 = $("txtPerilName").getAttribute("riCommRt");	//$("perilCd").options[index].getAttribute("riCommRt");
		var perilType			 = $("txtPerilName").getAttribute("perilType");	//$("perilCd").options[index].getAttribute("perilType");
		var bascPerlCd			 = $("txtPerilName").getAttribute("bascPerlCd");	//$("perilCd").options[index].getAttribute("bascPerlCd");
		var basicPeril			 = $("txtPerilName").getAttribute("basicPerilName");//$F("txtPerilName");	//"";
		var wcSw				 = $("txtPerilName").getAttribute("wcSw");	//$("perilCd").options[index].getAttribute("wcSw");
		var tarfCd				 = $("txtPerilName").getAttribute("tarfCd");	//$("perilCd").options[index].getAttribute("tarfCd");
		var defaultRate	 		 = $("txtPerilName").getAttribute("defaultRate"); //$("perilCd").options[index].getAttribute("defaultRate"); //belle 11092011
		var defaultTsi	         = $("txtPerilName").getAttribute("defaultTsi"); //$("perilCd").options[index].getAttribute("defaultTsi"); //belle 11092011
		var requiresBasicPeril	 = false;
		
		/*
		$("perilCd").childElements().each(function (o) {
			if (o.value == bascPerlCd){
				basicPeril = o.getAttribute("perilName");
			}
		});
		*/
		
		if (bascPerlCd != "") {
			requiresBasicPeril = true;
			/*$$("div[name='row2']").each(function(row){
				if (row.getAttribute("item") == itemNo){
					if (row.getAttribute("peril") == bascPerlCd){
						requiresBasicPeril = false;
					}	
				} 
			});*/
			
			for (var i = 0; i<objGIPIWItemPeril.length; i++){
				if ((itemNo == objGIPIWItemPeril[i].itemNo)
						&& (bascPerlCd == objGIPIWItemPeril[i].perilCd)
						&& (objGIPIWItemPeril[i].recordStatus != -1)){
					requiresBasicPeril = false;
				}
			}
		} 
		
		if (!requiresBasicPeril){			
			$("riCommRt").value		= formatToNineDecimal(riCommRt);
			$("perilType").value	= perilType;
			$("bascPerlCd").value	= bascPerlCd;
			$("wcSw").value 		= wcSw;
			$("defaultRate").value	= defaultRate; //belle 11.09.2011
			$("defaultTsi").value 	= defaultTsi;
			
			var lineCd = (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd")); 
			if (lineCd == objLineCds.FI || "FI" == lineCd){
				$("perilTarfCd").value = tarfCd;
			}
			
			if(objUWGlobal.lineCd == objLineCds.AC || objUWGlobal.menuLineCd == objLineCds.AC){
				showBaseAmt($("perilCd").value);
			}
			
			$("dumPerilCd").value	 = $("perilCd").value;
			//showPerilTarfOption($("perilCd").value); // comment muna
			validatePeril();
			showNoOfDays();			
		} else {
			showMessageBox(basicPeril+" should exist before this peril can be added.", imgMessage.ERROR);
			//$("perilCd").selectedIndex = 0;
			$("perilCd").value = "";
			$("txtPerilName").value = "";
		}
		
	} catch(e){
		showErrorMessage("getPerilDetails", e);
	} 
}