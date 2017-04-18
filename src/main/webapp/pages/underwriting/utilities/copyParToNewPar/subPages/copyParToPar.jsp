<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="copyParToParMainDiv" name="copyParToParMainDiv" style="margin-top : 1px;">
	<div id="copyParToParMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="copyParToParExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Copy PAR to a New PAR</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>
	
	<div id ="copyParToParDiv" class="sectionDiv" align="center">
		<table cellspacing="0" border="0" style="margin: 35px auto; float: center;">
			<tr style = "height: 10px;">
				<td class="rightAligned">From</td>
				<td class="leftAligned" style="width: 200;">
					
					<div style="width: 56px; float: left;" class="withIconDiv">
						<input type="text" id="lineCdSearch" name="lineCdSearch" value="" style="width: 25px; text-transform: uppercase;" class="withIcon" maxlength="2">
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCd" name="searchLineCd" alt="Go" />
					</div>
						
					<div class="withIconDiv" style="width: 56px; float: left;"  id="issDiv" name="issDiv">
						<input type="text" id="issCdSearch" name="issCdSearch" value="" style="width: 25px; text-transform: uppercase;" class="withIcon" maxlength="2">
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIssCd" name="searchIssCd" alt="Go" />
					</div>
						
					<div style="width: 42px; float: left;">
						<input id="parYrSel" name="parYrSel" type="text" style="width: 30px; float: center;" value="" maxlength="2"/>
					</div>
					
					<div style="width: 80px; float: left;" class="withIconDiv">
						<input type="text" id="parNoSearch" name="parNoSearch" value="" style="width: 48px;" class="withIcon" maxlength="6">
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchParNo" name="searchParNo" alt="Go" />
					</div>			
					
					<div style="width: 42px; float: left;">
						<input id="quoteSeqNoSearch" name="quoteSeqNoSearch" type="text" style="width: 30px; " value="" maxlength="2"/>
					</div>
			</tr>
			<tr>
				<td class="rightAligned">To</td>
				<td class="leftAligned" style="width: 200">
					<div style="width: 62px; float: left;">
						<input id="lineCd" name="lineCd" type="text" style="width: 50px; color:gray;" value="" readonly="readonly" maxlength="2"/>
					</div>
					<div style="width: 56px; float: left;" class="withIconDiv">
						<input id="issueCd" name="issueCd" type="text" style="width: 25px; text-transform: uppercase;" class="withIcon upper" value="" maxlength="2"/>
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtIssCdIcon" name="txtIssCdIcon" alt="Go" />
					</div>
					<input id="parYr" name="parYr" type="text" style="width: 30px;" value="" maxlength="2"/>
					<input id="parSeqNo" name="parSeqNo" type="text" style="width: 74px;" value="" readonly="readonly"/>
				    <input id="quoteSeqNo" name="quoteSeqNo" type="text" style="width: 30px;" value="" maxlength="2" />
				    <input type="hidden" id="varLineCd" name="varLineCd" value=""/>		
				</td>
			</tr>
		</table>
	</div >
	<div><br></div>
	<div  style = "border: 0; margin: 10px auto" class ="sectionDiv" id = "buttonDiv">
		<table align="center" >
		<tbody>
			<tr>
				<td align="center" colspan="4" >
					<input id="btnCopyPar" class="button" type="button" name="btnCopyPar" value="Copy">
					<input id="btnCancel" class="button" type="button" name="btnCancel" value="Cancel">
				<br>
				</td>
			</tr>
		</tbody>
		</table>
	</div>
</div>
<script>
	setModuleId("GIUTS007");
	setDocumentTitle("Copy PAR to a New PAR");
	disableButton($("btnCopyPar"));
	var jsonIssCd = JSON.parse('${jsonIssList}');
	var jsonLineCd = JSON.parse('${jsonLineList}');
	var emptyField = false;
	var issCdCk = false;
	var lineCdCk = false;
	var issCdCkPerUser = false;
	var lineCdCkPerUser = false;
	var switch1  = false;
	
	
	$("copyParToParExit").observe("click", function () {
		checkChangeTagBeforeUWMain();
	});
	
	$("btnCancel").observe("click", function () {
		checkChangeTagBeforeUWMain();
	});
	
	$("btnCopyPar").observe("click", function () {
		setParYy();
		checkEmptyFields();
		if (!emptyField){
			checkParStatus();
		}; 
		emptyField = false;
	});
	
	
	$("searchLineCd").observe("click", function() {
		showGiisLineCdLOVGiuts007('','',"GIUTS007",'${userId}', getLineCdOnOk, onCancelLineCd);
	});
	
	$("txtIssCdIcon").observe("click", function() {
		if($F("issCdSearch") != "" && $F("lineCdSearch") != ""){
			showIssCdNameLOV2($F("lineCdSearch").toUpperCase(), "GIUTS007", function(row) {
					$("issueCd").value = row.issCd;
					$("issueCd").setAttribute("readOnly","readOnly");
			});
		}
	});
	
	$("searchIssCd").observe("click", function() {
		if($F("lineCdSearch") != ""){
			showIssCdNameLOVGiuts007($("lineCd").value, '',"GIUTS007", '${userId}', getIssCdOnOk, onCancelIssCd);
		}
	});
	
	$("searchParNo").observe("click", function() {
    	showParSeqNoLOVList($("lineCd").value, $("issCdSearch").value.toUpperCase(), $("parYrSel").value, getParSeqNoOnOk, onCancel);
    	//showParSeqNoLOVList("AV", "HO", "12");
	});
	
	function checkEmptyFields(){
		if ($("issueCd").value ==  null || $("issueCd").value ==  ""){
			showMessageBox("Issuing code for the new PAR to be created is required.");
			emptyField = true;
		}
	}
	//getLineCdOnOk
	
	function getLineCdOnOk(row){
		if(row != undefined){
			$("lineCdSearch").value =  row.lineCd;
			checkUserPerLine();
		}
		$("lineCdSearch").focus();
};
	
	function getIssCdOnOk(row){
			if(row != undefined){
				$("issCdSearch").value =  row.issCd;
			}
			$("issCdSearch").focus();
	};
	
	function getParSeqNoOnOk(row){
		if(row != undefined){
			$("lineCdSearch").value =  row.lineCd; 						//ADDED BY jeffdojello 04172013
			$("lineCdSearch").focus(); 									//ADDED BY jeffdojello 04172013
			$("issCdSearch").value =  row.issCd; 						//ADDED BY jeffdojello 04172013
			$("issCdSearch").focus(); 								   	//ADDED BY jeffdojello 04172013
			$("parYrSel").value =  lpad(row.parYy.toString(), 2, "0"); 	//ADDED BY jeffdojello 04172013
			$("parYrSel").focus(); 									   	//ADDED BY jeffdojello 04172013
			$("parNoSearch").value =  lpad(row.parSeqNo.toString(), 6, "0");
			$("parNoSearch").focus();
		}
	};	
	
	function onCancel(){
		$("parNoSearch").focus();
	};
	
	function onCancelIssCd(){
		if ($("issCdSearch").value.length > 0){
			checkIssCd($("issCdSearch").value);
			if (!issCdCk){
				showWaitingMessageBox("Invalid value for field ISS_CD.", imgMessage.INFO ,function(){
					$("issCdSearch").focus();
					$("issCdSearch").select();
				});	
			}
		}
	};
	
	function onCancelLineCd(){
		if ($("lineCdSearch").value.length > 0){
			checkLineCd($("lineCdSearch").value);
			if (!lineCdCk){
				showWaitingMessageBox("Invalid value for field LINE_CD.", imgMessage.INFO ,function(){
					$("lineCdSearch").focus();
					$("lineCdSearch").select();
				});	
			}else{
				showWaitingMessageBox("You are not authorized to use this line.", imgMessage.INFO,
						function(){
							showGiisLineCdLOVGiuts007('','',"GIUTS007",'${userId}', getLineCdOnOk, onCancelLineCd);
						}
					);
			}
		}
	};
	
	function lpad(originalstr, length, strToPad) {
	    while (originalstr.length < length)
	        originalstr = strToPad + originalstr;
	    return originalstr;
	};
		
	var input=document.getElementById("parYrSel");
	input.onblur=function(){
		setParYy();
		$("parYrSel").focus();
	};
	
	var inputParNo = document.getElementById("parNoSearch");	
	inputParNo.onblur=function(){
		if ($("parNoSearch").value.length > 0){
			if(isNaN($("parNoSearch").value)||$("parNoSearch").value.length > 6){
				showWaitingMessageBox("Field must be of form 099999.", imgMessage.INFO ,function(){
					$("parNoSearch").select();
					$("parNoSearch").focus();
				});
			}else{	
				$("parNoSearch").value =  lpad($("parNoSearch").value, 6, "0");
				$("parNoSearch").focus();
				if(inputParNo!= null || inputParNo != " " ||$("quoteSeqNoSearch").value == null ){
					$("quoteSeqNoSearch").value = "00";
					$("quoteSeqNo").value = "00";
					enableButton($("btnCopyPar"));
				};
			};
		};
	};
	
	(document.getElementById("parYr")).onblur = function(){
		if(isNaN($("parYr").value)){
			showWaitingMessageBox("Field must be of form 09.", imgMessage.INFO ,function(){
				$("parYr").focus();
				$("parYr").select();
			});
		} 
	};
	
	(document.getElementById("parYrSel")).onblur = function(){
		if(isNaN($("parYrSel").value)){
			showWaitingMessageBox("Field must be of form 09.", imgMessage.INFO ,function(){
				$("parYrSel").focus();
				$("parYrSel").select();
			});
		}else{
			setParYy();
			$("parYrSel").focus();
		} 
	};
	
	(document.getElementById("quoteSeqNoSearch")).onchange = function(){
		if(isNaN($("quoteSeqNoSearch").value||$("quoteSeqNoSearch").value.length > 2)){
			showWaitingMessageBox("Field must be of form 09.", imgMessage.INFO ,function(){
				$("quoteSeqNoSearch").focus();
				$("quoteSeqNoSearch").select();
			});
		}else{ 
			$("quoteSeqNoSearch").value = lpad($("quoteSeqNoSearch").value, 2, "0");
			$("quoteSeqNo").value = $("quoteSeqNoSearch").value;
		}
	};
	
	(document.getElementById("quoteSeqNoSearch")).onblur = function(){
		if(isNaN($("quoteSeqNoSearch").value||$("quoteSeqNoSearch").value.length > 2)){
			showWaitingMessageBox("Field must be of form 09.", imgMessage.INFO ,function(){
				$("quoteSeqNoSearch").focus();
				$("quoteSeqNoSearch").select();
			});
		};
	};
	
	(document.getElementById("quoteSeqNo")).onblur = function(){
		if(isNaN($("quoteSeqNo").value)||$("quoteSeqNo").value.length > 2){
			showWaitingMessageBox("Field must be of form 09.", imgMessage.INFO ,function(){
				$("quoteSeqNo").focus();
				$("quoteSeqNo").select();
			});
		}
	};
	
	(document.getElementById("quoteSeqNo")).onchange = function(){
		if(isNaN($("quoteSeqNo").value)||$("quoteSeqNo").value.length > 2){
			showWaitingMessageBox("Field must be of form 09.", imgMessage.INFO ,function(){
				$("quoteSeqNo").focus();
				$("quoteSeqNo").select();
			});
		}else			
			$("quoteSeqNo").value = lpad($("quoteSeqNo").value, 2, "0");
	};
	
	(document.getElementById("quoteSeqNo")).onfocus = function(){
		if (!((isNaN($("quoteSeqNo").value)||$("quoteSeqNo").value.length > 2)&&
		    (isNaN($("quoteSeqNoSearch").value)||$("quoteSeqNoSearch").value.length > 2))){
			if (($("quoteSeqNo").value) == null){
				setParYy();
			}
		};
	};
	
	(document.getElementById("issueCd")).onblur = function(){
		if ($("issueCd").value.length > 0){
			checkIssCd($("issueCd").value);
			if (!issCdCk){
				showWaitingMessageBox("Issue Code entered is not valid.", imgMessage.INFO ,function(){
					$("issueCd").focus();
					$("issueCd").select();
				});	
			}else{
				checkIssCdPerUser($("issueCd").value.toUpperCase());
				if (issCdCkPerUser){
					$("issueCd").value = $("issueCd").value.toUpperCase();
				}else{
					$("issueCd").focus();
					$("issueCd").select();
				}
			}
		}
	};
	
	(document.getElementById("issCdSearch")).onblur = function(){
		if ($("issCdSearch").value.length > 0){
			$("issueCd").value = ($("issCdSearch").value).toUpperCase();
			var lineCd = $("lineCd").value.toUpperCase();
			switch1 = true;
			checkIssCd($("issCdSearch").value);
			if (!issCdCk){
				showIssCdNameLOVGiuts007(lineCd, '',"GIUTS007", '${userId}', getIssCdOnOk, onCancelIssCd);
			}else{
				checkIssCdPerUser($("issCdSearch").value.toUpperCase());
				if (issCdCkPerUser){
					$("issueCd").value = ($("issCdSearch").value).toUpperCase();
					$("issCdSearch").value = ($("issCdSearch").value).toUpperCase();  //added by jeffdojello 05.07.2014
				}else{
					$("issCdSearch").focus();
					$("issCdSearch").select();
				}
			}
		}
	};
	
	var inputLineCd=document.getElementById("lineCdSearch");
	inputLineCd.onblur=function(){
		if ($("lineCdSearch").value.length > 0){
			checkLineCd($("lineCdSearch").value);
			if (!lineCdCk){
				showGiisLineCdLOVGiuts007('','',"GIUTS007",'${userId}', getLineCdOnOk, onCancelLineCd);
			}else{
				checkUserPerLine();
				$("lineCd").value = ($("lineCdSearch").value).toUpperCase();
			}
		}
	};
	
	function setParYy(){
		var d = new Date();
		var currYear = d.getFullYear();
		var toParYy = currYear.toString().substr(2);
		$("parYr").value = toParYy;
		if ($("parYrSel").value.length > 0){
			$("parYrSel").value = lpad($("parYrSel").value, 2, "0");
		}
	}
	
	function checkIssCd(issCd){
		issCdCk = false;
		for (var x= 0; jsonIssCd.length >= x; x++){
			if (issCd.toUpperCase() == jsonIssCd[x]){
				issCdCk = true;
			}
		} 
	}
	
	function checkLineCd(lineCd){	
		lineCdCk = false;
		for (var x= 0; jsonLineCd.length >= x; x++){
			if (lineCd.toUpperCase() == jsonLineCd[x]){
				lineCdCk = true;
			}
		}
	}
	 
	function checkUserPerLine(){
		new Ajax.Request(contextPath+"/CopyUtilitiesController?action=checkLinePerUser",{
			parameters: {
				lineCd     : $("lineCdSearch").value.toUpperCase(),
				issCd      : $("issueCd").value
			},
			method: "GET",
			evalScripts: true,
			asynchronous: false,
			onComplete: function (response) {
				if(checkErrorOnResponse(response)){
					if (response.responseText != "99"){
						//$("lineCdSearch").value = response.responseText.toUpperCase();
						$("varLineCd").value = response.responseText.toUpperCase();
					}else{
						showWaitingMessageBox("You are not authorized to use this line.", imgMessage.INFO,
							function(){
								showGiisLineCdLOVGiuts007('','',"GIUTS007",'${userId}', getLineCdOnOk, onCancelLineCd);
							}
						);
					}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}					
			}
		});
	}
	
	function checkIssCdPerUser(issCd, switch2){
		new Ajax.Request(contextPath+"/CopyUtilitiesController?action=checkIssCdExistPerUser",{
			parameters: {
				lineCd     : $("lineCdSearch").value.toUpperCase(),
				issCd      : issCd
			},
			method: "GET",
			evalScripts: true,
			asynchronous: false,
			onComplete: function (response) {
				if(checkErrorOnResponse(response)){
					if (response.responseText == "Y"){
						issCdCkPerUser = true;
					}else{
						showWaitingMessageBox("You are not authorized to use this issue source.", imgMessage.INFO,
							function(){
								if (switch1){
									$("issCdSearch").value = "";
									$("issCdSearch").focus();
									$("issCdSearch").select();
								}else{
									$("issCdSearch").value = "";
									$("issueCd").focus();
									$("issueCd").select();
								}
							}
						);
					}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}					
			}
		});
	}
	
	function reloadCopyPar(){
		try {
		    new Ajax.Updater("mainContents", contextPath+"/CopyUtilitiesController?action=showCopyParToNewPar",{
				asynchronous: false,
				evalScripts: true,
				onCreate: showNotice("Loading Page, please wait..."),
				onComplete: function (){
					hideNotice("");
				}
			});
		} catch (e){
			showErrorMessage("showCopyParToNewPar", e);
		}
	}
	
	$("reloadForm").observe("click", reloadCopyPar);
</script>