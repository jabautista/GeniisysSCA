<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
		<label id="">Quotation Information</label>  
		<span class="refreshers" style="margin-top: 0;">
			<label name="gro" style="margin-left: 5px;">Hide</label>
			<label id="reloadForm" name="reloadForm">Reload Form</label>
		</span>
	</div>
</div>
<div class="sectionDiv" id="quotationInformationDiv" >
	<div id="quotationInformation" style="margin: 10px;">
		<table cellspacing="1" border="0" style="margin: 10px auto;">
			<tr>
				<td class="rightAligned" style="width: 110px;">Line of Business</td>
				<td class="leftAligned">
					<input tabindex="1" style="width: 170px;" id="lineName" type="text" value="<c:if test="${not empty gipiQuote}">${gipiQuote.lineName}</c:if><c:if test="${not empty lineName}">${lineName}</c:if>" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="width: 150px;">Subline </td>
				<td class="leftAligned" id="sublineContainer" style="width: 205px;">
				<c:if test="${editQuotation ne 1}">
					<select id="subline" name="subline" style="width: 178px;" class="required" tabindex="2">
						<option value=""></option>
						<c:forEach var="s" items="${sublineListing}">
							<option value="${s.sublineCd}"  sublineCd="${s.sublineCd}" sublineName="${s.sublineName}"
							<c:if test="${gipiQuote.sublineCd eq s.sublineCd}">
									selected="selected"
							</c:if>
							>${s.sublineCd} - ${s.sublineName}</option>
						</c:forEach>
					</select>
				</c:if>	
				<c:if test="${editQuotation eq 1}">
					<input id="subline" name="subline" style="width: 170px;" type="text" value="${gipiQuote.sublineCd} - ${gipiQuote.sublineName}" sublineName="${gipiQuote.sublineName}" sublineCd="${gipiQuote.sublineCd}" readonly="readonly" tabindex="2"/>					
				</c:if>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Issuing Source </td>
			    <td class="leftAligned" id="issSourceContainer">
			     <c:if test="${editQuotation ne 1}">
			    	<select id="issSource" name="issSource" style="width: 178px;" class="required"> 
						<option value=""></option>
						<c:forEach var="issSourceListing2" items="${issSourceListing}">
							<option value="${issSourceListing2.issCd}" 
							<c:if test="${gipiQuote.issCd == issSourceListing2.issCd}">
								 selected="selected"
							</c:if>
							<c:if test="${defaultIssSource.issCd eq issSourceListingListing2.issCd}">
								selected="selected"
							</c:if>
							>${issSourceListing2.issName}</option>
						</c:forEach>
					</select>
				</c:if>	
				<c:if test="${editQuotation eq 1}">
					<input id="issSource" name="issSource" style="width: 170px;" type="text" readonly="readonly" 
					<c:forEach var="issSourceListing2" items="${issSourceListing}">
						<c:if test="${gipiQuote.issCd eq issSourceListing2.issCd}">
						 value="${issSourceListing2.issName}" 
						</c:if>
					</c:forEach>
					/>
				</c:if> 
				<td class="rightAligned">Quotation Year </td>
			    <td class="leftAligned">
			    	<input style="width: 170px;" id="quotationYY" name="quotationYY" type="text" value="${gipiQuote.quotationYy}${year}" readonly="readonly" />
			    </td>
			</tr>
			<tr>
				<td class="rightAligned">Quotation Seq. No. </td>
			    <td class="leftAligned"><input style="width: 170px;" id="quotationNo" name="quotationNo" type="text" value="${quotationNo}" readonly="readonly" /></td>	
				<td class="rightAligned">Proposal Number</td>
			    <td class="leftAligned"><input style="width: 170px;" id="proposalNo" name="proposalNo" type="text" value="<fmt:formatNumber value="${gipiQuote.proposalNo}${proposalNo}" pattern="000"/>" readonly="readonly" /></td>
		  	</tr>
		  	<tr>
				<td class="rightAligned">Crediting Branch </td>
			    <td class="leftAligned">
					<select id="creditingBranch" name="creditingBranch" style="width: 178px;">
						<option value=""></option>
						<c:forEach var="creditingBranchListing" items="${branchSourceListing}">
							<option value="${creditingBranchListing.issName}"
							<c:if test="${gipiQuote.credBranch == creditingBranchListing.issCd}">
								selected="selected"
							</c:if>>${creditingBranchListing.issName}</option>				
						</c:forEach>
					</select>
				</td>	
				<td class="rightAligned">Validity Date </td>
			    <td class="leftAligned">
			    	<div>
			    		<%-- <input style="width: 170px; border: none;" id="validDate" name="validDate" type="text" value="<fmt:formatDate value="${gipiQuote.validDate}" pattern="MM-dd-yyyy"/>" readonly="readonly"/> --%>
			    		<input style="width: 170px; border: none;" id="validDate" name="validDate" type="text" value="${gipiQuote.validDate}" readonly="readonly"/>
			    		<img id="hrefValidDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('validDate'),this, null);" alt="Validity Date" />
			    	</div>
				</td>
		  	</tr>
		  	<tr>
		  		<td class="rightAligned">Assured Name </td>
			    <td class="leftAligned">
			    	<!-- <span style="border: 1px solid gray; width: 176px; background-color: #fff; height: 21px; float: left;"> -->
			    	<div style="border: 1px solid gray; width: 176px; height: 21px; float: left; margin-right: 3px;">
			    		<input style="float: left; border: none; margin-top: 0px; width: 150px;" id="assuredName" name="assuredName" type="text" value="${gipiQuote.assdName }" />
			    		<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editAssured" class="hover"/>
			    	</div>
			    	<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscm" name="oscm" alt="Go"  style="float: right"/>	
			    	<!-- </span> -->
			    	<!-- <input id="oscm" name="oscm" class="button" type="button" value="Search" alt="Go" /> -->
			    	<input id="assuredNo" name="assuredNo" type="hidden" value="${gipiQuote.assdNo}" />
			    </td>
				<td class="rightAligned">Accept Date </td>
			    <td class="leftAligned">													
			    	<%-- <input style="width: 170px;" id="acceptDate" name="acceptDate" type="text" <fmt:formatDate value="${gipiQuote.acceptDt}" pattern="MM-dd-yyyy" /> readonly="readonly" />--%>
			    	<%-- <input style="width: 170px;" id="acceptDate" name="acceptDate" type="text" value="<fmt:formatDate value="${gipiQuote.acceptDt}" pattern="MM-dd-yyyy" />${acceptDate}" readonly="readonly" /> --%>
			    	<input style="width: 170px;" id="acceptDate" name="acceptDate" type="text" value="${gipiQuote.acceptDt}${acceptDate}" readonly="readonly" /> 
				</td>
		  	</tr>
		  	<tr>
		  		<td class="rightAligned" id="accountOfLabel">In Account Of </td>
			    <td class="leftAligned">
			    	<!-- <span style="border: 1px solid gray; width: 176px; background-color: #fff; height: 21px; float: left;"> -->
			    	<div style="border: 1px solid gray; width: 176px; height: 21px; float: left; margin-right: 3px;">
			    		<input style="float: left; border: none; margin-top: 0px; width: 150px;" id="inAccountOf" name="inAccountOf" type="text" value="${gipiQuote.acctOf}" readonly="readonly" />
			    		<!--<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editInAccountOf" />
			    		--><img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osao" name="osao" alt="Go" />
			    	</div>
			    	
			    	<!-- </span> -->
			    	<!-- <input type="button" id="osao" name="osao" class="button" value="Search" /> -->
			    	<input id="acctOfCd" name="acctOfCd" type="hidden" value="${gipiQuote.acctOfCd}" />
			    	<input id="accountOfSW" name="accountOfSW" type="checkbox"/> <!-- Added by Jerome 08.17.2016 SR 5586 -->
			    </td>
			    
				<td class="rightAligned">Address </td>
			    <td class="leftAligned">
			    	<input style="width: 170px;" id="address1" name="address1" type="text" value="${gipiQuote.address1}" maxlength="50" />
			    </td>
		  	</tr>
		  	<tr>
				<td colspan="3"></td>								
				<td class="leftAligned"><input style="width: 170px;" id="address2" name="address2" type="text" value="${gipiQuote.address2}" maxlength="50" /></td>								
		  	</tr>	
		  	<tr>
		  		<td colspan="3"></td>
				<td class="leftAligned"><input style="width: 170px;" id="address3" name="address3" type="text" value="${gipiQuote.address3}" maxlength="50" /></td>
		  	</tr>
		</table>
	</div>
</div>

<input id="vExist1" type="hidden"/> <!-- added for query change in existing quote or policy Irwin--> 
<input id="vExist2" type="hidden"/>
<input type="hidden" name="defaultIssCd" id="defaultIssCd"	value="${defaultIssCd}"/>
<input type="hidden" name="issName" id=issName	value="${gipiQuote.issName}"/> <!-- added to store the value of selected option's label ~ emsy09102012 -->
<script>
	<c:if test="${not empty validityDate}">
		$("validDate").value = "${validityDate}";
	</c:if>

	$("editAssured").observe("click", function () {
		showEditorAssured("assuredName", 500);
	});
	/*
	editInAccountOf
	$("editInAccountOf").observe("click", function () {
		showEditorAssured("inAccountOf", 500);
	});*/
	
	/* $("assuredName").observe("change", function(){
		//$("assuredNo").value = "0"; //temp for manual input of assured name
		//checkAssdExistsList();
		$("allowMultipl	eAssuredSw").value = "false";
		checkAssdName($F("assuredName"));
	}); */
	var title = ""; //Added by Jerome 08.17.2016 SR 5586
	
	if ('${gipiQuote.accountOfSW}'== 2) {
		$("accountOfSW").checked = true;
	} else {
		$("accountOfSW").checked = false;
	}
	
	if($("accountOfSW").checked == true){ //Added by Jerome 08.17.2016 SR 5586
		document.getElementById("accountOfLabel").innerHTML = "Leased To";
		title = "Search Leased To";
		objGIIMM001.chkboxSW = 2;
	} else {
		document.getElementById("accountOfLabel").innerHTML = "In Account Of";
		title = "Search In Account Of";
		objGIIMM001.chkboxSW = 1;
	}
	
	$("accountOfSW").observe("change", function(){ //Added by Jerome 08.17.2016 SR 5586
		if($("accountOfSW").checked == true){
			document.getElementById("accountOfLabel").innerHTML = "Leased To";
			title = "Search Leased To";
			objGIIMM001.chkboxSW = 2;
		} else {
			document.getElementById("accountOfLabel").innerHTML = "In Account Of";
			title = "Search In Account Of";
			objGIIMM001.chkboxSW = 1;
		}    
	});
	
	function checkAssdName(assdName, assdNo){//added by irwin March 3, 2011
		new Ajax.Request(contextPath+"/GIPIQuotationController?action=checkAssdName",{
			asynchronous: true,
			evalScripts: true,
			parameters:{
				assdName: assdName,
				assdNo : assdNo
			},
			onCreate: function ()	{
				showNotice("Checking assured name, please wait...");
			},
			onComplete: function (response)	{
				try{
					hideNotice(response.responseText);		
					//var messageArray = response.responseText.split(','); // 0=success, 1= assdNo, 2=address1,3=address2, 4=address3
					//var message = response.responseText.toQueryParams(); // irwin - 5.22.2012
					
					var message = JSON.parse(response.responseText); // edited. d.alcantara - 8.24.2012
					
					//Added by Apollo Cruz 12.08.2014
					//Shows lov when the entered assured name has multiple records in giis_assured
					if(message.vCount > 1) {
						showAssuredListingTG("", function(){
							checkAssdName($F("assuredName"), $F("assuredNo"));
							hideNotice();
						}, "", $F("assuredName"));						
						return;
					}
					
					if($F("assuredNo") != "") { // edited. d.alcantara - 8.24.2012, nilagyan ko muna ng condition. pag may kapareho kasi na assured name, marereplace yung selected na assured info ng may kaparehong assured ng pinakamababang assured no.
						$("assuredNo").value= nvl(message.assdNo, "")=="" ? $F("assuredNo") : message.assdNo; 
						$("address1").value	= unescapeHTML2(nvl(message.address1,""));
						$("address2").value = unescapeHTML2(nvl(message.address2,""));
						$("address3").value = unescapeHTML2(nvl(message.address3,""));
					}
					
					$("vExist1").value = message.vExist1;
					$("vExist2").value = message.vExist2;
					checkAssdExistsList();
				}catch(e){
					showErrorMessage("checkAssdName", e);
				}
			}
		});
	};
	
	function checkAssdExistsList(){
		new Ajax.Request(contextPath+"/GIPIQuotationController", {
			method: "GET",
			asynchronous: false,
			parameters: 
				{action		: "getExistMessage",
				 lineCd		: $F("lineCd"),
				 assdNo		: $F("assuredNo"),
				 assdName	: $F("assuredName"),
				 quoteId	: $F("quoteId") 
				},
			onComplete: function(response) {
				try{
					 if(checkErrorOnResponse(response)){
						 if ("SUCCESS" != response.responseText){
							 showConfirmBox("Multiple Assured", response.responseText, "Display List", "Cancel", showListOfExistingQuotationsAndPolicies, 
							function(){ 
								$("assuredNo").value = "";
								$("assuredName").value = "";
								$("address1").clear();
								$("address2").clear();
								$("address3").clear();
								 changeTag = 1;  //removed clearing of assuredName and assuredNo - irwin
							}); 
						 } /* else {
							// if ($F("allowMultipleAssuredSw") == "false"){// removed - irwin
								showConfirmBox("Multiple Assured", response.responseText, "Display List", "Cancel", showListOfExistingQuotationsAndPolicies, 
										function(){ 
											$("assuredNo").value = "";
											$("assuredName").value = "";
											 changeTag = 1;  //removed clearing of assuredName and assuredNo - irwin
										}); 
							// } else {
								 
							// }
						 } */
					 }
				}catch(e){
					showMessageBox(e.message, imgMessage.ERROR);
				}	 
			}
		});
	}

	function showListOfExistingQuotationsAndPolicies(){
		try{
			/* overlayListOfExistingQuotationsAndPolicies = Overlay.show(contextPath+"/GIPIQuotationController", {
				urlContent: true,
				urlParameters: {action : "getExistingQuotesPolsListing",
								lineCd : $F("lineCd"),
								assdNo : $F("assuredNo"),
					 			assdName : $F("assuredName"),
								 vExist1    : $F("vExist1"),
								 vExist2    : $F("vExist2")},
			    title: "List of Existing Quotations/s and Policies",
			    height: 400,
			    width: 880,
			    draggable: true
			}); */
			
			genericObjOverlay = Overlay.show(contextPath+"/GIPIQuotationController", { 
				urlContent: true,
				urlParameters: {action : "getExistingQuotesPolsListing",
							lineCd : $F("lineCd"),
							assdNo : $F("assuredNo"),
				 			assdName : $F("assuredName"),
							 vExist2    : "N"},  // $F("vExist2")
				title: "List of Existing Quotation/s and Policies",							
			    height: 400,
			    width: 880,
			    draggable: true
			});
		} catch(e){
			showErrorMessage("showListOfExistingQuotationsAndPolicies", e);
		}
	}
	
	$("assuredName").observe("change", function(){
		//$("allowMultipleAssuredSw").value = "false";
		if($F("assuredName").trim() != ""){ // bonok :: 09.27.2013 :: SR: 388 - GENQA
			$("assuredNo").clear(); //added by steven 10.11.2014
			checkAssdName($F("assuredName"));	
		}
		changeTag = 1;
	});

	$$("input[name='assuredName']").each(function (row) {
		row.observe("keyup", function(){
			row.value = row.value.toUpperCase();
		});
	});	


	$("osao").observe("click", function()	{
		/* openSearchAccountOf3(title); */ //commented by MarkS 10.12.2016 SR5759 optimization of in account of lov
		//added by MarkS 10.12.2016 SR5759 optimization of in account of lov
		showInAccountOf();
	});
	
	$("oscm").observe("click", function ()	{
		//showAssuredListingTG(); /*openSearchClientModal();*/
		showAssuredListingTG("", function(){
			checkAssdName($F("assuredName"), $F("assuredNo"));
			hideNotice();
		});
	});

	$("validDate").observe("blur", setValidDate);
	//setValidDate();CONVERT_INSPECTION
	
	//emsy 09102012
	setDefaultIssCd();
	function setDefaultIssCd(){
		var a 	= $("issSource");
		var def = $F("defaultIssCd");
		for (var x=0; x<a.length; x++){
			if (a[x].value == def){
				$("issSource").selectedIndex = x;
				$("issName").value = $("issSource").options[x].text;
			}
		}
	}
	$("issSource").observe("change", function(){
		getSelectedLabel();
	});
	
	$("hrefValidDate").observe("click", function(){ //added by steven 2.5.2013
		objMKGlobal.preValidDate = $F("validDate");
	});
	
	function getSelectedLabel(){
		$("issName").value =$("issSource").options[$("issSource").selectedIndex].text;
	}
	//added by MarkS 10.12.2016 SR5759 optimization of in account of lov
	function showInAccountOf(){
		try{
			LOV.show({
				controller : "MarketingLOVController",
				urlParameters : {
					action : "getGIISAssuredLOVTG",
					page : 1
				},
				title: "In Account Of",
				width : 539,
				height : 386,
				columnModel : [
				               {
				            	   id : "assdName",
				            	   title : "Assured Names",
				            	   width : '404px'
				               },
								{
								   id : "assdNo",
								   title : "Assured No.",
								   width : '120px',
								   titleAlign: 'right',
								   align : 'right'
								}
				              ],
				draggable : true,
				onSelect : function(row){
					if(row != undefined){
						$("acctOfCd").value = row.assdNo;
						$('inAccountOf').value = unescapeHTML2(row.assdName);
						changeTag = 1;
						$("inAccountOf").focus();
					}				
				}
			});
		}catch(e){
			showErrorMessage("showInAccountOf", e);
		}
	} //end reymon
	//end sr 5759
	//emsy 09102012
</script>