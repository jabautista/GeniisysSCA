<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<%-- <jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include> --%>
<!-- bonok :: 10.16.2013 :: changed overlay to Overlay.show -->
<div id="postParDiv" name="postParDiv" class="sectionDiv" style="display: none; width: 460px; margin: 10px 40px;" align="center">
	<div style="float:left; width:100%; margin-top:10px; margin-bottom:15px;">	
		<label id="lblFrpsNo" style="margin-left:10px; font-weight: bolder;"></label>
	</div>	
	<div id="progressBarMainDiv" name="progressBarMainDiv" style="float:left; width:90%; margin-left:4.5%; heigth: 15px; border:1px solid #456179;">
	 	<div id="progressBarDivDummy" name="progressBarDivDummy" style="display:none; width:0%; float:left; background-color:red;">&nbsp;</div>
	 	<div id="progressBarDiv" name="progressBarDiv" style="width:0%; float:left; background-color:#456179; color:white;">&nbsp;</div>
	</div>
	<div id="statusMainDiv" name="statusMainDiv" style="float:left; width:310px; margin-left:4.5%; margin-top:5px; height:20px auto;">
		<div style="float:left; width:100%; text-align:left;">&nbsp;</div>
	</div>
	<div style="float:left; width:100%; margin-top:15px; margin-bottom:10px;">
		<input type="button" class="button" id="btnPostOk" name="btnPostOk" value="Ok" style="display:none;"/>
		<input type="button" class="button" id="btnPostFrps" name="btnPost" value="Post" />
		<input type="button" class="button" id="btnPostCancelFrps" name="btnPostCancel" value="Cancel"/>
		<!-- <input type="button" class="button" id="btnPrintFrps" value="Print"/> -->
	</div>		
</div>

<script>
	addStyleToInputs();
	initializeAll();

	objUW.wdistFrpsVDtls = JSON.parse('${GIRIDistFrpsWdistFrpsVJSON}'.replace(/\\/g, '\\\\'));	
	
	// bonok :: 10.17.2013 :: SR473 - GENQA
	objUW.fnlBinderIdArr = [];
	objUW.riAgrmntBndName = "";
	objUW.riAgrmntBndDesignation = "";
	objUW.riAgrmntBndAttest = "";
	objUW.printRab = "N";
	var autoPrintBinders = '${autoPrintBinders}'; // added by robert SR 4961 09.16.15
	var girir001PrinterName = '${girir001PrinterName}'; // added by robert SR 4961 09.16.15
	
	$("btnPostCancelFrps").observe("click", function(){
		if($("btnPostCancelFrps").value == "Exit"){ // added this condition - Nica 05.22.2012
			//hideOverlay();
			overlayPostRi.close(); // bonok :: 10.16.2013 :: changed overlay to Overlay.show
			if (nvl(objRiFrps.lineCd,null) == null && nvl(objRiFrps.lineName,null) == null){	
				getLineListingForFRPS();
			}else{
				updateMainContentsDiv("/GIRIDistFrpsController?action=showFrpsListing&ajax=1&lineCd="+objRiFrps.lineCd+"&lineName="+objRiFrps.lineName,
				  "Getting FRPS listing, please wait...");
			}
		}else{
			//hideOverlay();
			overlayPostRi.close(); // bonok :: 10.16.2013 :: changed overlay to Overlay.show
		}
	});

	$("btnPostFrps").observe("click", createBinders);

	function postFrps(){
		if ($F("btnPostFrps") == "Post"){
			new Ajax.Request(contextPath + "/PostParController", {
				method: "POST",
				parameters: {
					action: "postFrps",
					parId: 1,//objUWParList.parId,
					lineCd: objUW.wdistFrpsVDtls.lineCd,
					sublineCd: objUW.wdistFrpsVDtls.sublineCd,
					issCd:	objUW.wdistFrpsVDtls.issCd,
					issueYy: objUW.wdistFrpsVDtls.issueYy,
					polSeqNo: objUW.wdistFrpsVDtls.polSeqNo,
					renewNo: objUW.wdistFrpsVDtls.renewNo,
					frpsYy: objUW.wdistFrpsVDtls.frpsYy,
					frpsSeqNo: objUW.wdistFrpsVDtls.frpsSeqNo,
					distNo: objUW.wdistFrpsVDtls.distNo,
					distSeqNo: objUW.wdistFrpsVDtls.distSeqNo,
					parPolicyId: objUW.wdistFrpsVDtls.parPolicyId
				},
				asynchronous: true,
				onComplete: function (response) {
					var text = response.responseText;
					var arr = text.split(resultMessageDelimiter);
					if (response.responseText == 'N'){
						showMessageBox("Please post the policy first before printing the binders.", imgMessage.INFO);
					}
					if (arr[0] == "Posting complete.") {
						updater.stop();
						$("progressBarDiv").style.width = "100%";
						$("progressBarDiv").update("100%");
						$("statusMainDiv").down("div",0).update(arr[0]);
						//$("btnPostCancelFrps").hide();
						if(autoPrintBinders == "Y"){ // added by robert SR 4961 09.16.15
							$("btnPostFrps").value = "Post";
							disableButton($("btnPostFrps"));
						}else{
							$("btnPostFrps").value = "Print";
							enableButton($("btnPostFrps"));
						}// end robert SR 4961 09.16.15
						$("btnPostCancelFrps").value = "Exit";
						
						//$("btnPostOk").show();
						//okObserve();
						good("postParDiv");
						$("progressBarDiv").style.background = "green";
						openPostFrpsModal();
						if(autoPrintBinders == "Y"){ // added by robert SR 4961 09.16.15
							if(nvl($("riPolicyNo").value, "") == ""){
								showMessageBox("Automatic printing of binders is not allowed for unposted policies.", "I");
							}else{
								getBindersForPrinting();				
							}
						}// end robert SR 4961 09.16.15
					} else {
						showMessageBox(arr[1].truncate(350, "..."), imgMessage.ERROR);
						$("progressBarDiv").style.background = "red";
						bad("postParDiv");
						enableButton("btnPostCancelFrps");
						disableButton("btnPostFrps");
					}				
				}
			});
			try {
				updater = new Ajax.PeriodicalUpdater('progressBarDivDummy','PostParController', {
	            	asynchronous:true, 
	            	frequency: 1, 
	            	method: "GET",
	            	onSuccess: function(request) {
						var text = request.responseText;
						var arr = text.split(resultMessageDelimiter);
						$("progressBarDiv").style.width = arr[0];
						$("progressBarDiv").update(((arr[0] == "0%")? "<font color='#456179'>"+arr[0]+"</font>":arr[0]));
						$("statusMainDiv").down("div",0).update((arr[1] == "") ? "&nbsp;" : arr[1]);
						if (arr[2] == ""){
							if (arr[0] == "100%") {
								$("progressBarDiv").style.width = arr[0];
								updater.stop();
							}	
						} else {
							$("statusMainDiv").down("div",0).update("<font color='red'><b>ERROR:</b></font> "+arr[1]);
							updater.stop();
						}
					}
				});
			} catch(e) {
				showErrorMessage("postPAR Periodical Updater", e);
	        } finally {
		        initializeAll();
	        }  
		}else {
			if(nvl($("riPolicyNo").value, "") == ""){
				showMessageBox("Please post the policy first before printing the binders.", "I");
			}else{
				showPrintFrpsDialog();				
			}
			//showMessageBox("No printing function yet. Please use client server to print posted FRPS.", imgMessage.INFO);
		}
	}
	
	function createBinders() {
		try {
			new Ajax.Request(contextPath+"/GIRIWFrpsRiController", {
					method: "POST",
					parameters: {
						action : "createBinders",
						lineCd: objRiFrps.lineCd,
						frpsYy: objRiFrps.frpsYy,
						frpsSeqNo: objRiFrps.frpsSeqNo,
						sublineCd: 	objRiFrps.sublineCd,
						issCd :objRiFrps.issCd,
						parYy :objRiFrps.parYy,
						parSeqNo : objRiFrps.parSeqNo,
						polSeqNo : objRiFrps.polSeqNo,
						renewNo : objRiFrps.renewNo,
						issueYy :objRiFrps.issueYy,
						premVatNew :nvl(objGIRIS002.sveRiPremVat,0),
						status: objGIRIS002.status
					},
					asychronous: false,
					evalScripts: true,
					onCreate: function() {
						showNotice("Creating binders...");
					},
					onComplete: function(response) {
						hideNotice("");
						if(checkErrorOnResponse(response)) {
							postFrps();
						}
					}
				});
		} catch(e) {
			showErrorMessage("createBinders", e);
		} 
	}	
	
	function showPrintFrpsDialog(){
		overlayGenericPrintDialog = Overlay.show(contextPath+"/GIRIWFrpsRiController", {
			urlContent : true,	
			urlParameters: {
				action : "showPrintFrpsDialog",
				distNo : objUW.wdistFrpsVDtls.distNo
			},
		    title: "Print",
		    height: 165,
		    width: 380,
		    draggable: true
		});
	}
	
	/* $("btnPrintFrps").observe("click", function(){
		hideOverlay();
		showPrintFrpsDialog();
	}); */

	function openPostFrpsModal2() {
		Modalbox.show(contextPath+"/GIRIFrpsRiController?action=showModifyPostedDtls&ajaxModal=1&parId=1&lineCd=" + objUW.wdistFrpsVDtls.lineCd +"&frpsYy=" + objUW.wdistFrpsVDtls.frpsYy + "&frpsSeqNo=" + objUW.wdistFrpsVDtls.frpsSeqNo, {
		//Modalbox.show(contextPath+"/GIRIFrpsRiController?action=showModifyPostedDtls&ajaxModal=1&parId=1&lineCd=" + 'AV' +"&frpsYy=" + 13 + "&frpsSeqNo=" + 44, {
			title: "List of Binders",
			width: 600,
			height: 355,
			onComplete: function(){
				
			}
		});	
	}
		
	// bonok :: 10.16.2013 :: changed Modalbox to Overlay.show
	function openPostFrpsModal() {
		overlayOpenPostFrps = Overlay.show(contextPath+"/GIRIFrpsRiController", {
			urlContent: true,
			urlParameters: {
				action: "showModifyPostedDtls",
				ajaxModal: 1,
				parId: 1,
				lineCd: objUW.wdistFrpsVDtls.lineCd,
				frpsYy: objUW.wdistFrpsVDtls.frpsYy,
				frpsSeqNo: objUW.wdistFrpsVDtls.frpsSeqNo
			},
			title: "List of Binders",
			height: 311,
			width: 585,
			draggable: true
		});
	}
	//added by robert SR 4961 09.16.15
	function getBindersForPrinting(){
		var content = contextPath+"/GIRIWFrpsRiController?action=getPrintFrps&distNo="+objUW.wdistFrpsVDtls.distNo;
		new Ajax.Request(content, {
				method: "GET",
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						obj = JSON.parse(response.responseText);
						for(var i=0; i<obj.length; i++){
							printBinder(obj[i].lineCd, obj[i].binderYy, obj[i].binderSeqNo, obj[i].fnlBinderId);	
						}
					}
				}
			});
	}

	function printBinder(lineCd, binderYy, binderSeqNo, fnlBinderId){
		var content = contextPath+"/ReinsuranceAcceptanceController?action=doPrintFrps&lineCd="+lineCd+"&binderYy="+binderYy+"&binderSeqNo="+binderSeqNo+"&fnlBinderId="+fnlBinderId;
			new Ajax.Request(content, {
				method: "GET",
				parameters : {noOfCopies : 1,
						 	 printerName : girir001PrinterName},
				evalScripts: true,
				asynchronous: true,
				onCreate   : showNotice("Printing Binder Report, please wait..."),
				onComplete: function(response){
					if (response.responseText.include("No suitable print service found.")) {
						showMessageBox("Automatic printing of binders is not successful. Please check the printer indicated in the Underwriting parameter 'GIRIR001_PRINTER_NAME'.", imgMessage.ERROR);
						return false;
					}else if (checkErrorOnResponse(response)){
						showMessageBox("Printing complete.", "S");
					}
				}
			});
	}
	//end robert SR 4961 09.16.15
	//$("parNo").innerHTML = $F("riParNo"); replaced by: Nica 05.22.2012
	$("lblFrpsNo").innerHTML = $F("frpsNo");
	//$("close").hide(); // bonok :: 10.16.2013 :: changed overlay to Overlay.show
</script>