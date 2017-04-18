<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="postRecPaytDiv" name="postRecPaytDiv" class="sectionDiv" style="width: 460px; margin: 10px 40px;" align="center">
	<div id="waitDiv" name="waitDiv" style="float:left; width:100%; margin-bottom:10px; margin-top: 10px;">	
		<label style="margin-left:20px;">Please wait...</label>
	</div>
	<div id="progressBarMainDiv" name="progressBarMainDiv" style="float:left; width:90%; margin-left:4.5%; heigth: 15px; border:1px solid #456179;">
	 	<div id="progressBarDivDummy" name="progressBarDivDummy" style="display:none; width:0%; float:left; background-color:red;">&nbsp;</div>
	 	<div id="progressBarDiv" name="progressBarDiv" style="width:0%; float:left; background-color:#456179; color:white;">&nbsp;</div>
	</div>
	<div id="statusMainDiv" name="statusMainDiv" style="float:left; width:310px; margin-left:4.5%; margin-top:5px; height:20px auto;">
		<div style="float:left; width:100%; text-align:left;">&nbsp;</div>
	</div>
	<div style="float:left; width:100%; margin-top:15px; margin-bottom:10px;">
		<input type="button" class="button" id="btnPostRecPayt" name="btnPostRecPayt" value="Ok" />
	</div>	
</div>

<script>
    var recPosted = false;
	$("btnPostRecPayt").observe("click", function(){
		generateAEOverlay.close();
		if(recPosted) showGenerateRecoveryAcctEntries(claimId, $F("c042RecAcctId"));
	});
	postEntries();
	
	var claimId = $F("hidClaimId");
	var recAcctId = $F("c042RecAcctId");
	
	function postEntries() {
		try {
			var objParams = getMainPostParams();
			//objParams.objRecPayts = recPaytGrid.getRow($F("selectedPaytIndex"));
			if($F("selectedPaytIndex") != "") {
				new Ajax.Request("BatchController", {
					method: "POST",
					parameters: {
						action: "postRecovery",
						strParameters: JSON.stringify(objParams)
					},
					asynchronous: true,
					evalScripts: true,
					onComplete: function(response) {
						var text = response.responseText;
						var arr = text.split(resultMessageDelimiter);
						
						if(arr[0] == "Loss Recovery Adjusting Entries Generated.") {
							updater.stop();
							$("progressBarDiv").style.width = "100%";
							$("progressBarDiv").update("100%");
							$("statusMainDiv").down("div",0).update(arr[0]);
							$("waitDiv").update("");
							recPosted = true;
							showGenerateRecoveryAcctEntries(claimId, recAcctId);
						}
					}
				});
				
				try {
					updater = new Ajax.PeriodicalUpdater('progressBarDivDummy','BatchController', {
	                	asynchronous:true, 
	                	frequency: 1, 
	                	method: "GET",
	                	onSuccess: function(request) {
							var text = request.responseText;
							var arr = text.split(resultMessageDelimiter);
							$("progressBarDiv").style.width = arr[0];
							$("progressBarDiv").update(((arr[0] == "0%")? "<font color='#456179'>"+arr[0]+"</font>":arr[0]));
							$("statusMainDiv").down("div",0).update((arr[1] == "") ? "&nbsp;" : arr[1]);
							
							if (nvl(arr[2],"") == ""){
								if (arr[0] == "100%") {
									$("progressBarDiv").style.width = arr[0];
									updater.stop();
								}	
							} else {
								$("statusMainDiv").down("div",0).update("<font color='red'><b>ERROR:</b></font> "+arr[1]);
								params ? showMessageBox(arr[2], "E") :null;
								$("progressBarDiv").style.background = "red";
								bad("postRecPaytDiv");
								updater.stop();
							}
							$("waitDiv").update("");
						
						}
					});
				} catch(e) {
					showErrorMessage("Generate AE Periodical Updater", e);
		        } finally {
			        initializeAll();
		        } 
			} else {
				showMessageBox("Please select an entry to post.");
			}
		} catch(e) {
			showErrorMessage(e);
		}
	}

	function getMainPostParams() {
		try {
			var obj = new Object();
			obj.varFundCd = $F("varFundCd");
			obj.varBranchCd = $F("varBranchCd");
			obj.recoveryAcctNo = $F("recoveryAcctNo");
			obj.recoveryAcctId = $F("c042RecAcctId") == "" ? null : $F("c042RecAcctId");
			obj.recAcctYear = $F("c042RecAcctYear") == "" ? null : $F("c042RecAcctYear");
			obj.recAcctSeqNo = $F("c042RecAcctSeqNo") == "" ? null : $F("c042RecAcctSeqNo");
			obj.tranDate = $F("c042TranDate");
			obj.recAcctFlag = $F("c042RecAcctFlag");
			obj.recoveryAmt = $F("recoveredAmt") == "" ? null : unformatCurrencyValue($F("recoveredAmt"));
			return obj;
		} catch(e) {
			showErrorMessage("getMainPostParams", e);
		}
	}
</script>