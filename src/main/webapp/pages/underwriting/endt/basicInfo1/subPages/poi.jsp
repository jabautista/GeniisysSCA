<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="outerDiv" name="outerDiv" style="float:left">
	<div id="innerDiv" name="innerDiv">
   		<label>Period of Insurance</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" style="margin-left: 5px;">Hide</label>
   		</span>
   	</div>
</div>
<div class="sectionDiv" id="periodOfInsuranceDiv" style="float:left; width: 100%;"  changeTagAttr="true">
	<div id="periodOfInsurance" style="float:left; margin:10px 0px 5px 10px;">
		<table align="center" cellspacing="1" style="width:100%;" border="0">
			<tr>
				<td class="rightAligned" >Inception Date </td>
				   <td class="leftAligned" >
				    <div id="doiDiv" name="doiDiv" style="width: 226px;" class="required withIconDiv">
				    	<input style="width: 202px; border: none;" id="paramDoi" name="paramDoi" type="hidden" value="<fmt:formatDate value="${gipiWPolbas.inceptDate }" pattern="MM-dd-yyyy" />" readonly="readonly"/>
				    	<input style="width: 202px;" id="doi" name="doi" type="text" value="<fmt:formatDate value="${gipiWPolbas.inceptDate }" pattern="MM-dd-yyyy" />" readonly="readonly" class="required withIcon" />
				    	<img id="hrefDoiDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"	alt="Inception Date" />			    	    	
					</div>
				    <input type="checkbox" id="inceptTag" name="inceptTag" value="Y" 
				    <c:if test="${gipiWPolbas.inceptTag == 'Y' }">
							checked="checked"
					</c:if>/> TBA
				</td>
			</tr>		
			<tr id="rowEndtEffDate">
				<td class="rightAligned">Endt Effectivity Date</td>
				<td class="leftAligned">
					<div id="endtEffDateDiv" name="endtEffDateDiv" style="float: left; border: solid 1px gray; width: 226px; height: 21px; margin-right: 3px;" class="required">
						<input style="width: 198px; border: none;" id="paramEndtEffDate" name="paramEndtEffDate" type="hidden" value="<fmt:formatDate value="${gipiWPolbas.effDate}" pattern="MM-dd-yyyy" />" readonly="readonly" />
						<input style="width: 198px; border: none;" id="endtEffDate" name="endtEffDate" type="text" value="<fmt:formatDate value="${gipiWPolbas.effDate}" pattern="MM-dd-yyyy" />" readonly="readonly" class="required" />
						<img id="hrefEndtEffDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Endt. Effectivity Date" />
					</div>
					<!-- <input type="checkbox" id="endtEffDateTag" name="endtEffDateTag" value="Y" /> TBA -->
				</td>
			</tr>		
			<tr>	
				<td class="rightAligned" id="conditionText">Condition </td>
				<td class="leftAligned">
					<div id="conditionDiv">
						<input type="hidden" id="paramProrateFlag" name="paramProrateFlag" value="${gipiWPolbas.prorateFlag }" />
						<select id="prorateFlag" name="prorateFlag" style="width: 228px; float: left;" class="required">
								<option value="1" <c:if test="${gipiWPolbas.prorateFlag eq 1}">selected="selected"</c:if> >Pro-rate</option>
								<option value="2" <c:if test="${gipiWPolbas.prorateFlag eq 2 or empty gipiWPolbas.prorateFlag}">selected="selected"</c:if> >Straight</option>
								<option value="3" <c:if test="${gipiWPolbas.prorateFlag eq 3}">selected="selected"</c:if> >Short Rate</option>
						</select>
						
						<span id="prorateSelected" name="prorateSelected" style="display: none;  float: left;">
							<input type="hidden" style="width: 37px;" id="paramNoOfDays" name="paramNoOfDays" value="" />
							<input class="required integerNoNegativeUnformattedNoComma" type="text" style="width: 37px;  float: left; margin-left:2px; margin-top: 0px;" id="noOfDays" name="noOfDays" value="" maxlength="5" errorMsg="Entered pro-rate number of days is invalid. Valid value is from 0 to 99999."/> 
							<select class="required" id="compSw" name="compSw" style="width: 80px; float: left; margin-left:2px; margin-top: 0px;" >
								<option value="Y" <c:if test="${gipiWPolbas.compSw eq 'Y'}">selected="selected"</c:if> >+1 day</option>
								<option value="M" <c:if test="${gipiWPolbas.compSw eq 'M'}">selected="selected"</c:if> >-1 day</option>
								<option value="N" <c:if test="${gipiWPolbas.compSw eq 'N' or empty gipiWPolbas.compSw}">selected="selected"</c:if> >Ordinary</option>
							</select>
						</span>
						<span id="shortRateSelected" name="shortRateSelected" style="display: none;">
						    <input type="hidden" id="paramShortRatePercent" name="paramShortRatePercent" class="moneyRate" style="width: 90px;" maxlength="13" value="${gipiWPolbas.shortRtPercent }" />
							<input type="text" id="shortRatePercent" name="shortRatePercent" class="moneyRate required" style="width: 90px;  float: left; margin-left:2px; margin-top: 0px;" maxlength="13" value="${gipiWPolbas.shortRtPercent }" />
						</span>			
					</div>	
				</td>
			</tr>
			<tr>	
				<td class="rightAligned">Booking Date </td>
				<td class="leftAligned">
					<div>
						<div style="float:left; margin-right:2px;">
							<input type="hidden" id="paramBookingYear" name="paramBookingYear" style="width:35px; height:15px;" value="${gipiWPolbas.bookingYear }" maxlength="4" />
							<input type="hidden" id="paramBookingMth" name="paramBookingYear" style="width:35px; height:15px;" value="${gipiWPolbas.bookingMth }" />
							<input type="hidden" id="bookingYear" name="bookingYear" style="width:35px; height:15px;" value="${gipiWPolbas.bookingYear }" maxlength="4" />
							<input type="hidden" id="bookingMth" name="bookingMth" style="width:35px; height:15px;" value="${gipiWPolbas.bookingMth }" />
						</div>
						<div style="float:left;">
							<input type="hidden" id="bookingDateExist" name="bookingDateExist" value="
								<c:forEach var="d" items="${bookingMonthListing}">
									<c:if test="${gipiWPolbas.bookingYear == d.bookingYear and gipiWPolbas.bookingMth == d.bookingMonth}">1</c:if>
								</c:forEach>
							" />
							<select id="bookingMonth" name="bookingMonth" style="width: 228px;" class="required">
							<option bookingYear="" bookingMth="" value=""></option>
							<option id="opt2" bookingYear="${gipiWPolbas.bookingYear }" bookingMth="${gipiWPolbas.bookingMth }" value="${gipiWPolbas.bookingMth }" selected="selected" ><c:if test="${!empty gipiWPolbas.bookingYear }">${gipiWPolbas.bookingYear } - ${gipiWPolbas.bookingMth }</c:if></option>
							<c:forEach var="d" items="${bookingMonthListing}">
								<option bookingYear="${d.bookingYear  }" bookingMth="${d.bookingMonth}" value="${d.bookingMonthNum}" 
								<c:if test="${gipiWPolbas.bookingYear == d.bookingYear and gipiWPolbas.bookingMth == d.bookingMonth}">
										selected="selected"
								</c:if>
								>${d.bookingYear  } - ${d.bookingMonth}</option>
							</c:forEach>
							</select>
						</div>
					</div>
				</td>
			</tr>
		</table>
	</div>
	<div id="periodOfInsurance" style="float:right; margin:10px 10px 5px 0px; ">
		<table align="center" cellspacing="1" style="width:100%" border="0">
		<tr>
			<td class="rightAligned" >Expiry Date </td>
			<td class="leftAligned" style="width: 290px;">
			<input style="width: 198px; border: none;" id="defaultDoe" name="defaultDoe" type="hidden" value="<fmt:formatDate value="${gipiWPolbas.expiryDate }" pattern="MM-dd-yyyy" />" readonly="readonly" class="required"/>			    
			    <div id="doeDiv" name="doeDiv" class="required withIconDiv" style="float:left; border: solid 1px gray; width: 226px; height: 21px; margin-right:3px;" >
			    	<input style="width: 202px; border: none;" id="paramDoe" name="paramDoe" type="hidden" value="<fmt:formatDate value="${gipiWPolbas.expiryDate }" pattern="MM-dd-yyyy" />" readonly="readonly" class="required"/>
			    	<input style="width: 202px;" id="doe" name="doe" type="text" value="<fmt:formatDate value="${gipiWPolbas.expiryDate }" pattern="MM-dd-yyyy" />" readonly="readonly" class="required withIcon" />
			    	<img id="hrefDoeDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"	alt="Expiry Date" />			    		    	
			    </div>
		    	<input type="checkbox" id="expiryTag" name="expiryTag" value="Y"
		    	<c:if test="${gipiWPolbas.expiryTag == 'Y' }">
						checked="checked"
				</c:if>/> TBA
		    </td>
		</tr>
		<tr id="rowEndtExpDate">
			<td class="rightAligned" style="width: 30%;" >Endt Expiry Date</td>
			<td class="leftAligned">
				<input style="width: 198px; border: none;" id="defaultEndtExpDate" name="defaultEndtExpDate" type="hidden" value="<fmt:formatDate value="${gipiWPolbas.endtExpiryDate}" pattern="MM-dd-yyyy" />" readonly="readonly" class="required" />
				<div id="endtExpDateDiv" name="endtExpDateDiv" style="float: left; border: solid 1px gray; width: 226px; height: 21px; margin-right: 3px;" class="required">
					<input style="width: 198px; border: none;" id="paramEndtExpDate" type="hidden" value="<fmt:formatDate value="${gipiWPolbas.endtExpiryDate}" pattern="MM-dd-yyyy" />" readonly="readonly" class="required" />
					<input style="width: 198px; border: none;" id="endtExpDate" name="endtExpDate" type="text" value="<fmt:formatDate value="${gipiWPolbas.endtExpiryDate}" pattern="MM-dd-yyyy" />" readonly="readonly" class="required" />
					<img id="hrefEndtExpDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Endt. Expiry Date" />
				</div>
				<input type="checkbox" id="endtExpDateTag" name="endtExpDateTag" value="Y" <c:if test="${gipiWPolbas.endtExpiryTag == 'Y' }">checked="checked"</c:if>/> TBA
			</td>
		</tr>
		<tr id="rowCoInsurance">	
			<td class="rightAligned">Co-Insurance </td>
			<td class="leftAligned">
			<input type="hidden" id="paramCoInsurance" name="paramCoInsurance" value="${gipiWPolbas.coInsuranceSw }" />
				<select id="coIns" name="coIns" style="width: 228px;" class="required" >
					<option value="2" <c:if test="${gipiWPolbas.coInsuranceSw eq 2}">selected="selected"</c:if>	>Lead Policy</option>
					<option value="1" <c:if test="${gipiWPolbas.coInsuranceSw eq 1 or empty gipiWPolbas.coInsuranceSw}">selected="selected"</c:if>	>Non-Co-Insurance</option>
					<option value="3" <c:if test="${gipiWPolbas.coInsuranceSw eq 3}">selected="selected"</c:if>	>Non-Lead Policy</option>
				</select>
			</td>
		</tr>		
		<tr>	
			<td class="rightAligned" id="takeUpTermLabel">Take-Up Term Type </td>
			<td class="leftAligned">
				<input type="hidden" id="paramTakeupTermType" name="paramTakeupTermType" value="${gipiWPolbas.takeupTerm }" />
				<select id="takeupTermType" name="takeupTermType" style="width: 228px;" class="required">
					<c:forEach var="t" items="${takeupTermListing}">
							<option value="${t.takeupTerm}" 
							<c:if test="${gipiWPolbas.takeupTerm == t.takeupTerm}">
									selected="selected"
							</c:if>
							>${fn:escapeXml(t.takeupTermDesc)}</option>
					</c:forEach>
				</select>
			</td>
		</tr>
		</table>
	</div>
</div>
<script type="text/javascript">
try{	
	var tempNoOfDays = "";
	objUW.GIPIS031.variables.varOldInceptDate = $F("paramDoi");
	objUW.GIPIS031.variables.varOldExpiryDate = $F("paramDoe");
	var prevShortRate = $("shortRatePercent").value;//edgar 10/13/2014
	var vars = JSON.parse('${vars}'.replace(/\\/g, '\\\\')); //added by June Mark SR-23166 [12.09.16]

	if(nvl(objUW.hidObjGIPIS002.updateBooking, "Y") == "N"){
		$("bookingMonth").disable(); // added bY: Nica 05.10.2012 - Per Ms VJ, booking month LOV should be disabled if UPDATE_BOOKING is equal to N.
	}
	
	//added edgar 10/10/2014 to check for posted binders
	function checkPostedBinder(){ 
		var vExists = false;	
		new Ajax.Request(contextPath+"/GIPIWinvoiceController",{
				parameters:{
					action: "checkForPostedBinders",
					parId : objUW.GIPIS031.gipiParList.parId
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						if(response.responseText == 'Y'){
							vExists = true;
						}else {
							vExists = false;
						}
					}
				}
			});
		return vExists;
	}
	
	$("issueDate").observe("blur", function(){
		new Ajax.Request(contextPath + "/GIPIParInformationController?action=validateIssueDate01", {
			method : "POST",
			parameters : {
				parId : objUW.GIPIS031.gipiParList.parId,
				lineCd : objUW.GIPIS031.gipiWPolbas.lineCd,
				sublineCd : objUW.GIPIS031.gipiWPolbas.sublineCd,
				issCd : objUW.GIPIS031.gipiWPolbas.issCd,
				issueYy : objUW.GIPIS031.gipiWPolbas.issueYy,
				polSeqNo : objUW.GIPIS031.gipiWPolbas.polSeqNo,
				renewNo : objUW.GIPIS031.gipiWPolbas.renewNo,
				parVarVDate : objUW.GIPIS031.parameters.paramVarVDate,
				issueDate : $F("issueDate"),
				effDate : $F("endtEffDate")
			},
			onCompleter : function(response){
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
					
					if(obj.message != null){
						customShowMessageBox(obj.message, imgMessage[obj.messageType], "issueDate");
						return false;
					}else{
						objUW.GIPIS031.parameters.paramVarIDate = obj.parVarIDate;
						for(var i=0, length=$("bookingMonth").options.length; i < length; i++){
							if ($("bookingMonth").options[i].getAttribute("bookingMth") == obj.bookingMth 
							    && $("bookingMonth").options[i].getAttribute("bookingYear") == obj.bookingYear){
								$("bookingMonth").selectedIndex = i;
								$("bookingYear").value = obj.bookingYear;
							 	$("bookingMth").value = obj.bookingMth;
							 	break;
							}	
						}
					}
				}
			}
		});
	});
	
	$("hrefDoiDate").observe("click", function () {
		if(checkPostedBinder()){ //added edgar 10/10/2014 to check for posted binder
			showWaitingMessageBox("You cannot update Inception Date. PAR has posted binder.", imgMessage.ERROR, 
					function(){
								changeTag = 0;
							  });
			return false;
		}
		objUW.GIPIS031.variables.varVEffOldDte = nvl($F("endtEffDate"), $F("doi"));		
		scwShow($('doi'),this, null);			
	});
	
	$("doi").observe("blur", function(){
		if($("hrefDoiDate").next("img",0) == undefined){ //robert 11.14.2012
			if(objUW.GIPIS031.variables.varVEffOldDte != $F("doi")){
				// step 2
				function step2(){
					try{
						new Ajax.Request(contextPath + "/GIPIParInformationController?action=validateInceptDate02", {
							method : "POST",
							parameters : {
								parId : objUW.GIPIS031.gipiParList.parId,
								lineCd : objUW.GIPIS031.gipiWPolbas.lineCd,
								sublineCd : objUW.GIPIS031.gipiWPolbas.sublineCd,
								issCd : objUW.GIPIS031.gipiWPolbas.issCd,
								issueYy : objUW.GIPIS031.gipiWPolbas.issueYy,
								polSeqNo : objUW.GIPIS031.gipiWPolbas.polSeqNo,
								renewNo : objUW.GIPIS031.gipiWPolbas.renewNo,
								effDate : $F("endtEffDate"),
								expiryDate : $F("doe"),
								inceptDate : $F("doi")
							},
							onComplete : function(response){
								if(checkErrorOnResponse(response)){
									var obj = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
									if(obj.message != null){	//modified by Gzelle 01132015
										showWaitingMessageBox("Inception date should not be later than the effectivity date of the Endorsement."/*obj.message*/ 
																, imgMessage.ERROR, function(){
											if (obj.inceptDate != null) {	//modified by Gzelle 01092015
												$("doi").value = dateFormat(obj.inceptDate, "mm-dd-yyyy");
											} else {
												$("doi").value = objUW.GIPIS031.variables.varVEffOldDte;
											}
											$("doi").focus();
										});
									}
								}
							}
						});
					}catch(e){
						showErrorMessage("validateInceptDate02", e);
					}
				}
				
				// step 1
				new Ajax.Request(contextPath + "/GIPIParInformationController?action=validateInceptDate01", {
					method : "POST",
					parameters : {
						parId : objUW.GIPIS031.gipiParList.parId,
						lineCd : objUW.GIPIS031.gipiWPolbas.lineCd,
						sublineCd : objUW.GIPIS031.gipiWPolbas.sublineCd,
						inceptDate : $F("doi")
					},				
					onComplete : function(response){
						if(checkErrorOnResponse(response)){
							var obj = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
							if(obj.message != null){
								showWaitingMessageBox(obj.message, imgMessage[obj.messageType], step2);
							}else{
								step2();
							}
						}
					}
				});
			}
		}
	});
	
	$("hrefDoeDate").observe("click", function () {
		if(checkPostedBinder()){ //added edgar 10/10/2014 to check for posted binder
			showWaitingMessageBox("You cannot update Expiry Date. PAR has posted binder.", imgMessage.ERROR, 
					function(){
								changeTag = 0;
							  });
			return false;
		}
		objUW.GIPIS031.variables.varVExpOldDte = $F("doe");		
		scwShow($('doe'),this, null);				
	});
	
	$("doe").observe("blur", function(){
		if(nvl(objUW.GIPIS031.variables.varVExpOldDte, $F("doe")) != $F("doe")){
			showWaitingMessageBox("Please change due dates of the previous endorsement/policy.", imgMessage.INFO, function(){
				new Ajax.Request(contextPath + "/GIPIParInformationController?action=validateExpiryDate01", {
					method : "POST",
					parameters : {
						parId : objUW.GIPIS031.gipiParList.parId,
						lineCd : objUW.GIPIS031.gipiWPolbas.lineCd,
						sublineCd : objUW.GIPIS031.gipiWPolbas.sublineCd,
						inceptDate : $F("doi"),
						prorateFlag : $F("prorateFlag"),
						effDate : $F("endtEffDate"),
						compSw : $F("compSw"),
						expiryDate : $F("doe"),
						endtExpiryDate : $F("endtExpDate")
					},
					onComplete : function(response){
						if(checkErrorOnResponse(response)){
							var obj = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
							
							$("doe").value = dateFormat(obj.expiryDate, "mm-dd-yyyy");
							
							if(obj.message != null){																
								customShowMessageBox(obj.message, imgMessage[obj.messageType], "doe");
								$("doe").value = objUW.GIPIS031.variables.varVExpOldDte;	//added by Gzelle 01132015
								return false;
							}else if (makeDate($F("doe")) < makeDate($F("endtEffDate"))){
								customShowMessageBox("Expiry date should not be earlier than the effectivity date of the Endorsement.", imgMessage.ERROR, "doe");
								$("doe").value = objUW.GIPIS031.variables.varVExpOldDte;
								return false;
							}else{
								$("endtExpDate").value = dateFormat(obj.expiryDate, "mm-dd-yyyy");
								$("noOfDays").value = obj.prorateDays; // changed from "obj.noOfDays" -- irwin 8.22.2012
							}							
						}
					}
				});
			});			
		}
	});
	
	$("hrefEndtEffDate").observe("click", function(){
		if(checkPostedBinder()){ //added edgar 10/10/2014 to check for posted binder
			showWaitingMessageBox("You cannot update Endorsement Effectivity Date. PAR has posted binder.", imgMessage.ERROR, 
					function(){
								changeTag = 0;
							  });
			return false;
		}
		objUW.GIPIS031.variables.varVOldDateEff = $F("endtEffDate");
		objUW.GIPIS031.variables.varOldEffDate = $F("endtEffDate"); //added by steven 9/25/2012
		objUW.GIPIS031.variables.varVMplSwitch = "N";
		
		scwShow($('endtEffDate'),this, null);
	});
	
	$("endtEffDate").observe("blur", function(){
		if(changeTag == 0){
			return false;
		}
		
		if($F("endtEffDate").empty()){
			return false;
		}
		
		var sysdate = dateFormat($("dateAndTime").innerHTML, "mm-dd-yyyy");
		
		if($("prorateSw").checked && $F("prorateFlag") != "2" && nvl(objUW.GIPIS031.variables.varVOldDateEff, sysdate) != $F("endtEffDate")){
			objUW.GIPIS031.parameters.paramProrateCancelSw = "Y";			
		}
		
		if(!($("nbtPolFlag").checked)){
			function step4(){
				try{
					new Ajax.Request(contextPath + "/GIPIParInformationController?action=validateEffDate04", {
						method : "POST",
						parameters : {
							parId : objUW.GIPIS031.gipiParList.parId,
							varEffDateIn : objUW.GIPIS031.parameters.paramEffDateIn,
							inceptDate : $F("doi"),
							varOldDateEff : objUW.GIPIS031.variables.varVOldDateEff,
							prorateFlag : $F("prorateFlag"),
							endtExpiryDate : $F("endtExpDate"),
							compSw : $F("compSw"),
							effDate : $F("endtEffDate")
						},						
						onComplete : function(response){
							if(checkErrorOnResponse(response)){
								var obj4 = JSON.parse(response.responseText.replace(/\\/g,'\\\\'));
								
								$("bookingMth").value = obj4.bookingMth;
								$("bookingYear").value = obj4.bookingYear;
								$("noOfDays").value = obj4.prorateDays;
								$("endtEffDate").value = dateFormat(obj4.effDate, "mm-dd-yyyy");
								objUW.GIPIS031.gipiWPolbas.effDate = obj4.effDate;
								
								new Ajax.Request(contextPath + "/GIPIParInformationController?action=getBookingDate", {
									method : "POST",
									parameters : {
										parId : objUW.GIPIS031.gipiParList.parId,
										parVarVDate : objUW.GIPIS031.parameters.paramVarVDate,
										issueDate : $F("issueDate"),
										effDate : $F("endtEffDate")
									},									
									onComplete : function(response){
										if(checkErrorOnResponse(response)){
											var obj5 = JSON.parse(response.responseText.replace(/\\/g,'\\\\'));
											
											function updateBookingLOV(objArray){
												try{
													removeAllOptions($("bookingMonth"));
													var opt = document.createElement("option");
													opt.value = "";
													opt.text = "";
													opt.setAttribute("bookingmth", "");
													opt.setAttribute("bookingyear", "");
													$("bookingMonth").options.add(opt);
													for(var a=0; a<objArray.length; a++){
														var opt = document.createElement("option");
														opt.value = objArray[a].bookingMonthNum;
														opt.text = objArray[a].bookingYear+" - "+changeSingleAndDoubleQuotes(objArray[a].bookingMonth);
														opt.setAttribute("bookingmth", objArray[a].bookingMonth); 
														opt.setAttribute("bookingyear", objArray[a].bookingYear); 
														$("bookingMonth").options.add(opt);
													}
												} catch (e) {
													showErrorMessage("updateBookingLOV", e);
												}
											}
											
											objUW.GIPIS031.parameters.paramVarIDate = dateFormat(obj5.parVarIDate,"mm-dd-yyyy");
											
											// update booking listing
											new Ajax.Request(contextPath+"/GIPIParInformationController",{
												parameters:{
													action : "getBookingListing",
													parId : objUW.GIPIS031.gipiParList.parId,
													date : objUW.GIPIS031.parameters.paramVarIDate				
												},												
												onComplete:function(response){
													var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
													updateBookingLOV(res);
													
													for(var i=0, length=$("bookingMonth").options.length; i < length; i++){														
														if ($("bookingMonth").options[i].getAttribute("bookingMth") == obj5.bookingMth 
														    && $("bookingMonth").options[i].getAttribute("bookingYear") == obj5.bookingYear){
															$("bookingMonth").selectedIndex = i;
															$("bookingYear").value = obj5.bookingYear;
														 	$("bookingMth").value = obj5.bookingMth;
														 	break;
														}	
													}
													
													if(objUW.GIPIS031.gipiWPolbas.polFlag == 4){
														objUW.GIPIS031.parameters.paramCgBackEndt = "N";
													}
												}	
											});												
										}
									}
								});
							}
						}
					});
				}catch(e){
					showErrorMessage("validateEffDate04", e);
				}
			}
			// step 1
			new Ajax.Request(contextPath + "/GIPIParInformationController?action=validateEffDate01", {
				method : "POST",
				parameters : {
					parId : objUW.GIPIS031.gipiParList.parId,
					varOldDateEff : objUW.GIPIS031.variables.varVOldDateEff,
					lineCd : objUW.GIPIS031.gipiWPolbas.lineCd,
					sublineCd : objUW.GIPIS031.gipiWPolbas.sublineCd,
					issCd : objUW.GIPIS031.gipiWPolbas.issCd,
					issueYy : objUW.GIPIS031.gipiWPolbas.issueYy,
					polSeqNo : objUW.GIPIS031.gipiWPolbas.polSeqNo,
					renewNo : objUW.GIPIS031.gipiWPolbas.renewNo,					
					inceptDate : $F("doi"),
					varMplSw : objUW.GIPIS031.variables.varVMplSwitch,
					expiryDate : $F("doe"),
					varExpChgSw : objUW.GIPIS031.variables.varExpChgSw,
					varMaxEffDate : objUW.GIPIS031.variables.varVMaxEffDate,
					effDate : $F("endtEffDate")
				},				
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText.replace(/\\/g,'\\\\'));
						
						if(obj.message != null){	//modified by Gzelle 01132015
							showWaitingMessageBox("Inception date should not be later than the effectivity date of the Endorsement."/*obj.message*/, imgMessage[obj.messageType], function(){
								$("endtEffDate").value = objUW.GIPIS031.variables.varVOldDateEff;
								$("endtEffDate").focus();	
							});
							return false;
						}else if (Date.parse($F("endtEffDate")) > Date.parse($F("endtExpDate"))){	//added by Gzelle 01072015
							showWaitingMessageBox("Effectivity date should not be later than Endorsement Expiry date.", imgMessage.ERROR, function(){
								$("endtEffDate").value = objUW.GIPIS031.variables.varVOldDateEff;
								$("endtEffDate").focus();	
							});
							return false;
						}else{
							objUW.GIPIS031.variables.varVMplSwitch = obj.varMplSwitch;
							objUW.GIPIS031.gipiWPolbas.endtYy = obj.endtYy;
							objUW.GIPIS031.parameters.paramMaxEffDateIn = formatDateToDefaultMask(obj.maxEffDateIn);
							objUW.GIPIS031.parameters.paramEffDateIn = formatDateToDefaultMask(obj.effDateIn);
							$("endtEffDate").value = dateFormat(obj.effDate, "mm-dd-yyyy");

							// step 2
							new Ajax.Request(contextPath + "/GIPIParInformationController?action=validateEffDate02", {
								method : "POST",
								parameters : {
									parId : objUW.GIPIS031.gipiParList.parId,
									varMaxEffDate : objUW.GIPIS031.parameters.paramMaxEffDateIn,
									lineCd : objUW.GIPIS031.gipiWPolbas.lineCd,
									sublineCd : objUW.GIPIS031.gipiWPolbas.sublineCd,
									issCd : objUW.GIPIS031.gipiWPolbas.issCd,
									issueYy : objUW.GIPIS031.gipiWPolbas.issueYy,
									polSeqNo : objUW.GIPIS031.gipiWPolbas.polSeqNo,
									renewNo : objUW.GIPIS031.gipiWPolbas.renewNo,
									varOldDateEff : objUW.GIPIS031.variables.varVOldDateEff,
									expiryDate : $F("doe"),
									parSysdateSw : objUW.GIPIS031.parameters.paramSysdateSw,
									varExpiryDate : dateFormat(objUW.GIPIS031.variables.varVExpiryDate, "mm-dd-yyyy"),
									effDate : $F("endtEffDate"),
									parCgBackEndt : objUW.GIPIS031.parameters.paramCgBackEndt
								},								
								onComplete : function(response){
									if(checkErrorOnResponse(response)){
										var obj2 = JSON.parse(response.responseText.replace(/\\/g,'\\\\'));
										
										if(obj2.message != null){
											if(obj2.message != 'Part 3'){
												showMessageBox(obj2.message, imgMessage[obj2.messageType]);	
											}else{
												// step 3
												new Ajax.Request(contextPath + "/GIPIParInformationController?action=validateEffDate03", {
													method : "POST",
													parameters : {
														parId : objUW.GIPIS031.gipiParList.parId,
														parFirstEndtSw : objUW.GIPIS031.parameters.paramFirstEndtSw,
														lineCd : objUW.GIPIS031.gipiWPolbas.lineCd,
														sublineCd : objUW.GIPIS031.gipiWPolbas.sublineCd,
														issCd : objUW.GIPIS031.gipiWPolbas.issCd,
														issueYy : objUW.GIPIS031.gipiWPolbas.issueYy,
														polSeqNo : objUW.GIPIS031.gipiWPolbas.polSeqNo,
														renewNo : objUW.GIPIS031.gipiWPolbas.renewNo,
														varExpiryDate : dateFormat(objUW.GIPIS031.variables.varVExpiryDate, "mm-dd-yyyy"),
														effDate : $F("endtEffDate")
													},													
													onComplete : function(response){
														if(checkErrorOnResponse(response)){
															var obj3 = JSON.parse(response.responseText.replace(/\\/g,'\\\\'));
															
															function continueProc03(obj){
																objUW.GIPIS031.parameters.paramCgBackEndt = obj.parCgBackEndt;
																objUW.GIPIS031.parameters.paramBackEndtSw = obj.parBackEndtSw;
																objUW.GIPIS031.variables.varVExpiryDate = formatDateToDefaultMask(obj.varExpiryDate);
																$("endtEffDate").value = dateFormat(obj.effDate, "mm-dd-yyyy");
																
																//set gipi_parlist && gipi_wpolbas fields
																setInfoBasedOnEffectivityDate(obj); // added by: Nica 08.30.2012 per SR# 10214
															}
															
															if(obj3.message != null){
																if(obj3.message.include("Restricted Condition")){
																	showMessageBox(obj3.message, imgMessage[obj3.messageType]);	
																}else{
																	showWaitingMessageBox(obj3.message, obj3.messageType, function(){
																		continueProc03(obj3);
																		step4();
																	});
																}
																//added by June Mark SR-23166 [12.09.16]
																$("doe").value = dateFormat(vars.varVOldExpiryDate, "mm-dd-yyyy");
																$("endtExpDate").value = dateFormat(vars.varVOldExpiryDate, "mm-dd-yyyy");
																//end
															}else{																
																continueProc03(obj3);
																step4();
															}
														}
													}
												});
											}											
										}else{											
											objUW.GIPIS031.parameters.paramSysdateSw = obj2.parSysdateSw;
											objUW.GIPIS031.variables.varVExpiryDate = formatDateToDefaultMask(obj2.varExpiryDate);
											objUW.GIPIS031.parameters.paramCgBackEndt = obj2.parCgBackEndt;
											$("endtEffDate").value = dateFormat(obj2.effDate, "mm-dd-yyyy");
											
											//set gipi_parlist && gipi_wpolbas fields
											
											step4();
										}
									}
								}
							});
						}						
					}
				} 
			});
		}				
	});
	
	function setInfoBasedOnEffectivityDate(obj){ // added by: Nica 08.30.2012 per SR# 10214 - set information based on the new specified effectivity date
		
		if(nvl(obj.assdName, "") != "" && nvl(obj.gipiWPolbas, null) != null && nvl(obj.gipiParlist.length, 0) > 0){
			$("assuredNo").value = obj.gipiParlist[0].assdNo;
			$("assuredName").value = unescapeHTML2(obj.assdName);
			objUW.GIPIS031.gipiParList.address1 = obj.gipiParlist[0].address1;
			objUW.GIPIS031.gipiParList.address2 = obj.gipiParlist[0].address2;
			objUW.GIPIS031.gipiParList.address3 = obj.gipiParlist[0].address3;
		}
		
		if(nvl(obj.gipiWPolbas, null) != null && nvl(obj.gipiWPolbas.length, 0) > 0){
			
			$("inceptTag").checked = nvl(obj.gipiWPolbas[0].inceptTag, "N") == "Y" ? true : false;
			$("expiryTag").checked = nvl(obj.gipiWPolbas[0].expiryTag, "N") == "Y" ? true : false;
			$("endtExpDateTag").checked = nvl(obj.gipiWPolbas[0].endtExpDateTag, "N") == "Y" ? true : false;
			
			objUW.GIPIS031.gipiWPolbas.samePolNo = "N";
			objUW.GIPIS031.gipiWPolbas.foreignAccSw = nvl(obj.gipiWPolbas[0].foreignAccSw, "N");
			objUW.GIPIS031.gipiWPolbas.oldAddress1 = obj.gipiWPolbas[0].oldAddress1;
			objUW.GIPIS031.gipiWPolbas.oldAddress2 = obj.gipiWPolbas[0].oldAddress2;
			objUW.GIPIS031.gipiWPolbas.oldAddress3 = obj.gipiWPolbas[0].oldAddress3;
			//added by robert 05.20.2013 sr 13098
			$("b540AnnTsiAmt").value = obj.gipiWPolbas[0].annTsiAmt;
			$("b540AnnPremAmt").value = obj.gipiWPolbas[0].annPremAmt;
			
			$("compSw").value = obj.gipiWPolbas[0].compSw;
			$("premWarrTag").checked = nvl(obj.gipiWPolbas[0].premWarrTag, "N") == "Y" ? true : false;
			$("regularPolicy").checked = nvl(obj.gipiWPolbas[0].regPolicySw, "Y") == "Y" ? true : false;
			$("endtInformation").value = "";
			$("manualRenewNo").value = formatNumberDigits(nvl(obj.gipiWPolbas[0].manualRenewNo, 0), 2);
			$("coIns").value = nvl(obj.gipiWPolbas[0].coInsuranceSw, "1");
			$("creditingBranch").value = obj.gipiWPolbas[0].credBranch;
			
			if(obj.gipiWPolbas[0].prorateFlag == "3"){
				
			}else if(obj.gipiWPolbas[0].prorateFlag == "1"){
				
			}else{
				
			}
			
			$("generalInformation").value = "";
			$("endorseTax").value = "N";
			$("endorseTax").checked = false;
		}
	}
	
	$("hrefEndtExpDate").observe("click", function(){
		if(checkPostedBinder()){ //added edgar 10/10/2014 to check for posted binder
			showWaitingMessageBox("You cannot update Endorsement Expiry Date. PAR has posted binder.", imgMessage.ERROR, 
					function(){
								changeTag = 0;
							  });
			return false;
		}
		objUW.GIPIS031.variables.varVOldDateExp = $F("endtExpDate");
		objUW.GIPIS031.variables.varOldEndtExpiryDate = $F("endtExpDate"); //added by steven 9/25/2012
		objUW.GIPIS031.variables.varVMplSwitch = "N";
		
		scwShow($('endtExpDate'),this, null);
	});
	
	$("endtExpDate").observe("blur", function(){
		new Ajax.Request(contextPath + "/GIPIParInformationController?action=validateEndtExpiryDate01", {
			method : "POST",
			parameters : {
				parId : objUW.GIPIS031.gipiParList.parId,
				lineCd : objUW.GIPIS031.gipiWPolbas.lineCd,
				sublineCd : objUW.GIPIS031.gipiWPolbas.sublineCd,
				effDate : $F("endtEffDate"),
				expiryDate : $F("doe"),
				varOldDateExp : objUW.GIPIS031.variables.varVOldDateExp,
				compSw : $F("compSw"),
				endtExpiryDate : $F("endtExpDate"),
				varAddTime : objUW.GIPIS031.variables.varVAddTime,
				prorateFlag:$F("prorateFlag")
			},			
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
					if(obj.message != null){						
						showWaitingMessageBox(obj.message, imgMessage[obj.messageType], function(){							
							$("endtExpDate").value = formatDateToDefaultMask(obj.varOldDateExp);
						});
						return false;
					}else{
						//modified by robert 01.14.2013
						if(obj.prorateFlag == null || obj.prorateFlag == '1'){
							$("prorateFlag").value = '1';
						}else{
							$("prorateFlag").value = obj.prorateFlag;
							$("noOfDays").value = obj.prorateDays;
							//$("endtExpiryDate").value = formatDateToDefaultMask(obj.endtExpiryDate);
							$("endtExpDate").value = formatDateToDefaultMask(obj.endtExpiryDate); // bonok :: 06.23.2014
						}
						showRelatedSpan();
						objUW.GIPIS031.variables.varVMplSwitch = obj.varMplSwitch;
						objUW.GIPIS031.parameters.paramConfirmSw = obj.parConfirmSw;
						objUW.GIPIS031.variables.varVAddTime = obj.varAddTime;
					}					
				}
			}
		});
	});
	
	//==============================================	
	
	function showRelatedSpan(){			
		if ($F("prorateFlag") == "1")	{
			$("shortRateSelected").hide();
			$("shortRatePercent").hide();
			$("prorateSelected").show();
			$("noOfDays").show();
			$("noOfDays").value = objUWParList.parType == "P" ? computeNoOfDays($F("doi"),$F("doe"),$F("compSw")) : computeNoOfDays($F("endtEffDate"),$F("endtExpDate"),$F("compSw"));
		    tempNoOfDays = objUWParList.parType == "P" ? computeNoOfDays($F("doi"),$F("doe"),$F("compSw")) : computeNoOfDays($F("endtEffDate"),$F("endtExpDate"),$F("compSw"));
		    $("shortRatePercent").value  = ""; // marco - 11.22.2012
		} else if ($F("prorateFlag") == "3") {	
			$("prorateSelected").hide();
			$("shortRateSelected").show();
			$("shortRatePercent").show();
			$("noOfDays").hide();
			$("noOfDays").value = "";					
		} else {		
			$("shortRateSelected").hide();
			$("shortRatePercent").hide();
			$("prorateSelected").hide();
			$("noOfDays").hide();
			$("noOfDays").value = "";
			$("shortRatePercent").value  = ""; // marco - 11.22.2012
		}
	}
	
	$("prorateFlag").observe("change", showRelatedSpan);
	
	//added edgar 10/13/2014 to check for posted binder
	$("prorateFlag").observe("click", function () {
		if(checkPostedBinder()){ 
			showWaitingMessageBox("You cannot update Endorsement Condition. PAR has posted binder.", imgMessage.ERROR, 
					function(){
								changeTag = 0;
							  });
			return false;
		}
	});
	
	// marco - 11.22.2012 - to prevent sql exception in peril information when short_rt_percent is equal to 0
	$("shortRatePercent").observe("change", function(){
		if(checkPostedBinder()){ 
			showWaitingMessageBox("You cannot update Short Rate Percentage. PAR has posted binder.", imgMessage.ERROR, 
					function(){
								changeTag = 0;
								$("shortRatePercent").value = prevShortRate;
							  });
			return false;
		}
		if($F("shortRatePercent") != "" && $F("shortRatePercent") == parseFloat("0")){
			clearFocusElementOnError("shortRatePercent", "Short Rate Percent should not be equal to 0.");
		}
	});
	
	function defaultDOE() {
		var iDateArray = $F("doi").split("-");
		if (iDateArray.length > 1)	{
			var iDate = new Date();
			var date = parseInt(iDateArray[1], 10);
			var month = parseInt(iDateArray[0], 10) + 12;
			var year = parseInt(iDateArray[2], 10);
			if (month > 12) {
				month -= 12;
				year += 1;
			}
			$("defaultDoe").value = (month < 10 ? "0"+month : month) +"-"+(date < 10 ? "0"+date : date)+"-"+year;
		}
	}	
	
	var arrBookingMonthListing = [];
	arrBookingMonthListing = JSON.parse('${objBookingMonthListing}');		
	
	if(objGIPIWPolbas != null && 
			(arrBookingMonthListing.filter(function(obj){	return (obj.bookingYear == objGIPIWPolbas.bookingYear) && (obj.bookingMonth == objGIPIWPolbas.bookingMth);	}).length > 0)){
		$("bookingDateExist").value = 1;
	}else{
		$("bookingDateExist").value = "";
	}
	
	if($("bookingDateExist").value == 1){
		$("opt2") ? $("opt2").remove() :null; //remove option 2 if record exist in listing			
	}
	
	//upon change of booking date
	$("bookingMonth").observe("change", function() {
		$("bookingYear").value = $("bookingMonth").options[$("bookingMonth").selectedIndex].getAttribute("bookingYear");
		$("bookingMth").value = $("bookingMonth").options[$("bookingMonth").selectedIndex].getAttribute("bookingMth");
	});
	
	$("takeupTermType").setAttribute("disabled", "disabled");
	$("rowCoInsurance").hide();
	
	$("hrefIssueDate").observe("click", function(){
		if(checkPostedBinder()){ //added edgar 10/10/2014 to check for posted binder
			showWaitingMessageBox("You cannot update Issue Date. PAR has posted binder.", imgMessage.ERROR, 
					function(){
								changeTag = 0;
							  });
			return false;
		}
		scwShow($('issueDate'),this, null);
	});
	
	observeBackSpaceOnDate("doe");
	observeBackSpaceOnDate("doi");
	observeBackSpaceOnDate("endtEffDate");
	observeBackSpaceOnDate("endtExpDate");
	observeChangeTagOnDate("hrefDoiDate", "doi");
	observeChangeTagOnDate("hrefDoeDate", "doe");
	observeChangeTagOnDate("hrefEndtEffDate", "endtEffDate");
	observeChangeTagOnDate("hrefEndtExpDate", "endtExpDate");
	
	$("compSw").observe("click", function () {
		if(checkPostedBinder()){ //added edgar 10/10/2014 to check for posted binder
			showWaitingMessageBox("You cannot update Prorate Condition. PAR has posted binder.", imgMessage.ERROR, 
					function(){
								changeTag = 0;
							  });
			return false;
		}
		preCompSw = $("compSw").value;
	});
	
	$("compSw").observe("change", function () {
		$("noOfDays").value = objUWParList.parType == "P" ? computeNoOfDays($F("doi"),$F("doe"),$F("compSw")) : computeNoOfDays($F("endtEffDate"),$F("endtExpDate"),$F("compSw"));							
	});
	
	$("noOfDays").observe("blur", function () {
		var tempEndtEffDate = Date.parse($F("endtEffDate"));
	 	if ($F("noOfDays") <= tempNoOfDays){
			$("endtExpDate").value = dateFormat(new Date(tempEndtEffDate).addDays($F("noOfDays")), 'mm-dd-yyyy');
		}else{
			showConfirmBox("Confirm", "No of days entered will cause the endorsement 's expiry date to be later than the policy's expiry date, would you like to change the policy's expiry date?", 
					"Yes", "No", function(){
				$("doe").value = dateFormat(new Date(tempEndtEffDate).addDays($F("noOfDays")), 'mm-dd-yyyy');
				$("endtExpDate").value = dateFormat(new Date(tempEndtEffDate).addDays($F("noOfDays")), 'mm-dd-yyyy');
			}, '', '');
		}
	});
	
	showRelatedSpan();
}catch(e){
	showErrorMessage("Endt Basic Info - Period of Insurance - Page", e);
}
</script>
