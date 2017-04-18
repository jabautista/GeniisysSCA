<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="contentsDiv">
	<div align="left">
		<table>
			<tr>
				<td class="rightAligned">Name Keyword</td>
				<td class="leftAligned"><input name="keyword" id="keyword" style="margin-bottom: 0; width: 200px;" type="text" value=" " /></td>
				<td><input id="btnSearchAdviceNo" class="button" type="button" style="width: 60px;" value="Search" /></td>
			</tr>
		</table>
	</div>
	
	<div style="height: 365px; background-color: #ffffff; overflow: auto;" id="searchResult" align="center">
	
	</div>
	
	<div id="divB" align="right" style="margin: 5px; margin-right: 0;">
		<input type="button" id="btnSelectAdviceOk" 	class="button" value="Ok" style="width: 60px;" />
		<input type="button" id="btnSelectAdviceCancel" class="button" value="Cancel" style="width: 60px;" />
	</div>
	<input id="selectedAdvice" name="selectedAdvice" value="" type="hidden"/>
</div>
<script type="text/javascript">
	searchAdviceNumberModal(1,$("keyword").value);

	$("btnSearchAdviceNo").observe("click", function(){
		searchAdviceNumberModal($("adviceNumberPage").value,$("keyword").value);	
	});

	$("btnSelectAdviceCancel").observe("click", function(){
		Modalbox.hide();
	});

	$("btnSelectAdviceOk").observe("click", function(){
		var hasSelected = false;

		if(!$F("selectedAdvice").blank()){
			var selectedRowId = $F("selectedAdvice"); 
			var selectedRow = $(selectedRowId);

			var theClaimId;// 	= selectedRow.down("input",0).value;
			var theAdviceId;// = selectedRow.down("input",1).value;
			var theLineCd;// 	= selectedRow.down("input",2).value;
			var theAdviceNo;// = selectedRow.down("input",3).value;
			
			selectedRow.childElements().each(function(elem){
				if(elem.id == "claimId"){
					theClaimId 	= elem.value; //selectedRow.down("input",0).value;
				}else if(elem.id == "adviceId"){
					theAdviceId = elem.value; //selectedRow.down("input",1).value;
				}else if(elem.id == "lineCd"){
					theLineCd	= elem.value; //selectedRow.down("input",2).value;
				}else if(elem.id == "adviceNo"){
					theAdviceNo = elem.value; //selectedRow.down("input",3).value;
				}else if(elem.id == "currencyCode"){
					$("dcpCurrencyCode").value	= elem.value; //;		
				}else if(elem.id == "convertRate"){
					$("dcpConvertRate").value = elem.value;	
				}else if(elem.id == "cpiBranchCd"){
					
				}else if(elem.id == "cpiRecNo"){
					//$("dcpForeignCurrencyAmt").value = elem.value;
				}else if(elem.id == "foreignCurrencyAmt"){
					$("dcpForeignCurrencyAmt").value = elem.value;
				}else if(elem.id == "currencyDescription"){
					$("dcpCurrencyDesc").value = elem.value;
				}
			});

			$("claimIdAC017").value = theClaimId;
			$("adviceIdAC017").value = theAdviceId;
			
			new Ajax.Updater("payeeClassDiv", "GIACDirectClaimPaymentController?action=filterPayeeClass", {
				method:			"GET",
				parameters:	{
					transType:		$F("selTransactionType"),
					lineCd:			theLineCd,
					adviceId:		theAdviceId,
					claimId:		theClaimId
				},
				evalScripts:	true,
				asynchronous:	true,
				onComplete: function(){
					$("txtClaimNumber").value 	= $F("tempClaimNo");
					$("txtPolicyNumber").value	= $F("tempPolicyNo");
					$("txtAssuredName").value 	= $F("tempAssured");
					$("selPayeeClass").enable();
					$("txtAdviceSequence").value = theAdviceNo;

					var segments = theAdviceNo.split("-");
					
					$("lineCdAC017").value		= segments[0];
					$("issCdAC017").value		= segments[1];
					$("yearAC017").value		= segments[2];
					$("sequenceAC017").value	= segments[3];

				  	Modalbox.hide();
				}
			});
		}
	});

	//when press ENTER on keyword field
	$("keyword").observe("keypress",function(event){
		if (event.keyCode == 13){
			searchAdviceNumberModal(1,$("keyword").value);
		}
	});

	$$("div[name='adviceSequenceRow']").each(function(adviceSequenceRow){
		//adviceSequenceRow
	});

	/**
	* Check
	*/
	function checkSelectedAdvice(){
		
	}
	
</script>