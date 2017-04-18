// assured related scripts
function useAssured(){
	try{
		var selectedId= $("selectedClientId").value;
		if (nvl(selectedId,")") != "0")	{
			if($("lblModuleId").getAttribute("moduleId") == "GIPIS002"){
				$("globalAssdNo").value = selectedId; // bonok :: 03.25.2014 :: change the value of globalAssdNo upon selecting a new Assured
				
				if(objUW.hidObjGIPIS002.isOpenPolicy == "Y"){ // bonok :: 03.25.2014 :: as per Mam Roset, clear the Ref Open Policy No. and Open Policy No. when a new Assured Name is selected  
					if($F("gipiWItemExist") != "Y"){
						$("refOpenPolicyNo").clear();
						$("opSublineCd").clear();
						$("opIssCd").clear();
						$("opIssYear").clear();
						$("opPolSeqNo").clear();
						$("opRenewNo").clear();
					}
				}
			}
			var clientCd = selectedId;
			var name =  $(selectedId+"name").getAttribute("title").strip() ; //$(selectedId+"name").innerHTML; //edit Nok
			var birthDate = $(selectedId+"birthDate").innerHTML;
			var address1 = $(selectedId+"address1").value;
			var address2 = $(selectedId+"address2").value;
			var address3 = $(selectedId+"address3").value;
			var industryNm = $(selectedId+"industryNm").value;
			var industryCd = $(selectedId+"industryCd").value;
			
			$$("input[name='assuredNo']").each(function (a) {
				a.value = selectedId;
			});
			//$("assuredNo").value = selectedId;
			$$("input[name='assuredName']").each(function (a) {
				a.value = name;
			});
			
			$("address1").value = address1;
			$("address2").value = address2;
			$("address3").value = address3;
			if ($("industry")) $("industry").value = nvl(industryCd,"");
			
			changeTag = "1"; //added by irwin
		}
		$("assuredName").focus();
	}catch(e){
		showErrorMessage("useAssured",e);
	}	
}