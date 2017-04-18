<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
   		<label>Open Policy Detail</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label id="groOpenPolicy" name="groOpenPolicy" style="margin-left: 5px;">Hide</label>
   		</span>
   	</div>
</div>
<div id="openPolicyDiv" align="center" class="sectionDiv" style="padding-top: 10px;">
	<!-- form id="openPolicyForm" name="openPolicyForm"-->
		<table align="center">
			<tbody>
				<tr>
					<td class="rightAligned" style="width: 120px;">Ref Open Policy No.</td>
					<td align="left" colspan="6">
						<%-- <select id="refOpenPolicyNo" name="refOpenPolicyNo" style="width: 368px;">
							<option lineCd="" 		sublineCd=""
									issCd="" 		issueYy=""
									polSeqNo="" 	renewNo=""
									inceptDate="" 	expiryDate=""></option>
							<c:forEach var="pol" items="${polbasicListing}" varStatus="ctr">
								<option lineCd="${pol.lineCd}" 			sublineCd="${pol.sublineCd}"
										issCd="${pol.issCd}" 			issueYy="${pol.issueYy}"
										polSeqNo="${pol.polSeqNo}" 		renewNo="${pol.renewNo}"
										inceptDate="${pol.inceptDate}" 	expiryDate="${pol.expiryDate}">
									${pol.refPolNo}
									<c:if test="${empty pol.refPolNo}">---</c:if>
								</option>
							</c:forEach>
						</select>
						<br /> --%>
						<input type="text" id="refOpenPolicyNo" name="refOpenPolicyNo" style="width: 361px;">
					</td>
					<td>
						<img style="float:left; margin-left:1px;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchOpenPolicy1" name="searchOpenPolicy1" alt="Go" />
					</td>
				</tr>
				<tr id="openPolicyTr">
					<td class="rightAligned">Open Policy No.</td>
					<td align="left">
						<input id="opLineCd" class="leftAligned" type="text" name="opLineCd" value="" style="width: 35px;" readonly="readonly" title="Open Policy Line"/>
						<input id="parId"	name="parId"	type="hidden"	value="${openPolicy.parId}"/>
						<input id="refOpenPolNo" name="refOpenPolNo" type="hidden" value="${openPolicy.refOpenPolNo}" />
					</td>
					<td align="left">
						<input id="opSublineCd" class="leftAligned required" type="text" name="opSublineCd" value="${openPolicy.opSublineCd}" style="width: 80px;" title="Open Policy Subline"/>
					</td>
					<td align="left">
						<input id="opIssCd" class="leftAligned required" type="text" name="opIssCd" value="${openPolicy.opIssCd}" style="width: 35px;" title="Open Policy Issuing Source"/>
					</td>
					<td align="left">
						<input id="opIssYear" class="leftAligned required" type="text" name="opIssYear" value="${openPolicy.opIssueYy}" style="width: 35px;" title="Open Policy Year"/>
					</td>
					<td align="left">
						<input id="opPolSeqNo" class="leftAligned required" type="text" name="opPolSeqNo" value="${openPolicy.opPolSeqno}" style="width: 80px;" title="Open Policy Sequence Number"/>
					</td>
					<td align="left">
						<input id="opRenewNo" class="leftAligned required" type="text" name="opRenewNo" value="${openPolicy.opRenewNo}" style="width: 35px;" title="Open Policy Renew Number"/>
					</td>
					<td align="left" >
						<img style="float:left; margin-left:1px;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchOpenPolicy" name="searchOpenPolicy" alt="Go" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Declaration</td>
					<td align="left" colspan="6">
						<input id="declaration" class="leftAligned" type="text" name="declaration" value="${openPolicy.decltnNo}" style="width: 361px;" maxlength="20"/> 
					</td>
				</tr>
			</tbody>
		</table>
	<!-- /form-->
</div>
<div id="openPolicyHiddenDiv" style="display: none;">
	<input type="hidden" id="paramOpSublineCd" name="paramOpSublineCd" value="${openPolicy.opSublineCd}"/>
	<input type="hidden" id="paramOpIssCd" name="paramOpIssCd" value="${openPolicy.opIssCd}"/>
	<input type="hidden" id="paramOpIssueYy" name="paramOpIssueYy" value="${openPolicy.opIssueYy}"/>
	<input type="hidden" id="paramOpPolseqNo" name="paramOpPolseqNo" value="${openPolicy.opPolSeqno}"/>
	<input type="hidden" id="paramOpRenewNo" name="paramOpRenewNo" value="${openPolicy.opRenewNo}"/>
	<input type="hidden" id="paramDecltnNo" name="paramDecltnNo" value="${openPolicy.decltnNo}"/>
	<input type="hidden" id="gipiWItemExist" name="gipiWItemExist" value="${openPolicy.gipiWItemExist}"/>
	<input type="hidden" id="openPolicyChanged" name="openPolicyChanged" value="N"/>
</div>
 <!--div id="buttonsDiv" align="center">
 	<input id="btnSaveOpenPolicy" class="button" type="button" value="Save" name="btnSaveOpenPolicy" style="margin-left: 5px; margin-top: 10px; float: right;" />
	<input id="btnCancelOpenPolicy" class="button" type="button" value="Cancel" name="btnCancelOpenPolicy" style="margin-left: 5px; margin-top: 10px; float: right;" />
 </div--> 
 
<script type="text/javascript">

	var message3 = "";
	$("opLineCd").value = $F("globalLineCd");
	//setRefOpenPolNo(); bonok :: 01.08.2013
	setPaddedFields();

	$("refOpenPolicyNo").observe("change", function(){
		//$("opLineCd").value			= $("refOpenPolicyNo").options[$("refOpenPolicyNo").selectedIndex].getAttribute("lineCd");
		/* $("opSublineCd").value		= $("refOpenPolicyNo").options[$("refOpenPolicyNo").selectedIndex].getAttribute("sublineCd");
		$("opIssCd").value			= $("refOpenPolicyNo").options[$("refOpenPolicyNo").selectedIndex].getAttribute("issCd");
		$("opIssYear").value		= $("refOpenPolicyNo").options[$("refOpenPolicyNo").selectedIndex].getAttribute("issueYy");
		$("opPolSeqNo").value		= $("refOpenPolicyNo").options[$("refOpenPolicyNo").selectedIndex].getAttribute("polSeqNo");
		$("opRenewNo").value		= $("refOpenPolicyNo").options[$("refOpenPolicyNo").selectedIndex].getAttribute("renewNo"); */ // comment out by bonok :: 01.08.2013
		setPaddedFields();
		setOpenPolicyChanged();
		}
	);

	$("opSublineCd").observe("change", function(){
		//setRefOpenPolNo(); // comment out by bonok :: 01.08.2013
		if (isPolExist()){
			setOpenPolicyChanged();
		} /* else {
			if($F("refOpenPolicyNo") != "") {
				$("opSublineCd").value = $("refOpenPolicyNo").options[$("refOpenPolicyNo").selectedIndex].getAttribute("sublineCd");
			}
		} */ // comment out by bonok :: 01.08.2013
	});

	$("opSublineCd").observe("keyup", function(){
		$("opSublineCd").value = $F("opSublineCd").toUpperCase();
	});

	$("opIssCd").observe("change", function(){ 
		//setRefOpenPolNo(); // comment out by bonok :: 01.08.2013
		if (isPolExist()){
			setOpenPolicyChanged();
		} /* else { 
			if($F("refOpenPolicyNo") != "") {
				$("opIssCd").value = $("refOpenPolicyNo").options[$("refOpenPolicyNo").selectedIndex].getAttribute("issCd");
			}
		} */ // comment out by bonok :: 01.08.2013
	});

	$("opIssCd").observe("keyup", function(){
		$("opIssCd").value = $F("opIssCd").toUpperCase();
	});

	$("opIssYear").observe("change", function(){
		//setRefOpenPolNo(); // comment out by bonok :: 01.08.2013
		if ((isNaN($F("opIssYear"))) || ($F("opIssYear").split(".").length>2)){
			//$("opIssYear").value = $("refOpenPolicyNo").options[$("refOpenPolicyNo").selectedIndex].getAttribute("issueYy"); // comment out by bonok :: 01.08.2013
			customShowMessageBox("Field must be of form 09.", imgMessage.ERROR, "opIssYear");
			$("opIssYear").clear();
			return false;
		}
		if (isPolExist()){
			if (parseFloat($F("paramOpIssueYy")) != parseFloat($F("opIssYear"))){
				setOpenPolicyChanged();
			}
		} /* else {
			if($F("refOpenPolicyNo") != "") {
				$("opIssYear").value		= $("refOpenPolicyNo").options[$("refOpenPolicyNo").selectedIndex].getAttribute("issueYy");
			}
		} */ // comment out by bonok :: 01.08.2013
		setPaddedFields();
	});

	$("opPolSeqNo").observe("change", function(){
		//setRefOpenPolNo(); // comment out by bonok :: 01.08.2013
		if ((isNaN($F("opPolSeqNo"))) || ($F("opPolSeqNo").split(".").length>2)){
			//$("opPolSeqNo").value = $("refOpenPolicyNo").options[$("refOpenPolicyNo").selectedIndex].getAttribute("polSeqNo"); // comment out by bonok :: 01.08.2013
			customShowMessageBox("Field must be of form 0999999.", imgMessage.ERROR, "opPolSeqNo");
			$("opPolSeqNo").clear();
			return false;
		}
		if (isPolExist()){
			if (parseFloat($F("paramOpPolseqNo")) != parseFloat($F("opPolSeqNo"))){
				setOpenPolicyChanged();
			}
		} /* else {
			if($F("refOpenPolicyNo") != "") { 
				$("opPolSeqNo").value		= $("refOpenPolicyNo").options[$("refOpenPolicyNo").selectedIndex].getAttribute("polSeqNo");
			}
		} */ // comment out by bonok :: 01.08.2013
		setPaddedFields();
	});

	$("opRenewNo").observe("change", function(){
		//setRefOpenPolNo(); // comment out by bonok :: 01.08.2013
		if ((isNaN($F("opRenewNo"))) || ($F("opRenewNo").split(".").length>2)){
			//$("opRenewNo").value = $("refOpenPolicyNo").options[$("refOpenPolicyNo").selectedIndex].getAttribute("renewNo"); // comment out by bonok :: 01.08.2013
			customShowMessageBox("Field must be of form 09.", imgMessage.ERROR, "opRenewNo");
			$("opRenewNo").clear();
			return false;
		}
		if (isPolExist()){
			setOpenPolicyChanged();
		} /* else {
			if($F("refOpenPolicyNo") != "") {
				$("opRenewNo").value		= $("refOpenPolicyNo").options[$("refOpenPolicyNo").selectedIndex].getAttribute("renewNo");
			}
		} */ // comment out by bonok :: 01.08.2013
	});

	$("declaration").observe("change", function(){
		setOpenPolicyChanged();
	});

	function setOpenPolicyChanged(){
		$("openPolicyChanged").value = "Y";
		if (($F("opSublineCd")!="")
				&&($F("opIssCd")!="")
				&&($F("opIssYear")!="")
				&&($F("opPolSeqNo")!="")
				&&($F("opRenewNo")!="")){
			objUW.hidObjGIPIS002.gipiWOpenPolicyExist = "1";
		}else{
			objUW.hidObjGIPIS002.gipiWOpenPolicyExist = "0";
		}	
	}

	function setPaddedFields(){
		$("opIssYear").value = $F("opIssYear") == "" ? "" : parseFloat($F("opIssYear")).toPaddedString(2);
		$("opPolSeqNo").value = $F("opPolSeqNo") == "" ? "" : parseFloat($F("opPolSeqNo")).toPaddedString(7);
		$("opRenewNo").value = $F("opRenewNo") == "" ? "" : parseFloat($F("opRenewNo")).toPaddedString(2);
	}

	function selectRefOpenPolicyNo(){
		var refOpenPolNo 						= $("refOpenPolicyNo");
		var index = 0;
		for (var j=0; j<refOpenPolNo.length; j++){
			if (($("opLineCd").value == $("refOpenPolicyNo").options[j].getAttribute("lineCd"))
					&&($("opSublineCd").value == $("refOpenPolicyNo").options[j].getAttribute("sublineCd"))
					&&($("opIssCd").value == $("refOpenPolicyNo").options[j].getAttribute("issCd"))
					&&($("opIssYear").value == $("refOpenPolicyNo").options[j].getAttribute("issueYy"))
					&&($("opPolSeqNo").value == $("refOpenPolicyNo").options[j].getAttribute("polSeqNo"))
					&&($("opRenewNo").value == $("refOpenPolicyNo").options[j].getAttribute("renewNo"))){
				index = j;
			}
		}
		$("refOpenPolicyNo").selectedIndex 		= index;
	}

	function setRefOpenPolNo(){
		//var refOpenPolNo = ${openPolicy.refOpenPolNo}<c:if test="${empty openPolicy.refOpenPolNo}">""</c:if>;
		/*var refOpenPolNo = $F("refOpenPolNo");
		if (("" != refOpenPolNo) && (null != refOpenPolNo)){ 
			$("refOpenPolicyNo").update($("refOpenPolicyNo").innerHTML + "<option lineCd='"+$F("globalLineCd")+"' sublineCd='"+$F("opSublineCd")+"'"
					+" issCd='"+$F("opIssCd")+"' issueYy='"+$F("opIssYear")+"'"
					+" polSeqNo='"+$F("opPolSeqNo")+"' renewNo='"+$F("opRenewNo")+"'"
					+" inceptDate='' expiryDate=''>"+refOpenPolNo+"</option>");
			$("refOpenPolicyNo").value = refOpenPolNo;
		} else {
			selectRefOpenPolicyNo();
		}*/ // replaced by: Nica 08.22.2012
		
		var index = 0;
		
		var refOpenPolicyNo = $("refOpenPolicyNo");
		for (var j=0; j<refOpenPolicyNo.length; j++){
			if (($("opLineCd").value == $("refOpenPolicyNo").options[j].getAttribute("lineCd"))
					&&($("opSublineCd").value == $("refOpenPolicyNo").options[j].getAttribute("sublineCd"))
					&&($("opIssCd").value == $("refOpenPolicyNo").options[j].getAttribute("issCd"))
					&&($("opIssYear").value == $("refOpenPolicyNo").options[j].getAttribute("issueYy"))
					&&(removeLeadingZero($("opPolSeqNo").value) == removeLeadingZero($("refOpenPolicyNo").options[j].getAttribute("polSeqNo")))
					&&(removeLeadingZero($("opRenewNo").value) == removeLeadingZero($("refOpenPolicyNo").options[j].getAttribute("renewNo")))){
				index = j;
				break;
			}
		}
		$("refOpenPolicyNo").selectedIndex = index;
	}

	/*$("btnCancelOpenPolicy").observe("click", function ()	{
		Modalbox.hide();		
	});*/

	function isPolExist(){
		try{
			var result = false;
			if (("" != $F("opSublineCd")) 
					&& ("" != $F("opIssCd")) 
					&& ("" != $F("opIssYear")) 
					&& ("" != $F("opPolSeqNo")) 
					&& ("" != $F("opRenewNo"))){
				new Ajax.Request(contextPath+"/GIPIWOpenPolicyController?action=isPolExist",{
					method:"POST",
					evalScripts:true,
					asynchronous: false,
					parameters: {
						globalLineCd: $F("globalLineCd"),
						opSublineCd: $F("opSublineCd"),
						opIssCd: $F("opIssCd"),
						opIssYear: $F("opIssYear"),
						opPolSeqNo: $F("opPolSeqNo"),
						opRenewNo: $F("opRenewNo")
					},
					onComplete: function (response) {
						if (checkErrorOnResponse(response)){
							if ("Y" == response.responseText){
								if($F("refOpenPolicyNo") == "") {
									if (($F("opSublineCd")!="")
											&&($F("opIssCd")!="")
											&&($F("opIssYear")!="")
											&&($F("opPolSeqNo")!="")
											&&($F("opRenewNo")!="")){
										new Ajax.Request(contextPath+"/GIPIWOpenPolicyController?action=validatePolExist", {
											method:"POST",
											evalScripts:true,
											asynchronous: false,
											parameters: {
												globalLineCd: $F("globalLineCd"),
												opSublineCd: $F("opSublineCd"),
												opIssCd: $F("opIssCd"),
												opIssYear: $F("opIssYear"),
												opPolSeqNo: $F("opPolSeqNo"),
												opRenewNo: $F("opRenewNo"),
												assdNo : $F("globalAssdNo")
											},
											onComplete: function (response) {
												var paramMap2 = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
												if(paramMap2.exists == "Y" && (paramMap2.message == null || paramMap2.message == "")) {
													if($F("doi") != "" && makeDate($F("doi")) < makeDate(paramMap2.inceptDate)) {
														showMessageBox("Effectivity date "+$F("doi")+" must be within "+
																paramMap2.inceptDate+" and "+paramMap2.expiryDate+".", "e");
														result = false;
														resetRequiredOpenPolicy();
													} else if ($F("doe") != "" && makeDate($F("doe")) > makeDate(paramMap2.expiryDate)) {
														showMessageBox("Expiry date "+$F("doe")+" must be within "+
																paramMap2.inceptDate+" and "+paramMap2.expiryDate+".", "e");
														result = false;
														resetRequiredOpenPolicy();
													} else {
														result = true;
														setOpenPolicyChanged();
														$("globalEffDate").value	= dateFormat(paramMap2.inceptDate,'mm-dd-yyyy');	//added by steven 9/26/2012
												 		if(nvl(objUW.hidObjGIPIS002.copyRefpolFrmOpenPol, 'Y') == 'Y'){ //added by robert SR 21901 03.28.16
															$("referencePolicyNo").value = paramMap2.refPolNo; //added by steven 9/26/2012
												 		}
												 		$("refOpenPolicyNo").value = paramMap2.refPolNo;  // bonok :: 03.25.2014 :: to populate the Ref. Polocy No. on observe of change of open policy 
												 		fireEvent($("referencePolicyNo"), "blur");//added by steven 9/26/2012
													}
													setOpenPolicyChanged();
													//$("refOpenPolicyNo").value = paramMap2.refPolNo;
													addOptToRefPolNoList(paramMap2); //added by d.alcantara, 12-09-2011
												} else if (paramMap2.message != null) {
													result = false;
													showMessageBox(paramMap2.message, imgMessage.ERROR);
													resetRequiredOpenPolicy();
												} else {
													result = false;
													showMessageBox("No such policy exist.", imgMessage.ERROR);
													resetRequiredOpenPolicy();
												}
												setOpenPolicyChanged();
											}
										});
									} else {
										result = true;
										setOpenPolicyChanged();
									}
								} else {
									result = true;
									setOpenPolicyChanged();
								}
							} else {
								result = false;
								showMessageBox("No such policy exist.", imgMessage.ERROR);
								resetRequiredOpenPolicy();
							} 
						}
					}
				});
			}
			return result;
		}catch(e){
			showErrorMessage("isPolExist", e);	
		}	
	}
	
	//added by d.alcantara, 12-09-2011
	function addOptToRefPolNoList(param) {
		var opt = "";
		var refList = $("refOpenPolicyNo");
		var exists = false;
		for(var i=0; i<refList.options.length; i++) {
			if(param != null && refList.options[i].value == param.refPolNo) {
				exists = true;
				refList.selectedIndex = i;
				return;
			}
		}
		
		if(!exists) {
			opt = '<option value="'+param.refPolNo+'" lineCd="'+param.lineCd+'" sublineCd="'+param.opSublineCd+
					'" issCd="'+param.opIssueYy+'" issueYy="'+param.opIssueYy+'" polSeqNo="'+param.opPolSeqNo+
					'" renewNo="'+param.opRenewNo+'" inceptDate="'+param.inceptDate+'" expiryDate="'+param.expiryDate+
					'">'+param.refPolNo+'</option>';
			refList.insert({bottom: opt});	
			addOptToRefPolNoList(null);
		}
		
		if(param==null) return;
	}

	/*$("btnSaveOpenPolicy").observe("click", function ()	{
		if (validateOpenPolicyBeforeSave()){
			if (validateParDetailRecords()){
				if ($F("openPolicyChanged") == "Y"){
					new Ajax.Request(contextPath+"/GIPIWOpenPolicyController?action=validatePolicyDate",{
						method:"POST",
						evalScripts:true,
						asynchronous: true,
						parameters: {
							globalLineCd: $F("globalLineCd"),
							opSublineCd: $F("opSublineCd"),
							opIssCd: $F("opIssCd"),
							opIssYear: $F("opIssYear"),
							opPolSeqNo: $F("opPolSeqNo"),
							opRenewNo: $F("opRenewNo"),
							globalEffDate: $F("globalEffDate"),
							globalExpiryDate: $F("globalExpiryDate")
						},
						//onCreate: showNotice("Saving open policy, please wait..."),
						onComplete: function (response) {
							var msg = response.responseText;
							var a = msg.split(",");
							var message1 = a[0];
							var message2 = a[1];
							var messageCode = a[2];
							if ("2" == messageCode){
								showMessageBox(message1, imgMessage.INFO);
							} else if ("3" == messageCode){
								if ("" != message1){
									message3 = message2;
									showWaitingMessageBox(message1, imgMessage.INFO, showMessage3);
								} else {
									showMessage3();
								}
								
							} else if ("1" == messageCode){ 
								showWaitingMessageBox(message1, imgMessage.INFO, saveOpenPolicy);
							} else {
								saveOpenPolicy();
							}
						}
					});
				}
			}
		}
	});*/ 

	function showMessage3(){
		showMessageBox(message3, imgMessage.INFO);
	}

	function saveOpenPolicy(){
		new Ajax.Request(contextPath+"/GIPIWOpenPolicyController?action=saveOpenPolicy&globalParId="+$F("globalParId")
				+"&globalLineCd="+$F("globalLineCd")+"&globalEffDate="+$F("globalEffDate"),{
			method:"POST",
			evalScripts:true,
			asynchronous: true,
			postBody: Form.serialize("basicInformationForm"),
			onCreate: showNotice("Saving open policy, please wait..."),
			onComplete: function (response) {
				if (checkErrorOnResponse(response)){
					hideNotice("");
					objUW.hidObjGIPIS002.gipiWOpenPolicyExist = "1"; // add by jerome para pag save nya madetect sa basic info
					showMessageBox(response.responseText, imgMessage.SUCCESS);
				}
			}
		});
	}

	function validateParDetailRecords(){
		var result = true;
		if (($F("paramOpSublineCd") == $F("opSublineCd")) 
				&& ($F("paramOpIssCd") == $F("opIssCd")) 
				&& (parseFloat($F("paramOpIssueYy")) == parseFloat($F("opIssYear"))) 
				&& (parseFloat($F("paramOpPolseqNo")) == parseFloat($F("opPolSeqNo"))) 
				&& ($F("paramOpRenewNo") == $F("opRenewNo"))){
			//none
		} else {
			if ("Y" == $F("gipiWItemExist")){
				$("opSublineCd").value = $F("paramOpSublineCd");
				$("opIssCd").value = $F("paramOpIssCd");
				$("opIssYear").value = $F("paramOpIssueYy");
				$("opPolSeqNo").value = $F("paramOpPolseqNo");
				$("opRenewNo").value = $F("paramOpRenewNo");
				$("declaration").value = $F("paramDecltnNo");
				setPaddedFields();
				result = false;
				showMessageBox("The open policy referred to by this PAR cannot be updated, for detail records already exist.  However, you may choose to delete this PAR and recreate it with the necessary changes.", imgMessage.ERROR);
			}
		}
		return result;
	}

	function validateOpenPolicyBeforeSave(){
		var result = true;
		if (($F("opSublineCd")=="")
				||($F("opIssCd")=="")
				||($F("opIssYear")=="")
				||($F("opPolSeqNo")=="")
				||($F("opRenewNo")=="")){
			result = false;
			$("opLineCd").focus();
			showMessageBox("An open policy must be entered.", imgMessage.ERROR);
		} /*else if ($F("declaration")==""){
			result = false;
			$("declaration").focus();
			showMessageBox("Please enter a declaration number.");
		}*/
		return result;
	}

	function resetRequiredOpenPolicy() {
		$("opSublineCd").value		= $("refOpenPolicyNo").options[$("refOpenPolicyNo").selectedIndex].getAttribute("sublineCd");
		$("opIssCd").value			= $("refOpenPolicyNo").options[$("refOpenPolicyNo").selectedIndex].getAttribute("issCd");
		$("opIssYear").value		= $("refOpenPolicyNo").options[$("refOpenPolicyNo").selectedIndex].getAttribute("issueYy");
		$("opPolSeqNo").value		= $("refOpenPolicyNo").options[$("refOpenPolicyNo").selectedIndex].getAttribute("polSeqNo");
		$("opRenewNo").value		= $("refOpenPolicyNo").options[$("refOpenPolicyNo").selectedIndex].getAttribute("renewNo");
		setOpenPolicyChanged();
	}
	
	$("groOpenPolicy").observe("click", function(){
		var label = $("groOpenPolicy");
		label.innerHTML = label.innerHTML == "Hide" ? "Show" : "Hide";
		var infoDiv = label.up("div", 1).next().readAttribute("id");
		Effect.toggle(infoDiv, "blind", {duration: .3});			
	});
	
	function showOpenPolicyLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {action: "getPolbasicForOpenPolicyLOV",
								lineCd: $F("globalLineCd"),
								sublineCd: $F("opSublineCd"), //June Mark SR5767 [11.14.16]
								issCd: $F("opIssCd"),
								issYear: $F("opIssYear"),
								polSeqNo: $F("opPolSeqNo"),
								renewNo: $F("opRenewNo"),  //End SR5767
								assdNo: $F("globalAssdNo"),
								inceptDate: $F("doi"),
								expiryDate: $F("doe")
							   },
				title: "Open Policy",
				width: 780,
				height: 380,
				columnModel:[
				             	{	id : "lineCd",
									title: "Line Code",
									width: '75px'
								},
								{	id : "sublineCd",
									title: "Subline Code",
									width: '90px'
								},
								{	id : "issCd",
									title: "Issue Code",
									width: '80px'
								},
								{	id : "issueYy",
									title: "Issue Year",
									width: '75px',
									renderer : function(value){
					                	return formatNumberDigits(value,2);
						   			}
								},
								{	id : "polSeqNo",
									title: "Pol. Seq. No",
									width: '85px',
									renderer : function(value){
					                	return formatNumberDigits(value,7);
						   			}
								},
								{	id : "renewNo",
									title: "Renew No.",
									width: '75px',
									renderer : function(value){
					                	return formatNumberDigits(value,2);
						   			}
								},
								{	id : "refPolNo",
									title: "Reference Pol. No.",
									width: '120px'
								},
								{	id : "inceptDate",
									title: "Incept Date",
									width: '80px'
								},
								{	id : "expiryDate",
									title: "Expiry Date",
									width: '80px'
								}
							],
				draggable: true,
				onSelect : function(row){
					if(row != undefined) {
						$("opSublineCd").value		= row.sublineCd;
						$("opIssCd").value			= row.issCd;
						$("opIssYear").value		= row.issueYy;
						$("opPolSeqNo").value		= formatNumberDigits(row.polSeqNo, 7);
						$("opRenewNo").value		= formatNumberDigits(row.renewNo, 2);
						fireEvent($("opSublineCd"), "change");
						$("refOpenPolicyNo").value  = row.refPolNo; // bonok :: 01.07.2013
					}
				}
			});
		}catch(e){
			showErrorMessage("showOpenPolicyLOV",e);
		}
	}
	
	$("searchOpenPolicy").observe("click", function(){
		if ("Y" == $F("gipiWItemExist")) {
			$("opSublineCd").value = $F("paramOpSublineCd");
			$("opIssCd").value = $F("paramOpIssCd");
			$("opIssYear").value = $F("paramOpIssueYy");
			$("opPolSeqNo").value = $F("paramOpPolseqNo");
			$("opRenewNo").value = $F("paramOpRenewNo");
			$("declaration").value = $F("paramDecltnNo");
			setPaddedFields();
			result = false;
			/* showWaitingMessageBox(
					"The open policy referred to by this PAR cannot be updated, for detail records already exist.  However, you may choose to delete this PAR and recreate it with the necessary changes.",
					imgMessage.ERROR, setRefOpenPolNo); */ // bonok :: 01.08.2013
			showMessageBox(
					"The open policy referred to by this PAR cannot be updated, for detail records already exist.  However, you may choose to delete this PAR and recreate it with the necessary changes.",
					imgMessage.ERROR);
					
		}else{
			showOpenPolicyLOV();
		}
	});
	
	$("searchOpenPolicy1").observe("click", function(){ // bonok :: 01.08.2013
		fireEvent($("searchOpenPolicy"), "click");
	});
	
	$("groOpenPolicy").click();
	
	function setRefPolNo2(){
		new Ajax.Request(contextPath+"/GIPIWOpenPolicyController?action=getRefPolNo2&globalLineCd="+$F("opLineCd") 
			+ "&opSublineCd=" + $F("opSublineCd") + "&opIssCd=" + $F("opIssCd") + "&opIssYear=" + $F("opIssYear") 
			+ "&opPolSeqNo=" + $F("opPolSeqNo") + "&opRenewNo=" + $F("opRenewNo"),{
			method:"POST",
			evalScripts:true,
			asynchronous: true,
			onComplete: function (response) {
				if (checkErrorOnResponse(response)){
					$("refOpenPolicyNo").value = response.responseText;
				}
			}
		});
	}
	
	if($F("opSublineCd") != ""){ // bonok :: 01.07.2013
		setRefPolNo2();	
	}
</script>