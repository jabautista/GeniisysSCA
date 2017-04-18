<!--
Remarks: For deletion
Date : 04-16-2012
Developer: Christian Santos
Replacement : /pages/accounting/officialReceipt/otherTrans/unidentifiedCollection.jsp - Tablegrid
--> 
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    response.setHeader("Cache-control", "No-Cache");
    response.setHeader("Pragma", "No-Cache");
%>

<div id="unidentifiedCollnsTableMainDiv" name="unidentifiedCollnsTableMainDiv" style="width: 921px;">
	<div id="unidentifiedCollnsList" style="margin: 10px;" align="center">
		<div style="width: 100%; text-align: center;" id="unidentifiedCollnsTable" name="unidentifiedCollnsTable">
			<div class="tableHeader">
				<label style="width: 60px;font-size: 10px; text-align: center; margin-left: 10px; ">Item No.</label>
				<label style="width: 70px;font-size: 10px; text-align: center; ">Tran Type</label>
				<label style="width: 60px;font-size: 10px; text-align: left; margin-left: 75px;">Fund Code</label>
				<label style="width: 75px;font-size: 10px; text-align: center; margin-left: 10px;">Old Tran No.</label>
				<label style="width: 75px;font-size: 10px; text-align: center; margin-left: 60px;">Old Item No.</label>
				<label style="width: 95px;font-size: 10px; text-align: center; margin-left: 10px;">Account Name</label>
				<label style="width: 70px;font-size: 10px; text-align: center; margin-left: 60px;">Particulars</label>
				<label style="width: 50px;font-size: 10px; text-align: right; margin-left: 110px;">Amount</label>		
			</div>
			
			<div class="tableContainer" id="unidentifiedCollnsTableContainer" name="tableContainer" style="display: block">
				
			</div>
			<div id="unidentifiedCollnsTotalMainDiv" class="tableHeader" style="width: 100%;">
				<div id="unidentifiedCollnsTotalDiv" style="width:100%;">
					<label style="text-align:left; width:15%; margin-left: 605px;">Total Collections:</label>
					<label id="lblCollnsTotal" style="text-align:right; width:14%; margin-left: 30px;" class="money">&nbsp;</label>
				</div>
			</div>
		</div>
	</div>
</div>

<script>
var objOldTranValues = new Object();

	function initializeAllAcctCdFields() {
		$$("input[type='text'].acctCds").each(function (m) {
			m.observe("blur", function() {
				if (isNaN((m.value)) || m.value == "") {
					customShowMessageBox("Field must be of form 09.", imgMessage.ERROR, m.id);
				}else {
					if (validateAcctCodes()){
						m.value = parseInt(m.value).toPaddedString(2);
						m.next().focus();
						
					}else {
						customShowMessageBox("Account code does not exist.", imgMessage.ERROR, m.id);
					}
				}
			});
		});
	}
	
	function initializeAllOldTranNoFields(){
		$$("input[type='text'].refund").each(function (m) {
			m.observe("blur", function() {
				if (isNaN((m.value))) {
					customShowMessageBox("Field must be of form 0-9 - + E.", imgMessage.ERROR, m.id);
				}else {
					if(!validateOldTranNo()){
						if (m.id == "ucTranYear"){
							customShowMessageBox("Invalid transaction year.", imgMessage.ERROR, m.id);
						}else if (m.id == "ucTranMonth"){
							customShowMessageBox("Invalid transaction month.", imgMessage.ERROR, m.id);
						}else {
							customShowMessageBox("Invalid transaction sequence no.", imgMessage.ERROR, m.id);
						}
					}else{
						if (m.id == "ucTranYear"){
							m.value = parseInt(m.value).toPaddedString(4);
							//$("ucTranMonth").focus();
						}else if (m.id == "ucTranMonth"){
							m.value = parseInt(m.value).toPaddedString(2);
							//$("ucTranSeqNo").focus();
						}else{
							m.value = parseInt(m.value).toPaddedString(5);
							//$("ucOldItemNo").focus();
						}
					}
				}
			});
		});
	}

	function validateOldTranNo(){
		var exists = false;
		new Ajax.Request(contextPath + "/GIACUnidentifiedCollnsController?action=validateOldTranNo" , {
			method: "GET",
			parameters: {
				gaccTranId: objACGlobal.gaccTranId,
				tranYear: $F("ucTranYear") == "" ? "" : parseInt($F("ucTranYear")),
				tranMonth: $F("ucTranMonth") == "" ? "" : parseInt($F("ucTranMonth")),
				tranSeqNo:	$F("ucTranSeqNo") == "" ? "" : parseInt($F("ucTranSeqNo")),
				itemNo:	$F("ucOldItemNo") == "" ? "" : parseInt($F("ucOldItemNo"))
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function (response) {
				var result = response.responseText.toQueryParams();
				var jsonAcctCdDtls = JSON.parse(result.acctCdDtls.replace(/\\/g, '\\\\'));
				var jsonOldTranDtls = JSON.parse(result.oldTranDtls.replace(/\\/g, '\\\\'));
				if (jsonAcctCdDtls.length > 0 || jsonOldTranDtls.length > 0) {
					exists = true;
					objOldTranValues = jsonOldTranDtls;
				}
			}
		});
		return exists;
	}

	function validateAcctCodes(){
		var exists = false;
		new Ajax.Request(contextPath + "/GIACUnidentifiedCollnsController?action=validateAcctCode" , {
			method: "GET",
			parameters: {
				glAcctCategory: $F("glAcctCategory") == "" ? $F("glAcctCategory") : parseInt($F("glAcctCategory")),
				glControlAcct: $F("glControlAcct") == "" ? $F("glControlAcct") : parseInt($F("glControlAcct")),
				glSubAcct1: $F("acctCode1") == "" ? $F("acctCode1") : parseInt($F("acctCode1")),
				glSubAcct2: $F("acctCode2") == "" ? $F("acctCode2") : parseInt($F("acctCode2")),
				glSubAcct3: $F("acctCode3") == "" ? $F("acctCode3") : parseInt($F("acctCode3")),
				glSubAcct4: $F("acctCode4") == "" ? $F("acctCode4") : parseInt($F("acctCode4")),
				glSubAcct5: $F("acctCode5") == "" ? $F("acctCode5") : parseInt($F("acctCode5")),
				glSubAcct6: $F("acctCode6") == "" ? $F("acctCode6") : parseInt($F("acctCode6")),
				glSubAcct7: $F("acctCode7") == "" ? $F("acctCode7") : parseInt($F("acctCode7")),
				fundCd: objACGlobal.fundCd
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function (response) {
				var objSlDtls = JSON.parse(response.responseText);
				if (objSlDtls.length > 0){
					exists = true;
					populateSlNameDtls(objSlDtls);
				}else {
					$("ucSlName").length = 0;
				}
			}
		
		});
		return exists;
	}	

	function populateSlNameDtls(obj){
		$("ucSlName").update('<option value="" slCode="" slName=""></option>');
		var options = "";
		for(var i=0; i<obj.length; i++){						
			options+= '<option value="'+obj[i].rvLowValue+'" slCode="'+obj[i].slCd+'" slName="'+obj[i].slName+'">'+obj[i].slName+'</option>';
		}
		$("ucSlName").insert({bottom: options}); 
		$("ucSlName").selectedIndex = 0;
	}

	$("ucOldItemNo").observe("blur", function() {
		$("ucOldItemNo").value = parseInt($F("ucOldItemNo")).toPaddedString(2);
		validateOldTranNo();
		if (objOldTranValues.length > 0){
			populateOldTranNoDtls();
		}
	});

	function populateOldTranNoDtls(){
		for (var i=0; i<objOldTranValues.length; i++){
			$("ucTranYear").value = parseInt(objOldTranValues[i].tranYear).toPaddedString(4);
			$("ucTranMonth").value = parseInt(objOldTranValues[i].tranMonth).toPaddedString(2);
			$("ucTranSeqNo").value = parseInt(objOldTranValues[i].tranSeqNo).toPaddedString(5);
			$("ucAmount").value = formatCurrency(objOldTranValues[i].collectionAmt);
			$("ucParticulars").value = objOldTranValues[i].particulars;
			$("ucOldItemNo").value = parseInt(objOldTranValues[i].itemNo).toPaddedString(2);
			$("glAcctCategory").value = objOldTranValues[i].glAcctCategory;
			$("glControlAcct").value = parseInt(objOldTranValues[i].glCtrlAcct).toPaddedString(2);
			$("acctCode1").value = parseInt(objOldTranValues[i].glSubAcct1).toPaddedString(2);
			$("acctCode2").value = parseInt(objOldTranValues[i].glSubAcct2).toPaddedString(2);
			$("acctCode3").value = parseInt(objOldTranValues[i].glSubAcct3).toPaddedString(2);
			$("acctCode4").value = parseInt(objOldTranValues[i].glSubAcct4).toPaddedString(2);
			$("acctCode5").value = parseInt(objOldTranValues[i].glSubAcct5).toPaddedString(2);
			$("acctCode6").value = parseInt(objOldTranValues[i].glSubAcct6).toPaddedString(2);
			$("acctCode7").value = parseInt(objOldTranValues[i].glSubAcct7).toPaddedString(2);
			$("ucAcctName").value = objOldTranValues[i].glAcctName;
			$("ucHiddenSlTypeCd").value = objOldTranValues[i].gsltSlTypeCd;
			$("ucHiddenGlAcctId").value = objOldTranValues[i].glAcctId;
			$("ucHiddenSlCd").value = objOldTranValues[i].slCd;
			$("ucHiddenGuncTranId").value = objOldTranValues[i].guncTranId;
		}
	}

	//initializeAllAcctCdFields();
	//initializeAllOldTranNoFields();
</script>


