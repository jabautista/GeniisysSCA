<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
   		<label>Mortgagee Information </label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name='gro'>Show</label>
   		</span>
   	</div>
</div>
<div class="sectionDiv" id="mortgageeInformationSectionDiv" name="mortgageeInformationSectionDiv" style="">
	<div id="spinLoadingDiv"></div>
	<div id="contentsDiv">
		<form id="mortgageeForm" name="mortgageeForm">
			<input id="quoteIdmort" 	name="quoteId" 		type="hidden" 	value="${quoteId}" />
			<input id="mortgItemNo" 	name="mortgItemNo" 	type="hidden" 	value="${mortgItemNo}" />
			<div class="sectionDiv" id="mortgInfoDiv">
				<div class="tableContainer" id="mortgageeInformationDiv" name="mortgageeInformationDiv" align="center" style="margin: 10px;">
					<span id="noticePopup" name="noticePopup" style="display: none;" class="notice">Saving, please wait...</span>
					<div class="tableHeader">
						<label style="width: 50%; padding-left: 20px;">Mortgagee Name</label>
						<label style="width: 20%; text-align: right;">Amount</label>
						<label style="width: 20%; text-align: center;">Item No.</label>
					</div>
					<div id="mortgageeListingDiv" name="mortgageeListingDiv" class="tableContainer">
						<c:forEach var="mortgagee" items="${mortgagees}">
								<div id="row${mortgagee.itemNo}${mortgagee.mortgCd}" name="rowMortg" class="tableRow">
									<input type="hidden" name="mortgCds" 		value="${mortgagee.mortgCd}" />
									<input type="hidden" name="amounts" 		value="${mortgagee.amount}" />
									<input type="hidden" name="mortgageeItemNos" 		value="${mortgagee.itemNo}">
									<label style="width: 50%; padding-left: 20px;">${mortgagee.mortgName}</label>
									<label style="width: 20%; text-align: right;" <c:if test="${not empty mortgagee.amount}">class="money"</c:if> name="lblMoney"><c:if test="${empty mortgagee.amount}">--</c:if>${mortgagee.amount}</label>
									<label style="width: 20%; text-align: center;">${mortgagee.itemNo}</label>
								</div>
						</c:forEach>
					</div>	
			
					<table align="center" id="addMortgageeForm" style="margin-top:10px; margin-bottom:10px;" >
						<tr>
							<td class="rightAligned">Mortgagee Name </td>
							<td style="padding-left: 10px;">
								
								<select id="mortgageeName" name="mortgageeName" style="width: 280px;" class="required">
									<option value=""></option>
									<c:forEach var="mortgageeListing" items="${mortgageeListing}">
										<option value="${mortgageeListing.mortgCd}">${mortgageeListing.mortgName}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						
						<tr>
							<td class="rightAligned">Amount </td>
							<td style="padding-left: 10px;" align="left">
							<input id="amount" name="amount" type="text" class="money required" maxlength="17" value="" style="width: 272px;"/></td>
						</tr>
						<tr>
							<td class="rightAligned">Item No. </td>
							<td style="padding-left: 10px;" align="left">
								<input id="newMortgageeItemNo" name="newMortgageeItemNo" type="text" value="0" readonly="readonly" />						
							</td>
						</tr>
						<tr>
							<td></td>
							<td style="padding-left: 10px; text-align: left;">
								<input id="btnAddMortgagee" name="btnAddMortgagee" class="button" type="button" value="Add" style="width: 68px;" />
								<input id="btnDeleteMortgagee" name="btnDeleteMortgagee" class="disabledButton" type="button" value="Delete" style="width: 68px;" /></td>								
						</tr>
					</table>
				</div>
			</div>
		</form>
	</div>
</div>
<!--<input type="hidden" id="saveMortTag${gipiQuote.quoteId}" name="saveMortTag" value="N"/>-->

<script type="text/javascript">

	initializeAllMoneyFields();

	$$("div[name='rowMortg']").each(
			function (row)	{
							
				row.observe("mouseover", function ()	{
					row.addClassName("lightblue");
				});
				
				row.observe("mouseout", function ()	{
					row.removeClassName("lightblue");
				});
			
				row.observe("click", function ()	{
					row.toggleClassName("selectedRow");
					if(row.hasClassName("selectedRow")){
						$$("div[name='rowMortg']").each(function (r)	{
							if (row.getAttribute("id") != r.getAttribute("id"))	{
								r.removeClassName("selectedRow");
							}
						});

						var mn = $("mortgageeName");
						var ctr = 0;
						var mcd;
						var amt;
						var itm;
						
						row.childElements().each(function(child){
							if(ctr==0){	mcd = child.value;	}
							if(ctr==1){	amt = child.value;	}
							if(ctr==2){	itm = child.value;	}
							ctr++;	
						});
						
						var index = 0;
						for (var i=0; i<mn.length; i++)	{
							if ( (mn.options[i].value) == mcd/*(row.down("input", 0).value)*/)	{
								index = i;
							}
						}
						$("mortgageeName").selectedIndex = index;
						$("amount").value = formatCurrency(amt/*row.down("input", 1).value*/);
						$("newMortgageeItemNo").value = itm/*row.down("input", 2).value*/;
						
						/*
						$("btnDeleteMortgagee").enable();
						$("btnDeleteMortgagee").removeClassName("disabledButton");
						$("btnDeleteMortgagee").addClassName("button");
						*/
						
						enableButton("btnDeleteMortgagee");
						$("btnAddMortgagee").value = "Update";
					} else{
						resetMortgageeForm();
					}
				});
			}
		);
		/* removed null validation for deductible - irwin
		$("amount").observe("blur", function(){
			validateCurrency("amount", "Invalid Amount. Value should be from 0.01 to 99,999,999,999,999.99", "popup", 0.01, 99999999999999.99);
		});*/
	
	$("btnAddMortgagee").observe("click", function ()	{
		try{
			var mortgCd = $F("mortgageeName");
			var mortgName = $("mortgageeName").options[$("mortgageeName").selectedIndex].text;
			var amount = $F("amount").replace(/,/g, "");
			var itemNo = 0;
			var exists = false;
			var willProceed = true;
			//$("saveMortTag$--{ gipiQuote.quoteId}").value= "Y";
			
			$$("div[name='rowMortg']").each(function (d)	{
				if("row"+itemNo+mortgCd == d.getAttribute("id") && $F("btnAddMortgagee") != "Update")	{
					showMessageBox("Mortgagee already exists!", imgMessage.ERROR);
					exists = true;
					willProceed = false;
					return false;
				}
			});
	
			if (mortgCd == "")	{
				showMessageBox("Mortgagee Name is required.", imgMessage.ERROR);
				willProceed = false;
				return false;
			}//dependent

			 //removed null validation for deductible - irwin
	        if(isNaN(amount)){
				showMessageBox("Invalid Amount. Value should be from 0.01 to 99,999,999,999,999.99.", imgMessage.ERROR);
				willProceed = false;
				return false;
			}
			
			if(willProceed){
				$("noticePopup").hide();
				hideNotice();
				var finalAmount;
				if(amount == null || amount == ''){
					finalAmount = '--';
				}else{
					finalAmount = formatCurrency(amount);
				}
				var mid = $("mortgageeListingDiv");
				if ($F("btnAddMortgagee") == "Update")	{
					var selectedRow = getSelectedRowId_noSubstring("rowMortg");
					$(selectedRow).update('<input type="hidden" name="mortgCds" value="'+mortgCd+'" />'+
							'<input type="hidden" name="amounts" 		value="'+amount+'" />'+
							'<input type="hidden" name="mortgageeItemNos" 		value="'+itemNo+'">'+
							'<label style="width: 50%; padding-left: 20px;">'+mortgName+'</label>'+
							'<label style="width: 20%; text-align: right;" class="money" name="lblMoney">'+finalAmount+'</label>'+
							'<label style="width: 20%; text-align: center;">'+itemNo+'</label>');
	//				unhideDeletedMortgagees(selectedRow);
				}else {
					if (!exists)
						var newDiv = new Element("div");		
						newDiv.setAttribute("id", "row"+itemNo+mortgCd);
						newDiv.setAttribute("name", "rowMortg");
						newDiv.addClassName("tableRow");
						newDiv.setStyle("display: none;");
						newDiv.update('<input type="hidden" name="mortgCds" value="'+mortgCd+'" />'+
								'<input type="hidden" name="amounts" 		value="'+amount+'" />'+
								'<input type="hidden" name="mortgageeItemNos" 		value="'+itemNo+'">'+
								'<label style="width: 50%; padding-left: 20px;">'+mortgName+'</label>'+
								'<label style="width: 20%; text-align: right;" class="money" name="lblMoney">'+finalAmount+'</label>'+
								'<label style="width: 20%; text-align: center;">'+itemNo+'</label>');
						mid.insert({bottom: newDiv});

						newDiv.observe("mouseover", function ()	{
							newDiv.addClassName("lightblue");
						});
						
						newDiv.observe("mouseout", function ()	{
							newDiv.removeClassName("lightblue");
						});
				
						newDiv.observe("click", function ()	{
							newDiv.toggleClassName("selectedRow");
							if (newDiv.hasClassName("selectedRow"))	{
								$$("div[name='rowMortg']").each(function (r)	{
									if (newDiv.getAttribute("id") != r.getAttribute("id"))	{
										r.removeClassName("selectedRow");
									}
								});
								
								var mn = $("mortgageeName");
								var index = 0;
								for (var i=0; i<mn.length; i++)	{
									if ((mn.options[i].value)==(newDiv.down("input", 0).value))	{
										index = i;
									}
								}
								$("mortgageeName").selectedIndex = index;
								$("amount").value = formatCurrency(newDiv.down("input", 1).value);
								$("newMortgageeItemNo").value = newDiv.down("input", 2).value;
								
								/*$("btnDeleteMortgagee").enable();
								$("btnDeleteMortgagee").removeClassName("disabledButton");
								$("btnDeleteMortgagee").addClassName("button");*/
								enableButton("btnDeleteMortgagee");
								$("btnAddMortgagee").value = "Update";
							}	else	{
								resetMortgageeForm();
							}
						});
						
						Effect.Appear(newDiv, {
							duration: .2,
							afterFinish: function ()	{
								resetMortgageeForm();
								checkTableIfEmpty("rowMortg", "mortgageeInformationDiv");
								checkIfToResizeTable("mortgageeListingDiv", "rowMortg");
							}
						});	
				}	
				changeTag = 1; // added for change tag validation
			}
			
			resetMortgageeForm();
			hideSelectedMortgagees();
			//$("saveMortTag$* *{ *gipiQuote.quoteId}").value= "Y";
		}catch(e){
			showErrorMessage("mortgageeInformation2.jsp", e);
		}
	});		

	function resetMortgageeForm(){
		$("mortgageeName").selectedIndex = 0;
		$("amount").value = ""; //formatCurrency(""); --irwin
		//$("newMortgageeItemNo").value = "${mediaItemNo}";//$F("itemNoTemp");
		disableButton("btnDeleteMortgagee");
		/*$("btnDeleteMortgagee").disable();
		$("btnDeleteMortgagee").addClassName("disabledButton");
		$("btnDeleteMortgagee").removeClassName("button");*/
		$("btnAddMortgagee").value = "Add";
		$("noticePopup").hide();
	}
	// hides already added mortgagee
	function hideSelectedMortgagees(){
		var mortgageeOptions = $("mortgageeName").options;				
		$$("div[name='rowMortg']").pluck("id").findAll(function (a) {
			for (var i=0; i<mortgageeOptions.length; i++) {
				if (a.substring(4) == mortgageeOptions[i].value) {   
					mortgageeOptions[i].hide();
				}
			}
		});
	}

	function unhideDeletedMortgagees(row){
		var indexToBeShown = row.id.substring(4);
		row.childElements().findAll(function(a){
			var mortgageeOptions = $("mortgageeName").options;
			for(var i = 0; i < mortgageeOptions.length; i++){
				if(mortgageeOptions[i].value == indexToBeShown){
					mortgageeOptions[i].show();
				}
			}
		});
	}

	$("btnDeleteMortgagee").observe("click", function ()	{
		$$("div[name='rowMortg']").each(function (d)	{
			if (d.hasClassName("selectedRow"))	{
				Effect.Fade(d, {
					duration: .5,
					afterFinish: function () {  
						unhideDeletedMortgagees(d);
						d.remove();
						resetMortgageeForm();
						checkIfToResizeTable("mortgageeListingDiv", "rowMortg");
						changeTag = 1; //Added by Jerome 09.06.2016 SR 5643
						//checkTableIfEmptyinModalbox("rowMortg", "mortgageeInformationDiv");
					}	
				});
				//$("saveMortTag $-{gipiQuote.quoteId}").value = "Y";
			}
		});
	});

	hideSelectedMortgagees();
	//checkTableIfEmpty("rowMortg", "mortgageeInformationDiv");
	checkIfToResizeTable("mortgageeListingDiv", "rowMortg");
	resetMortgageeForm();
	initializeAll();
	initializeAccordion();
	//initializeAllMoneyFields();
	</script>