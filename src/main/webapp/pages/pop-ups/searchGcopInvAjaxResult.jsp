<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
    <%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<input type="hidden" id="selectedRow" value="" readonly="readonly" />
<div id="modalGcopDivTableContainer" class="tableContainer" style="font-size: 12px;  width: 1100px; overflow: auto">
	<div class="tableHeader" style="overflow: auto">
		<label style="width: 150px; margin-left: 20px;">Bill No.</label>
		<label style="width: 80px; text-align: right">Intm No.</label>
		<label style="width: 230px; margin-left: 15px;">Intm Name</label>
		<label style="width: 135px; text-align: right">Commission Amt</label>
		<label style="width: 135px; text-align: right">Input VAT</label>
		<label style="width: 135px; text-align: right">Withholding Tax</label>
		<label style="width: 135px; text-align: right">Net Comm Amt</label>
	</div>
	<div style="overflow: auto">
		<c:forEach var="inv" items="${searchResult}" varStatus="ctr">
			<div id="modalRow${ctr.index}" name="modalRow" class="tableRow" style="padding: 3px 5px; padding-top: 5px;">
				<label style="width: 150px; margin-left: 10px;" id="modalLblBillNo${ctr.index}" name="modalBillNo" title="${inv.billNo}">
				<input type="checkbox" id="chkTag${ctr.index }" name="chkTag" value="N" ></input>
				${inv.billNo }</label>
				<label style="width: 80px; text-align: right" id="modalLblIntmNo${ctr.index }">${inv.intmNo }</label>
				<label style="width: 230px; margin-left: 15px;" id="modalLblIntmName${ctr.index }" name="modalLblIntmName">${inv.intmName }</label>
				<label style="width: 135px; text-align: right" id="modalLblCommAmt${ctr.index }">${inv.commAmt }</label>
				<label style="width: 135px; text-align: right" id="modalLblInputVAT${ctr.index }">${inv.invatAmt }</label>
				<label style="width: 135px; text-align: right" id="modalLblWtaxAmt${ctr.index }">${inv.wtax }</label>
				<label style="width: 135px; text-align: right" id="modalLblDrvCommAmt${ctr.index }">${inv.ncommAmt }</label>
				<input type="hidden" id="modalRowIssCd${ctr.index }" name="modalRowBillNo" value="${inv.issCd }"/>
				<input type="hidden" id="modalRowPremSeqNo${ctr.index }" name="modalRowPremSeqNo" value="${inv.premSeqNo }"/>
				<input type="hidden" id="modalRowIntmNo${ctr.index }" name="modalRowIntmNo" value="${inv.intmNo }"/>
				<input type="hidden" id="modalRowIntmName${ctr.index }" name="modalRowIntmName" value="${inv.intmName }"/>
				<input type="hidden" id="modalRowCommAmt${ctr.index }" name="modalRowCommAmt" value="${inv.commAmt }"/>
				<input type="hidden" id="modalRowInvatAmt${ctr.index }" name="modalRowInvatAmt" value="${inv.invatAmt }"/>
				<input type="hidden" id="modalRowWtax${ctr.index }" name="modalRowWtax" value="${inv.wtax }"/>
				<input type="hidden" id="modalRowNcommAmt${ctr.index }" name="modalRowNcommAmt" value="${inv.ncommAmt }"/>
				<input type="hidden" id="modalRowBillGaccTranId${ctr.index }" name="modalRowBillGaccTranId" value="${inv.billGaccTranId }"/> <!-- shan 10.02.2014 -->			
			</div>
		</c:forEach>
	</div>
</div>
<div class="pager" id="pager" style="overflow: auto">
	<c:if test="${noOfPages>1}">
		<div align="right">
		Page:
			<select id="gcopInvPage" name="gcopInvPage">
				<c:forEach var="i" begin="1" end="${noOfPages}" varStatus="status">
					<option value="${i}"
						<c:if test="${pageNo==i}">
							selected="selected"
						</c:if>
					>${i}</option>
				</c:forEach>
			</select> of ${noOfPages}
		</div>
	</c:if>
</div>
<script type="text/JavaScript">
	//position page div correctly
	var product = 288 - (parseInt($$("div[name='modalRow']").size())*28);
	$("pager").setStyle("margin-top: "+product+"px;");

	$$("div[name='modalRow']").each(function(row) {
		// checks if this recorded is already tagged
		$$("div[id='gcopInvRow"+row.down("input", 1).value+"-"+row.down("input", 2).value+"-"+row.down("input",3).value+"']").each(function(invRow) {
			row.down("input", 0).checked = true;
		});
		
		row.down("input", 0).observe("change", function() {
			if (row.down("input", 0).checked) {
				// start : SR-4185, 4274, 4275, 4276, 4277 [GIACS020] : shan 05.20.2015
				if (objACGlobal.validateGIACS020BillNo(row.down("input", 1).value, row.down("input", 2).value)){ // shan 04.27.2015
					new Ajax.Request(contextPath+"/GIACCommPaytsController?action=checkGcopInvChkTag", {
						evalScripts: true,
						asynchronous: true,
						method: "GET",
						parameters: {
							checked: "Y",
							issCd: row.down("input", 1).value,
							premSeqNo: row.down("input", 2).value,
							commTagDisplayed: ($("chkDefCommTag").style.display == "none") ? "N" : "Y",
							tranType: $F("txtTranType"),
							varCommPayableParam: $F("varCommPayableParam")
						},
						onComplete: function(response) {
							if (checkErrorOnResponse(response)) {
								var result = response.responseText.toQueryParams();
								//added by steven 09.12.2014
								var result2 = objACGlobal.checkRelCommWUnprintedOr(row.down("input", 1).value,row.down("input", 2).value);
								if (result2.message == "ALLOWED") {
									showConfirmBox("Confirmation", "The premium payment of bill no. " + result2.issCd + "-" + result2.premSeqNo + " is not yet printed. "+result2.refNo +'.'+
											"Do you want to continue?",
											"Yes", "No",
											function() {
												if (result.message == "SUCCESS") {
													addGcopInvRecord(row);
												} else if (result.message == "PARAM2_OVERWRITE") {
													/*showConfirmBox("", "Policy is not yet fully paid. Do you wish to override it?",
															"Yes", "No",
															function() {
																addGcopInvRecord(row);
															},
															function() {
																row.down("input", 0).checked = false;
															}
													);*/
													showCommPaytConfirmation(result);
												}else if (result.accessMC == "FALSE"){ //added by robert SR 19679 07.09.15
													row.down("input", 0).checked = false;
													showMessageBox(result.message, imgMessage.INFO); //end robert SR 19679 07.13.15
												} else if (result.noPremPayt != null && result.noPremPayt == "Y"){	// added by shan 09.11.2014
													showCommPaytConfirmation(result);
												} else {
													row.down("input", 0).checked = false;
													showMessageBox(result.message, imgMessage.INFO);
												}
												return;
											},
											function() {
												row.down("input", 0).checked = false;
												return;
											}
									);
								}else if (result2.message == "NOT_ALLOWED") {
									showMessageBox( "The premium payment of bill no. " + result2.issCd + "-" + result2.premSeqNo + " is not yet printed. "+result2.refNo +'.','I');
									row.down("input", 0).checked = false;
									return;
								}
								
								if (result2.message != "ALLOWED") {
									if (result.message == "SUCCESS") {
										addGcopInvRecord(row);
									} else if (result.message == "PARAM2_OVERWRITE") {	// bill with partial payment
										/*showConfirmBox("", "Policy is not yet fully paid. Do you wish to override it?",
												"Yes", "No",
												function() {
													addGcopInvRecord(row);
												},
												function() {
													row.down("input", 0).checked = false;
												}
										);*/ // replaced by codes below  : shan 10.16.2014
										if (result.noPremPayt != null){
											if (result.noPremPayt == "N" && result.accessMC == "TRUE"){
												showConfirmBox("", "Policy is not yet fully paid. Do you wish to override it?",
														"Yes", "No",
														function() {
															addGcopInvRecord(row);
														},
														function() {
															row.down("input", 0).checked = false;
														}
												);
											}else if (result.noPremPayt == "Y"){
												showCommPaytConfirmation(result);
											}
										}
									}else if (result.accessMC == "FALSE"){ //added by robert SR 19679 07.09.15
										row.down("input", 0).checked = false;
										showMessageBox(result.message, imgMessage.INFO); //end robert SR 19679 07.13.15	
									} else if (result.noPremPayt != null && result.noPremPayt == "Y"){	// added by shan 09.11.2014	
										showCommPaytConfirmation(result);							
									} else {
										row.down("input", 0).checked = false;
										showMessageBox(result.message, imgMessage.INFO);
									}
								}
							} else {
								row.down("input", 0).checked = false;
								showMessageBox(response.responseText, imgMessage.ERROR);
							}
						}
					});
				}else{ // shan 04.27.2015
					row.down("input", 0).checked = false;
				}	// end : SR-4185, 4274, 4275, 4276, 4277 [GIACS020] : shan 05.20.2015
			} else {
				$$("div[id='gcopInvRow"+row.down("input", 1).value+"-"+row.down("input", 2).value+"-"+row.down("input",3).value+"']").each(function(invRow) {
					invRow.remove();
				});
			}
		});
		
		function showCommPaytConfirmation(result){
			showConfirmBox("CONFIRMATION", "Premium of this policy is still unpaid/partially paid. Would you like to continue with the commission payment?",
					"Yes", "No",
					function(){
						if (result.accessAU == "FALSE"){
							new Ajax.Request(contextPath+"/GIACCommPaytsController?action=checkingIfPaidOrUnpaid", {
				                evalScripts: true,
				                asynchronous: true,
				                method: "GET",
				                parameters: {
				                    issCd: row.down("input", 1).value,
				                    premSeqNo: row.down("input", 2).value
				                },
				                onComplete: function(response) {
				                    if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
				                    	if(response.responseText == "NO PAYMENT"){ //Modified by Jerome Bautista 03.07.2016 SR 21279
				                    		if ($F("accessAU") == "FALSE"){
				                    			showConfirmBox("CONFIRMATION", "User is not allowed to disburse commission. Would you like to override?",
				    									"Yes", "No",
				    									function() {
				    										showGenericOverride("GIACS020", "AU",
				    												function(ovr, userId, result){
				    													if(result == "FALSE"){
				    														showMessageBox(userId + " is not allowed to process payments for unpaid premium.", imgMessage.ERROR);
				    														$("txtOverrideUserName").clear();
				    														$("txtOverridePassword").clear();
				    														return false;
				    													} else if(result == "TRUE"){
				    														row.down("input", 0).checked = true;
				    														addGcopInvRecord(row);
				    														ovr.close();
				    														delete ovr;																			
				    													}
				    												},
				    												function() {
				    													row.down("input", 0).checked = false;
				    												}
				    										);
				    									},
				    									function(){	// no for USER confirmation
				    										row.down("input", 0).checked = false;
				    									}
				    							);
				                    		}	
				                    	} else if(response.responseText == "PARTIAL PAYMENT"){ //Modified by Jerome Bautista 03.07.2016 SR 21279
				                    		addGcopInvRecord(row);
				                    	} 
				                    }
				                }
				            });
						}else{
							addGcopInvRecord(row);
						}
						
					},
					function(){	// no for commission payment
						row.down("input", 0).checked = false;
					}
			);
		}
	});

	$$("label[name='modalLblIntmName']").each(
		function(label) {
			if ((label.innerHTML).length > 30)    {
	            label.update((label.innerHTML).truncate(30, "..."));
	        }

			Effect.Appear("modalGcopDivTableContainer", {
		    	duration: 0.3
		    });
		}
	);

	$$("div[name='modalRow']").each(
		function (row)	{
			row.observe("mouseover", function ()	{
				row.addClassName("lightblue");
			});
			
			row.observe("mouseout", function ()	{
				row.removeClassName("lightblue");
			});
		
			row.observe("click", function ()	{
				row.toggleClassName("selectedRow");
				if (row.hasClassName("selectedRow"))	{
					$("selectedRow").value = row.id;
					$$("div[name='modalRow']").each(function (r)	{
						if (row.getAttribute("id") != r.getAttribute("id"))	{
							r.removeClassName("selectedRow");
						}
					});
				} else {
					$("selectedRow").value = "";
				}
			});
		}
	);

	if ($("gcopInvPage") != null) {
		$("gcopInvPage").observe("change", function() {
			page = $("gcopInvPage").options[$("gcopInvPage").selectedIndex].value;
			if (!page.blank()) {
				searchGcopInvDetails($("gcopInvPage").options[$("gcopInvPage").selectedIndex].value);
			}
		});
	}

	// save gcop inv record on this list when record is checked
	function addGcopInvRecord(row) {
		var gcopInvDiv = $("gcopInvRecordsList");
		var newDiv = new Element("div");
		newDiv.setAttribute("id", "gcopInvRow"+row.down("input", 1).value+"-"+row.down("input", 2).value+"-"+row.down("input",3).value);
		newDiv.setAttribute("name", "gcopInvRow");
		newDiv.update(
				'<input type="hidden" id="gcopInvIssCd" 		name="gcopInvIssCd" 	  		  value="'+row.down("input", 1).value+'" />' +
				'<input type="hidden" id="gcopInvPremSeqNo" 	name="gcopInvPremSeqNo" 	  	  value="'+row.down("input", 2).value+'" />' +
				'<input type="hidden" id="gcopInvIntmNo" 		name="gcopInvIntmNo"		 	  value="'+row.down("input", 3).value+'" />' +
				'<input type="hidden" id="gcopInvIntmName" 		name="gcopInvIntmName" 	  		  value="'+row.down("input", 4).value+'" />' +
				'<input type="hidden" id="gcopInvCommAmt" 		name="gcopInvCommAmt" 	  		  value="'+row.down("input", 5).value+'" />' +
				'<input type="hidden" id="gcopInvInputVat" 		name="gcopInvInputVat" 	  		  value="'+row.down("input", 6).value+'" />' +
				'<input type="hidden" id="gcopInvWithTax" 		name="gcopInvWithTax" 	  		  value="'+row.down("input", 7).value+'" />' +
				'<input type="hidden" id="gcopInvNetCommAmt" 		name="gcopInvNetCommAmt" 	  		  value="'+row.down("input", 8).value+'" />'+
				'<input type="hidden" id="gcopBillGaccTranId" 		name="gcopBillGaccTranId" 	  		  value="'+row.down("input", 9).value+'" />'
				);
	
		gcopInvDiv.appendChild(newDiv);
	}
</script>