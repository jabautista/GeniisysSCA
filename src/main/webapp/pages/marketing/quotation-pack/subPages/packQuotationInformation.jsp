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
					<input style="width: 170px;" id="lineName" type="text" value="<c:if test="${not empty gipiPackQuote}">${gipiPackQuote.lineName}</c:if><c:if test="${not empty lineName}">${lineName}</c:if>" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="width: 150px;">Subline </td>
				<td class="leftAligned" id="sublineContainer" style="width: 205px;">
				<c:if test="${editPackQuotation ne 1}">
					<select id="subline" name="subline" style="width: 178px;" class="required">
						<option value=""></option>
						<c:forEach var="s" items="${sublineListing}">
							<option value="${s.sublineCd}" 
							<c:if test="${gipiPackQuote.sublineName eq s.sublineName}">
									selected="selected"
							</c:if>
							>${s.sublineCd} - ${s.sublineName}</option>
						</c:forEach>
					</select>
				</c:if>	
				<c:if test="${editPackQuotation eq 1}">
					<input id="subline" name="subline" style="width: 170px;" type="text" value="${gipiPackQuote.sublineName}" readonly="readonly" />
				</c:if>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Issuing Source </td>
			    <td class="leftAligned" id="issSourceContainer">
			    <c:if test="${editPackQuotation ne 1}">	
			    	<select id="issSource" name="issSource" style="width: 178px;" class="required">
						<option value=""></option>
						<c:forEach var="branchSourceListing2" items="${issourceListing}">
							<option value="${branchSourceListing2.issCd}"
							<c:if test="${gipiPackQuote.issCd == branchSourceListing2.issCd}">
								 selected="selected"
							</c:if>
							<c:if test="${defaultIssSource.issCd eq branchSourceListing2.issCd}">
								selected="selected"
							</c:if>
							>${branchSourceListing2.issName}</option>
						</c:forEach>
					</select>
				</c:if>	
				<c:if test="${editPackQuotation eq 1}">
					<input id="issSource" name="issSource" style="width: 170px;" type="text" readonly="readonly" 
					<c:forEach var="branchSourceListing2" items="${issourceListing}">
						<c:if test="${gipiPackQuote.issCd eq branchSourceListing2.issCd}">
						 value="${branchSourceListing2.issName}" 
						</c:if>
					</c:forEach>
					/>
				</c:if>
				</td>
				<td class="rightAligned">Quotation Year </td>
			    <td class="leftAligned">
			    	<input style="width: 170px;" id="quotationYY" name="quotationYY" type="text" value="${gipiPackQuote.quotationYy}${year}" readonly="readonly" />
			    </td>
			</tr>
			<tr>
				<td class="rightAligned">Quotation Seq. No. </td>
			    <td class="leftAligned"><input style="width: 170px;" id="quotationNo" name="quotationNo" type="text" value="${quotationNo}" readonly="readonly" /></td>	
				<td class="rightAligned">Proposal Number</td>
			    <td class="leftAligned"><input style="width: 170px;" id="proposalNo" name="proposalNo" type="text" value="${gipiPackQuote.proposalNo}${proposalNo}" readonly="readonly" /></td>
		  	</tr>
		  	<tr>
				<td class="rightAligned">Crediting Branch </td>
			    <td class="leftAligned">
					<select id="creditingBranch" name="creditingBranch" style="width: 178px;">
						<option value=""></option>
						<c:forEach var="creditingBranchListing" items="${branchSourceListing}">  <!-- editted by steven 10/31/2012 -->
							<option value="${creditingBranchListing.issCd}"
							<c:if test="${gipiPackQuote.credBranch == creditingBranchListing.issCd}">
								selected="selected"
							</c:if>>${creditingBranchListing.issName}</option>				
						</c:forEach>
					</select>
				</td>	
				<td class="rightAligned">Validity Date </td>
			    <td class="leftAligned">
			    	<div>
			    		<%-- <input style="width: 170px; border: none;" id="validDate" name="validDate" type="text" value="<fmt:formatDate value="${gipiPackQuote.validDate}" pattern="MM-dd-yyyy"/>" readonly="readonly"/> --%>
			    		<input style="width: 170px; border: none;" id="validDate" name="validDate" type="text" value="${gipiPackQuote.validDate}" readonly="readonly"/>
			    		<img id="hrefValidDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('validDate'),this, null);" alt="Validity Date" />
			    	</div>
				</td>
		  	</tr>
		  	<tr>
		  		<td class="rightAligned">Assured Name </td>
			    <td class="leftAligned">
				   <div style="border: 1px solid gray; width: 176px; height: 21px; float: left; margin-right: 3px;">
			    		<input style="float: left; border: none; margin-top: 0px; width: 150px;" id="assuredName" name="assuredName" type="text" value="${gipiPackQuote.assdName}" maxlength="500"/>
			    		<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editPackAssured" class="hover"/>
			    	</div>
			    	<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscm" name="oscm" alt="Go"  style="float: right"/>	
			    
			    	<%-- <div style="border: 1px solid gray; width: 176px; height: 21px; float: left; margin-right: 3px;">
			    		<input style="float: left; border: none; margin-top: 0px; width: 150px;" id="assuredName" name="assuredName" type="text" value="${gipiPackQuote.assdName }" />
			    		<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscm" name="oscm" alt="Go" />
			    	</div> --%>
			    	<input id="assuredNo" name="assuredNo" type="hidden" value="${gipiPackQuote.assdNo}" />
			    </td>
				<td class="rightAligned">Accept Date </td>
			    <td class="leftAligned">													
			    	<%-- <input style="width: 170px;" id="acceptDate" name="acceptDate" type="text" <fmt:formatDate value="${gipiPackQuote.acceptDt}" pattern="MM-dd-yyyy" /> readonly="readonly" />--%>
			    	<%-- <input style="width: 170px;" id="acceptDate" name="acceptDate" type="text" value="<fmt:formatDate value="${gipiPackQuote.acceptDt}" pattern="MM-dd-yyyy" />${acceptDate}" readonly="readonly" /> --%>
			    	<input style="width: 170px;" id="acceptDate" name="acceptDate" type="text" value="${gipiPackQuote.acceptDt}${acceptDate}" readonly="readonly" /> 
				</td>
		  	</tr>
		  	<tr>
		  		<td class="rightAligned" id="accountOfLabel">In Account Of </td>
			    <td class="leftAligned">
			    	<!-- <span style="border: 1px solid gray; width: 176px; background-color: #fff; height: 21px; float: left;"> -->
			    	<div style="border: 1px solid gray; width: 176px; height: 21px; float: left; margin-right: 3px;">
			    		<input style="float: left; border: none; margin-top: 0px; width: 150px;" id="inAccountOf" name="inAccountOf" type="text" value="${gipiPackQuote.acctOf}" readonly="readonly" lastValidValue=""/>
			    		<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osao" name="osao" alt="Go" />
			    	</div>
			    	<!-- </span> -->
			    	<!-- <input type="button" id="osao" name="osao" class="button" value="Search" /> -->
			    	<input id="acctOfCd" name="acctOfCd" type="hidden" value="${gipiPackQuote.acctOfCd}" />
			    	<input id="accountOfSW" name="accountOfSW" type="checkbox"/> <!-- Added by Jerome 08.17.2016 SR 5586 -->
			    </td>
				<td class="rightAligned">Address </td>
			    <td class="leftAligned">
			    	<input style="width: 170px;" id="address1" name="address1" type="text" value="${gipiPackQuote.address1}" maxlength="50" />
			    </td>
		  	</tr>
		  	<tr>
				<td colspan="3"></td>								
				<td class="leftAligned"><input style="width: 170px;" id="address2" name="address2" type="text" value="${gipiPackQuote.address2}" maxlength="50" /></td>								
		  	</tr>	
		  	<tr>
		  		<td colspan="3"></td>
				<td class="leftAligned"><input style="width: 170px;" id="address3" name="address3" type="text" value="${gipiPackQuote.address3}" maxlength="50" /></td>
		  	</tr>
		</table>
	</div>
</div>

<script type="text/javascript">
	var oldAssdNo = null;
	var oldAssdName = null;
	var title = ""; // Added by Jerome 08.18.2016 SR 5586
	/**
		added for assured that has existing quotation/par/policies
	**/
	if ('${gipiPackQuote.accountOfSW}'== 2) { //Added by Jerome 08.18.2016 SR 5586
		$("accountOfSW").checked = true;
	} else {
		$("accountOfSW").checked = false;
	}
	
	$("proposalNo").value = lpad(('${gipiPackQuote.proposalNo}${proposalNo}'),"3","0"); ////added by steven 1/30/2013; base on SR 0012059
	function checkAssdNamePack(assdName){//added by irwin May 14, 2012 - Historic before Diablo 3 release
		new Ajax.Request(contextPath+"/GIPIQuotationController?action=checkAssdName&assdName="+encodeURIComponent(assdName)+"&assdNo="+$F("assuredNo"),{ //Modified by Sam10.06.2015
			asynchronous: true,
			evalScripts: true,
			onCreate: function ()	{
				showNotice("Checking assured name, please wait...");
			},
			onComplete: function (response)	{
				hideNotice();
				try{	
					//var messageArray = response.responseText.split(','); // 0=success, 1= assdNo, 2=address1,3=address2, 4=address3
					//var message = response.responseText.toQueryParams(); // irwin - 5.22.2012
					var message = JSON.parse(response.responseText); // bonok :: 09.04.2012
					$("assuredNo").value= message.assdNo; 
					$("address1").value	= unescapeHTML2(message.address1);
					$("address2").value = unescapeHTML2(message.address2);
					$("address3").value = unescapeHTML2(message.address3);
					
					checkPackAssuredName(assdName);
				}catch(e){
					showErrorMessage("checkAssdName", e);
				}
			}
		});
	};
	
	function getExistingPackQuotations(){
		try{
			genericObjOverlay = Overlay.show(contextPath+"/GIPIPackQuoteController", { 
				urlContent: true,
				urlParameters: {action : "getExistingPackQuotations",
								lineCd : $F("lineCd"),
								assdNo: $F("assuredNo"),
								ajax : "1"},
				title: "List of Existing Quotation/s and Policies",							
			    height: 400,
			    width: 880,
			    draggable: true
			});
		}catch(e){
			showErrorMessage("getExistingPackQuotations",e);
		}
	}

	function checkPackAssuredName(){
		try{
			//if($F("assuredNo") != ""){
				if($F("assuredName") != nvl(oldAssdName, "$$")){
					oldAssdNo = $F("assuredNo");
					oldAssdName = $F("assuredName"); 
					new Ajax.Request(contextPath+"/GIPIPackQuoteController", {
						method: "GET",
						asynchronous: false,
						parameters: 
							{action		: "getExistMsgPack",
							 lineCd		: $F("lineCd"),
							 assdNo		: nvl($F("assuredNo"), -1)},
						onComplete: function(response) {
							try{
								 if(checkErrorOnResponse(response)){
									 if ("SUCCESS" == response.responseText){
										 changeTag = 1;
									 } else {
										showConfirmBox("Multiple Assured", response.responseText, "Display List", "Cancel", getExistingPackQuotations, 
											function(){ 
												changeTag = 1; 
												$("assuredName").value = ""; 
												$("assuredNo").value= "";
												$("address1").value	= "";
												$("address2").value = "";
												$("address3").value = "";
												oldAssdName = null;
										});
										
									 }
								 }
							}catch(e){
								showMessageBox(e.message, imgMessage.ERROR);
							}	 
						}
					});		 
				}
			//}else{
			//	oldAssdNo = null;
		//	}
		}catch (e) {
			showErrorMessage("checkPackAssuredName",e);
		}
	}
	
	<c:if test="${not empty validityDate}">
		$("validDate").value = "${validityDate}";
	</c:if>

	function showInAccountOfLOV(isIconClicked, title) {
		try {
			var search = isIconClicked ? "%" : ($F("inAccountOf").trim() == "" ? "%" : $F("inAccountOf"));
			
			LOV.show({
				controller : "MarketingLOVController",
				urlParameters : {
					action : "getAcctOfList2",
					assdNo : $F("assuredNo"),
					//inAccountOf : $F("inAccountOf"),
					search : search,
					page: 1
				},
				title : title,
				width : 480,
				height : 386,
				columnModel : [ 
				    {
						id : "assdName",
						title : "Assured Name",
						width : '190px'
				    },
				    {
						id : "birthDate",
						title : "Birthday",
						width : '80px'
				    },
				    {
						id : "mailAddress",
						title : "Address",
						width : '190px'
				    }
				],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : escapeHTML2(search),
				onSelect : function(row) {
					if (row != null || row != undefined) {
						$("inAccountOf").value = unescapeHTML2(row.assdName);
						$("inAccountOf").setAttribute("lastValidValue", unescapeHTML2(row.assdName));
					}
				},
				onCancel : function() {
					$("inAccountOf").focus();
					$("inAccountOf").value = $("inAccountOf").readAttribute("lastValidValue");
				},
				onUndefinedRow : function() {
					$("inAccountOf").value = $("inAccountOf").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "inAccountOf");
				}
			});
		} catch (e) {
			showErrorMessage("showInAccountOfLOV", e);
		}
	}
	
	$("assuredName").observe("change", function(){
		checkAssdNamePack($F("assuredName"));
		
	});
	
	if($("accountOfSW").checked == true){ //Added by Jerome 08.18.2016 SR 5586
		document.getElementById("accountOfLabel").innerHTML = "Leased To";
		title = "Search Leased To";
		objGIIMM001A.chkboxSW = 2;
	} else {
		document.getElementById("accountOfLabel").innerHTML = "In Account Of";
		title = "Search In Account Of";
		objGIIMM001A.chkboxSW = 1;
	}
	
	$("accountOfSW").observe("change", function(){ //Added by Jerome 08.18.2016 SR 5586
		if($("accountOfSW").checked == true){
			document.getElementById("accountOfLabel").innerHTML = "Leased To";
			title = "Search Leased To";
			objGIIMM001A.chkboxSW = 2;
		} else {
			document.getElementById("accountOfLabel").innerHTML = "In Account Of";
			title = "Search In Account Of";
			objGIIMM001A.chkboxSW = 1;
		}    
	});
	
	$("editPackAssured").observe("click", function () {
		//showEditorAssured("assuredName", 500);	replaced by codes below Gzelle 10.02.2013
		showOverlayEditor("assuredName", 500, $("assuredName").hasAttribute("readonly"), function() {
			limitText($("assuredName"),500);
		});
	});
	
	$$("input[name='assuredName']").each(function (row) {
		row.observe("keyup", function(){
			row.value = row.value.toUpperCase();
			limitText(this,500);
		});
		row.observe("keydown", function(){
			row.value = row.value.toUpperCase();
			limitText(this,500);
		});
	});
	$("validDate").observe("blur", setValidDate);
	
	$("osao").observe("click", function() {
		showInAccountOfLOV(true, title);
	});

	$("inAccountOf").observe("change", function() {
		if (this.value != "") {
			showInAccountOfLOV(false, title);
		} else {
			$("inAccountOf").value = "";
			$("inAccountOf").setAttribute("inAccountOf", "");
		}
	});
	
	
// 	$("osao").observe("click", function()	{
// 		openSearchAccountOf();
// 	});
	
	$("oscm").observe("click", function ()	{
		showAssuredListingTG("", function(){
			checkAssdNamePack($F("assuredName"));
		}); /*openSearchClientModal();*/
	});
	
	$("hrefValidDate").observe("click", function(){ //added by steven 2.5.2013
		objMKGlobal.preValidDate = $F("validDate");
	});
</script>