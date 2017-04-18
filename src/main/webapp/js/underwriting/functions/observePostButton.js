function observePostButton(opFlag){
	if($F("globalParType") == "P"){ // by bonok start :: 08.30.2012
		if($F("globalIssCd") != $F("globalIssCdRI") ){
			objUWGlobal.enablePost == 'Y' || (opFlag == "Y" && $F("globalParStatus") > 5) ? enableMenu("post") : disableMenu("post");
		} else if($F("globalIssCd") == $F("globalIssCdRI")){
			$F("globalParStatus") > 5  ? enableMenu("post") : disableMenu("post");
		}
	}else{
		if($F("globalLineCd") == "SU" || objUWGlobal.menuLineCd == "SU"){
			if($F("globalIssCd") == $F("globalIssCdRI")){ // added by: Nica 09.26.2012
				$F("globalParStatus") > 5 ? enableMenu("post") : disableMenu("post");
			}else if(objUWGlobal.enablePost == 'N'){
				$F("globalParStatus") > 5 && objUWGlobal.enableDist == 0 ? enableMenu("post") : disableMenu("post");
			}else{
				enableMenu("post");
			}
		}else{
			if($F("globalParStatus") > 4){
				if($F("globalIssCd") == $F("globalIssCdRI")){
					$F("globalParStatus") > 5 ? enableMenu("post") : disableMenu("post");
				}else{
					objUWGlobal.enablePost == 'Y' || (opFlag == "Y" && $F("globalParStatus") > 5) ? enableMenu("post") : disableMenu("post");
				}					
			}else if($F("globalParStatus") < 5){
				$F("globalParStatus") <= 2 ? disableMenu("post") : enableMenu("post");
			}
		}
	} // by bonok end :: 08.30.2012
}