<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<div id="genMainDiv" style="margin-top: 10px; margin-bottom: 10px; margin-left: 5px; margin-right: 5px;">
	<div id="genDetailDiv" class="sectionDiv">
		<table style="margin-left: 20px; margin-top: 10px;">
			<thead>
				<td class="leftAligned" style="width: 60px;">Status : </td>
				<td class="leftAligned">
					<div id="statusDiv">
						<label id="lblStatus" name="lblStatus"></label>
					</div>
				</td>
			</thead>
		</table>
		</br>
		<table style="margin-left: 65px;">
			<tr>
				<td class="rightAligned">Tran Date&nbsp;</td>
				<td class="leftAligned" colspan="2">
					<div style="float: left; width: 178px;" class="withIconDiv">
						<input type="text" id="txtGenTranDate" name="txtGenTranDate" class="withIcon" readonly="readonly" style="width: 155px;" tabindex="101"/>
						<img id="hrefGenTranDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Tran Date" tabindex="102"/>
					</div>
				</td>
			</tr>
			<tr></tr>
			<tr>
				<td class="rightAligned">Period&nbsp;</td>
				<td class="leftAligned">
					<select id="selOptGenMm" name="selOptGenMm" disabled="disabled" style="width: 110px; height: 23px;" tabindex="103">
						<option></option>
						<option value="1">January</option>
						<option value="2">February</option>
						<option value="3">March</option>
						<option value="4">April</option>
						<option value="5">May</option>
						<option value="6">June</option>
						<option value="7">July</option>
						<option value="8">August</option>
						<option value="9">September</option>
						<option value="10">October</option>
						<option value="11">November</option>
						<option value="12">December</option>
					</select>
				</td>
				<td class="leftAligned">
					<input type="text" id="txtGenYear" name="txtGenYear" readonly="readonly" disabled="disabled" style="width: 58px;" tabindex="104"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">User&nbsp;</td>
				<td class="leftAligned" colspan="2">
					<input type="text" id="txtGenUser" name="txtGenUser" readonly="readonly" disabled="disabled" style="width: 172px;" tabindex="105"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Date&nbsp;</td>
				<td class="leftAligned" colspan="2">
					<input type="text" id="txtGenDate" name="txtGenDate" readonly="readonly" disabled="disabled" style="width: 172px;" tabindex="106"/>
				</td>
			</tr>
		</table>
		<div id="viewButtonsDiv">
			<table align="center" style="margin-bottom: 10px; margin-top: 10px;">
				<tr>
					<td><input type="button" class="button" id="btnGenerate" name="btnGenerate" value="Generate" style="width: 150px;" tabindex="201"/></td>
					<td><input type="button" class="button" id="btnGenReturn" name="btnGenReturn" value="Return" style="width: 150px;" tabindex="202"/></td>
				</tr>
			</table>
		</div>
	</div>
</div>

<script type="text/JavaScript">
try {
	
	function initializeGeneration() {
		$("txtGenTranDate").focus();
		$("txtGenTranDate").value = dateFormat(new Date(),'mm-dd-yyyy');
		$("selOptGenMm").value = objGiacs044.mM;
		$("txtGenYear").value = objGiacs044.year;
		$("txtGenUser").value = "${PARAMETERS['USER'].userId}";
		$("txtGenDate").value = dateFormat(new Date(),'mm-dd-yyyy');
		$("lblStatus").innerHTML = "No Process In Progress";
	}
	
	function generateAccountingEntriesFinal() {		//UPDATE genTag on giac_deferred_extract
		new Ajax.Request(contextPath+"/GIACDeferredController", {
			parameters: {
				action: "setGenTag",
				year: objGiacs044.year,
				mM: objGiacs044.mM,
				procedureId: objGiacs044.procedureId
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					$("lblStatus").innerHTML = response.responseText;
				}else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	function generateAcctEntriesCommExp() {		//generate accounting entries for COMMISSION EXPENSE
		new Ajax.Request(contextPath+"/GIACDeferredController", {
			parameters: {
				action: "generateAcctEntries",
				year: objGiacs044.year,
				mM: objGiacs044.mM,
				tranDate: $F("txtGenTranDate"),
				procedureId: objGiacs044.procedureId,
				moduleId: 'GIACS044',
				table: 'gdCommExp'
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					$("lblStatus").innerHTML = response.responseText;
					generateAccountingEntriesFinal();
				}else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	function generateAcctEntriesCommInc() {	 //generate accounting entries for COMMISSION INCOME
		new Ajax.Request(contextPath+"/GIACDeferredController", {
			parameters: {
				action: "generateAcctEntries",
				year: objGiacs044.year,
				mM: objGiacs044.mM,
				tranDate: $F("txtGenTranDate"),
				procedureId: objGiacs044.procedureId,
				moduleId: 'GIACS044',
				table: 'gdCommInc'
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					$("lblStatus").innerHTML = response.responseText;
					generateAcctEntriesCommExp();
				}else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}

	function generateAcctEntriesRiPrem() {	//generate accounting entries for RIPREM
		new Ajax.Request(contextPath+"/GIACDeferredController", {
			parameters: {
				action: "generateAcctEntries",
				year: objGiacs044.year,
				mM: objGiacs044.mM,
				tranDate: $F("txtGenTranDate"),
				procedureId: objGiacs044.procedureId,
				moduleId: 'GIACS044',
				table: 'gdRiPrem'
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					$("lblStatus").innerHTML = response.responseText;
					generateAcctEntriesCommInc();
				}else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	function generateAcctEntriesGross() {	//generate accounting entries for GROSS
		new Ajax.Request(contextPath+"/GIACDeferredController", {
			parameters: {
				action: "generateAcctEntries",
				year: objGiacs044.year,
				mM: objGiacs044.mM,
				tranDate: $F("txtGenTranDate"),
				procedureId: objGiacs044.procedureId,
				moduleId: 'GIACS044',
				table: 'gdGross'
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					$("lblStatus").innerHTML = response.responseText;
					generateAcctEntriesRiPrem();
				}else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	function reversePostedTrans() {		//generate accounting entries for posted 24th method transactions
		new Ajax.Request(contextPath+"/GIACDeferredController", {
			parameters: {
				action: "generateAcctEntries",
				year: objGiacs044.year,
				mM: objGiacs044.mM,
				tranDate: $F("txtGenTranDate"),
				procedureId: objGiacs044.procedureId,
				moduleId: 'GIACS044',
				table: 'reversal'
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					$("lblStatus").innerHTML = response.responseText;
					generateAcctEntriesGross();
				}else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	function checkTranFlag() {	//check tran flag of 24th method transactions
		new Ajax.Request(contextPath+"/GIACDeferredController", {
			parameters: {
				action: "checkStatus",
				year: objGiacs044.year,
				mM: objGiacs044.mM
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					$("lblStatus").innerHTML = 'Please wait... Initializing process...';
					if (response.responseText == 'P') {
						reversePostedTrans();
					}else {
						generateAcctEntriesGross();
					}
	
				}
			}
		});
	}

	$("hrefGenTranDate").observe("click", function() {
		if ($("hrefGenTranDate").disabled == true) return;
		scwShow($('txtGenTranDate'),this, null);
	});
	
	$("btnGenerate").observe("click", function() {
		checkTranFlag();
	});
	
	$("btnGenReturn").observe("click", function() {
		overlayGenerate.close();
	});	
	
	initializeGeneration();
	
} catch (e) {
	showErrorMessage("Error in Generation of Accounting Entries: ", e);
}


		
</script>