<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="genTranMthMainDiv">
	<div id="fieldsDiv" class="sectionDiv" style="width: 328px; height: 50px; margin-bottom: 15px;">
		<input id="hidFundCd" type="hidden" value="${gfundFundCd}">
		<input id="hidBranchCd" type="hidden" value="${branchCd}">
		<label id="lblTranYr" style="padding: 15px 0 0 40px;">Enter Tran Year:</label>
		<input id="txtTranYr" name="txtTranYr" type="text" value="${nextTranYr}" maxlength="4" class="integerNoNegativeUnformattedNoComma rightAligned" style="width: 80px; float: left; margin: 10px 0 0 25px;" >
	</div>
	<div align="center" style="margin-top: 10px;">
		<input id="btnReturn" name="btnReturn" type="button" class="button" value="Return" style="width: 80px;">
		<input id="btnGenerate" name="btnGenerate" type="button" class="button" value="Generate" style="width: 80px;">
	</div>
</div>

<script type="text/javascript">
	initializeAll();
	var haveGenerate = false;
	
	$("txtTranYr").observe("blur", function(){
		if ($F("txtTranYr") != ""){
			checkTranYr();
		}
	});
	
	$("btnReturn").observe("click", function(){
		genTranMmOverlay.close();
		if (haveGenerate){
			tbgTranMm.url = contextPath+"/GIACTranMmController?action=showGiacs038&refresh=1&gfunFundCd="
							+$F("txtGfunFundCd")+"&branchCd="+$F("txtBranchCd");
			tbgTranMm._refreshList();
		}
	});
	
	$("btnGenerate").observe("click", function(){
		if ($F("txtTranYr") == ""){
			showWaitingMessageBox("Please input Tran Year.", "I", function(){
				$("txtTranYr").focus();
			});
		}else{
			generateTranMm();
		}
	});
	
	function checkTranYr(){
		try{
			new Ajax.Request(contextPath+"/GIACTranMmController",{
				parameters: {
					action:	"checkTranYrGiacs038",
					gfunFundCd:	$F("hidFundCd"),
					branchCd:	$F("hidBranchCd"),
					tranYr: $F("txtTranYr")
				},
				asynchronous: true,
				evalScripts: true,
				onComplete: function(response){					
					if (checkErrorOnResponse(response)){
						var json = JSON.parse(response.responseText);						
						if (json.tranYrExist == "Y"){
							showWaitingMessageBox("This Tran Year already exists." , "E", function(){
								$("txtTranYr").value = json.nextTranYr;
							});
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("checkTranYr", e);
		}
	}
	
	function generateTranMm(){
		try{
			new Ajax.Request(contextPath+"/GIACTranMmController",{
				method: "GET",
				parameters: {
					action:		 "generateTranMmGiacs038",
					gfunFundCd:	$F("hidFundCd"),
					branchCd:	$F("hidBranchCd"),
					tranYr: 	$F("txtTranYr")
				},
				asynchronous: true,
				evalScripts: true,
				onComplete: function(response){
					if(response.responseText = "Success"){
						//$("txtTranYr").value = parseInt($F("txtTranYr")) + 1;	// moved inside message box function
						haveGenerate = true;
						showWaitingMessageBox("Tran months for the year " +$F("txtTranYr")+ " have been generated successfully.", "I", function(){
							$("txtTranYr").value = parseInt($F("txtTranYr")) + 1;
							fireEvent($("btnReturn"), "click");
						});
					}
				}
			});
		}catch(e){
			showErrorMessage("generateTranMm", e);
		}
	}
	
	$("txtTranYr").focus();
</script>