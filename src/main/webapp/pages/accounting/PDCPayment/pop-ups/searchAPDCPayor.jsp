<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="contentsDiv">
	<div align="left">
		<table>
			<tr>
				<td class="rightAligned">Name Keyword </td>
				<td class="leftAligned"><input name="keyword" id="keyword" style="margin-bottom: 0; width: 200px;" type="text" onkeypress="onEnterEvent(event, searchAPDCPayor);" /></td>
				<td><input id="searchPayor" name="searchPayor" class="button" type="button" style="width: 60px;" value="Search" /></td>
			</tr>
		</table>
		
		<div style="padding: 10px; height: 350px; background-color: #ffffff; overflow: auto;" id="searchResult" align="center">
		</div>
		
		<div id="divB" align="right" style="margin: 10px; margin-right: 0;">
			<input type="button" id="btnAPDCPayorOk" class="button" value="Ok" style="width: 60px;" />
			<input type="button" id="btnAPDCPayorCancel" class="button" value="Cancel" style="width: 60px;" onclick="Modalbox.hide();" />
		</div>
	</div>
</div>
<script type="text/javascript">
	objACGlobal.fundCd 			= $F("globalFundCd");
	objACGlobal.branchCd 		= $F("globalBranchCd");
	searchAPDCPayor("", "");

	$("searchPayor").observe("click", function (){
		searchAPDCPayor(1, $F("keyword"));
	});

	$("keyword").focus();

	$("btnAPDCPayorOk").observe("click", function (){
		getAPDCPayorDetails();
	});

	$("btnAPDCPayorCancel").observe("click", function (){
		showAcknowledgementReceipt();
	});

	function getAPDCPayorDetails(){
		var selectedRow = null;
		$$("div[name='row']").each(function (row){
			if (row.hasClassName("selectedRow")){
				selectedRow = row;
			}
		});

		if (selectedRow == null){
			showMessageBox("Please select a payor first.", imgMessage.ERROR);
			return false;
		} else {
			clearDetails();
			
			var apdcNo2 = selectedRow.down("input", 1).value == "" ? " " : selectedRow.down("input", 1).value;
			$("apdcNo1").value = selectedRow.down("input", 0).value == " " ? "" : selectedRow.down("input", 0).value;
			$("apdcNoText").value = apdcNo2 == " " ? "" : parseInt(apdcNo2).toPaddedString(10);
			$("refApdcNo").value = selectedRow.down("input", 2).value == " " ? "" : selectedRow.down("input", 2).value;
			$("apdcDate").value = selectedRow.down("label", 1).innerHTML == " " ? "" : selectedRow.down("label", 1).innerHTML;
			$("statusCd").value = selectedRow.down("label", 3).innerHTML == " " ? "" : selectedRow.down("label", 3).innerHTML;
			$("status").value = selectedRow.down("input", 3).value == " " ? "" : selectedRow.down("input", 3).value;
			$("hdrDtlsPayor").value = selectedRow.down("label", 2).innerHTML == " " ? "" : selectedRow.down("label", 2).innerHTML;
			$("payorParticulars").value = selectedRow.down("input", 4).value == " " ? "" : selectedRow.down("input", 4).value;
			$("payorParticulars").setAttribute("readonly", "readonly");
			$("cashierCd").value = selectedRow.down("input", 6).value == " " ? "" : selectedRow.down("input", 6).value;

			if ($F("statusCd") == 'C'){
				disableInputs();
				disableButton("btnPrintApdc");
				enableButton("btnCancelApdc");
				enableButton("btnDeleteApdc");
			} else {
				enableButton("btnPrintApdc");
				enableButton("btnCancelApdc");
				enableButton("btnDeleteApdc");
			}

			Modalbox.hide();

			$("selectedApdcId").value = selectedRow.down("input", 5).value;
			$("selectedPDCIndex").value = "";
			fillPostDatedCheckDetails($F("selectedApdcId"));
		}
	}

	function clearDetails(){
		$$("div#miscAmtsDtlsDiv input[type='text']").each(function (text){
			$(text).value = "";
		});

		$$("div#foreignCurrDtlsDiv input[type='text']").each(function (text2){
			$(text2).value = "";
		});

		$$("div#particularsDtlsDiv input[type='text']").each(function (text3){
			$(text3).value = "";
		});

		$$("div#detailsContentsDiv input[type='text']").each(function (text4){
			$(text4).value = "";
		});
	}

	function disableInputs(){
		$$("div#acknowledgementReceiptMainDiv input[type='text']").each(function (input){
			input.setAttribute("readonly", "readonly");
		});
	}
</script>