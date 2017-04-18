// jerome 01.05.10 for basic information
//edited by cris 04.27.10 added case when par_type = "E"
// Ajax updater for show basic info is transferred to getBasicInfo()
function showBasicInfo(){
	try {
		updateParParameters();	// andrew 07.13.2010
		var info = $F("globalParType")=="E" ? "Endt Basic Information" : "Basic Information";
			
			if (($F("globalParId").blank()) || ($F("globalParId") == "0")) {
				showMessageBox("You are not allowed to view this page.", imgMessage.ERROR);			
				return;
			} else if ($F("globalLineCd") == "SU"){
				showMessageBox("You are not allowed to view this page.", imgMessage.ERROR);
				return;
			} 
			var parId = $F("globalParId");
			var lineCd = $F("globalLineCd");
			var issCd = $F("globalIssCd");
			var parType = $F("globalParType");
			/*var globalAssdNo = $F("globalAssdNo");//jmm
			var globalAssdName = $F("globalAssdName");*/
			if(parType == "E") {
				var sublineCd = $F("globalSublineCd");
				var issueYY = $F("globalIssueYy");
				var polSeqNo = $F("globalPolSeqNo");
				var renewNo = $F("globalRenewNo");
				
				var temp="";
				if(sublineCd.blank() && issueYY.blank() && polSeqNo.blank() && renewNo.blank()){
					overlayPolicyNumber = Overlay.show(contextPath+"/GIPIParInformationController", {
											urlContent: true,
											urlParameters: {action : "showPolicyNo",
															parId : parId,
															lineCd : lineCd,
															issCd : issCd,
															sublineCd : sublineCd,
															globalAssdNo : globalAssdNo,
															globalAssdName : globalAssdName},
										    title: "Policy Number",
										    height: 100,
										    width: 440,
										    draggable: true
										});
					/*showOverlayContent2(contextPath+"/GIPIParInformationController?action=showPolicyNo&parId="+parId+"&lineCd="
							+lineCd+"&issCd="+issCd+"&sublineCd="+sublineCd+"&polSeqNo="+temp+"&issueYy="+temp+"&renewNo="+temp,
							"Policy Number", 490, "");*/
					
				} else {
					getBasicInfo();
				}
				$("samplePolicy").innerHTML = "Sample Endorsement";
			}else{
				getBasicInfo();
				$("samplePolicy").innerHTML = "Sample Policy";
			}
		} catch(e) {
			showErrorMessage("showBasicInfo", e);
		}
	}
//}
//cris