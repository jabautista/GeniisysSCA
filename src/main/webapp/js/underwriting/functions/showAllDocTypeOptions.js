function showAllDocTypeOptions(){
	$("docType").childElements().each(function (o) {
		//o.show();
		showOption(o);
		if ($F("billNotPrinted")=="Y"){
			$("docType").childElements().each(function (o) {
				if (o.value == "BILL"){
					//o.hide();
					hideOption(o);
				}
			});
		}
		
		if($F("printOrder") == "1"){
			if(o.value == "ENDORSEMENT"){
				parseFloat(nvl($("endtSeqNo").value, 0)) == 0 ? hideOption(o) : showOption(o);			
			}
			
			if(o.value == "POLICY"){
				parseFloat(nvl($("endtSeqNo").value, 0)) != 0 ? hideOption(o) : showOption(o);
			}
		}else if($F("printOrder") == "2"){
			if(o.value == "ENDORSEMENT"){
				nvl($F("txtEndtSeqNo"), "") == "" ? hideOption(o) : showOption(o);			
			}
			
			if(o.value == "POLICY"){
				nvl($F("txtEndtSeqNo"), "") != "" ? hideOption(o) : showOption(o);
			}
			
			if(o.value == "POLICY_SU" && ("SU" == $F("policyLineCd"))){
				nvl($F("txtEndtSeqNo"), "") != "" ? hideOption(o) : showOption(o);
			}
		}		
	});
}