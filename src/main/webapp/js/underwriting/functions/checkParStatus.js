function checkParStatus(){
	 new Ajax.Request(contextPath+"/CopyUtilitiesController?action=checkParStatus",{
			parameters: {
				lineCd     : $("lineCd").value,
				issCd      : $("issCdSearch").value,  //changed by jeffdojello from issueCd  05.07.2014
				parYr      : $("parYrSel").value == "" ? "-99": $("parYrSel").value,
				parSeqNo   : $("parNoSearch").value,
				quoteSeqNo : $("quoteSeqNoSearch").value   //changed by jeffdojello from quoteSeqNo 05.07.2014
			},
			method: "GET",
			evalScripts: true,
			asynchronous: false,
			onCreate:
				 showNotice("Working...please wait..."),
			onComplete: function (response) {
				if(checkErrorOnResponse(response)){
					var res = JSON.parse((response.responseText).replace(/\\/g, '\\\\'));
					var parStatus = "";
					var parType = "";
					var parId = "";
					var isPack = ""; //jeffdojello 04.24.2013 
					
					for(var x=0; x<res.length; x++){
						parStatus = res[x].parStatus;
						parType   = res[x].parType;
						parId     = res[x].parId;
						isPack	  = res[x].isPack; //jeffdojello 04.24.2013
					};
					if(res.length == 0){
						showMessageBox("PAR No. does not exist in master file.", imgMessage.ERROR);
					}else{
						if(parType == 'E'){
							showMessageBox("PAR No. which has an endorsement par type cannot be copied.", imgMessage.INFO);
						}else if (parStatus == '10'){
							showMessageBox("PAR No. has been posted, cannot be copied.", imgMessage.INFO);//added space between , and c reymon 11132013
						}else if (parStatus == '99'){
							showMessageBox("PAR No. has been deleted, cannot be copied.", imgMessage.INFO);//added space between , and c reymon 11132013
						}else if (parStatus == '98'){															//added by pjsantos 11/08/2016, to show appropriate message when picked PAR is cancelled GENQA 5819.
							showMessageBox("PAR No. has been cancelled, cannot be copied.", imgMessage.INFO);
						}else if (isPack == 'Y'){ //added by jeffdojello 04.24.2013 to exclude par under a package
							showMessageBox("PAR No. is under a package, cannot be copied.", imgMessage.INFO);
						}else{
							copyParToPar(parId);
						}
					}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
				
			}
		});
	}