<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
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
	<div id="periodOfInsurance" style="float:left; margin:10px 0px 5px ${parType ne 'E' ? '10px' :'10px'}; ">
		<table align="center" cellspacing="1" style="width:100%;" border="0">
		<tr>
			<td class="rightAligned" >Inception Date </td>
			   <td class="leftAligned" >
			    <div id="doiDiv" name="doiDiv" style="width: 226px;" class="required withIconDiv">
			    	<input style="width: 202px; border: none;" id="paramDoi" name="paramDoi" type="hidden" value="<fmt:formatDate value="${gipiWPolbas.inceptDate }" pattern="MM-dd-yyyy" />" readonly="readonly"/>
			    	<input style="width: 202px;" id="doi" name="doi" type="text" value="<fmt:formatDate value="${gipiWPolbas.inceptDate }" pattern="MM-dd-yyyy" />" readonly="readonly" class="required withIcon" />
			    	<img id="hrefDoiDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"
			    		<c:if test="${parType ne 'E'}"> 
			    			onClick="null<!-- scwShow($('doi'),this, null); commented out edgar 01/29/2015-->" 
			    		</c:if> 
			    	alt="Inception Date" />
			    	
			    	<!-- 
			    	<c:choose>
			    		<c:when test="${parType eq 'E'}">
			    			<img id="hrefDoiDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Inception Date" />
			    		</c:when>
			    		<c:otherwise>
							<img id="hrefDoiDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('doi'),this, null);" alt="Inception Date" />			    		
			    		</c:otherwise>
			    	</c:choose>
			    	 -->		    	
				</div>
			    <input type="checkbox" id="inceptTag" name="inceptTag" value="Y" 
			    <c:if test="${gipiWPolbas.inceptTag == 'Y' }">
						checked="checked"
				</c:if>/> TBA
			</td>
		</tr>
		<c:if test="${parType eq 'E'}">
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
		</c:if> 
		<tr>	
			<td class="rightAligned">Condition </td>
			<td class="leftAligned">
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
					<input type="text" id="shortRatePercent" name="shortRatePercent" class="moneyRate required" style="width: 90px;  float: left; margin-left:2px; margin-top: 0px;" maxlength="13" value="${gipiWPolbas.shortRtPercent }" oldShortRatePercent="${gipiWPolbas.shortRtPercent}"/>
				</span>				
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
	
	<div id="periodOfInsurance" style="float:right; margin:10px ${parType ne 'E' ? '10px' :'10px'} 5px 0px; ">
		<table align="center" cellspacing="1" style="width:100%" border="0">
		<tr>
			<td class="rightAligned" >Expiry Date </td>
			<td class="leftAligned" style="width: 280px;">
			<input style="width: 198px; border: none;" id="defaultDoe" name="defaultDoe" type="hidden" value="<fmt:formatDate value="${gipiWPolbas.expiryDate }" pattern="MM-dd-yyyy" />" readonly="readonly" class="required"/>
			    <div id="doeDiv" name="doeDiv" style="width: 226px;" class="required withIconDiv">
			    	<input style="width: 202px; border: none;" id="paramDoe" name="paramDoe" type="hidden" value="<fmt:formatDate value="${gipiWPolbas.expiryDate }" pattern="MM-dd-yyyy" />" readonly="readonly" class="required"/>
			    	<input style="width: 202px;" id="doe" name="doe" type="text" value="<fmt:formatDate value="${gipiWPolbas.expiryDate }" pattern="MM-dd-yyyy" />" readonly="readonly" class="required withIcon" />
			    	<img id="hrefDoeDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"
			    		<c:if test="${parType ne 'E'}"> 
			    			onClick="null<!-- scwShow($('doe'),this, null); commented out edgar 01/29/2015-->"
			    		</c:if> 
			    	alt="Expiry Date" />
			    	<!-- 
			    	<c:choose>
			    		<c:when test="">
			    			<img id="hrefDoeDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Expiry Date" />
			    		</c:when>
			    		<c:otherwise>
							<img id="hrefDoeDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('doe'),this, null);" alt="Expiry Date" />		    		
			    		</c:otherwise>
			    	</c:choose>
			    	 -->		    	
			    </div>
		    	<input type="checkbox" id="expiryTag" name="expiryTag" value="Y"
		    	<c:if test="${gipiWPolbas.expiryTag == 'Y' }">
						checked="checked"
				</c:if>/> TBA
		    </td>
		</tr>	
		<c:if test="${parType eq 'E'}">	
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
		</c:if>
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
			<td class="leftAligned" id="takeUpSelect">
				<input type="hidden" id="paramTakeupTermType" name="paramTakeupTermType" value="${gipiWPolbas.takeupTerm }" />
				<select id="takeupTermType" name="takeupTermType" style="width: 228px;" class="required">
					<!-- marco - 06.18.2014 - escape HTML tags -->
					<c:forEach var="t" items="${takeupTermListing}">
						<option value="${fn:escapeXml(t.takeupTerm)}" 
						<c:if test="${fn:replace(fn:replace(fn:replace(gipiWPolbas.takeupTerm, '&#38;', '&'), '&#60;', '<'), '&#62;', '>') eq t.takeupTerm}">
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

<script>
	addStyleToInputs();
	initializeAll();
	//added variables : edgar 01/30/2015
	var prevProrate;
	
	if(nvl(objUW.hidObjGIPIS002.updateBooking, "Y") == "N"){
		$("bookingMonth").disable(); // added bY: Nica 05.10.2012 - Per Ms VJ, booking month LOV should be disabled if UPDATE_BOOKING is equal to N.
	}

	function showRelatedSpan(){			
		if ($F("prorateFlag") == "1")	{
			$("shortRateSelected").hide();
			$("shortRatePercent").hide();
			$("prorateSelected").show();
			$("noOfDays").show();
			$("noOfDays").value = objUWParList.parType == "P" ? computeNoOfDays($F("doi"),$F("doe"),$F("compSw")) : computeNoOfDays($F("endtEffDate"),$F("endtExpDate"),$F("compSw"));
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
		}
	}

	$("prorateFlag").observe("change", function () {
		if(checkPostedBinder()){ //modified edgar 01/30/2015
			showWaitingMessageBox("You cannot update Condition. PAR has posted binder.", imgMessage.ERROR, 
					function(){
								$("prorateFlag").value = prevProrate;
								changeTag = 0;
							  });
			return false;
		}
		showRelatedSpan();
	});

	//added edgar 01/29/2015 to check for posted binder
	$("prorateFlag").observe("focus", function(){
		prevProrate = $F("prorateFlag");
	});
	
	$("prorateFlag").observe("click", function () {
		if(checkPostedBinder()){ 
			showWaitingMessageBox("You cannot update Condition. PAR has posted binder.", imgMessage.ERROR, 
					function(){
								changeTag = 0;
							  });
			return false;
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
	

	function getBookingDate(){
		//if (objUW.hidObjGIPIS002.gipiWPolbasExist == "1") return; //commented by Nok 08.02.2011
		
		var iiDateArray = $F("doi").split("-");
		var iiDate = new Date();
		var iidate = parseInt(iiDateArray[1], 10);
		var iimonth = parseInt(iiDateArray[0], 10);
		var iiyear = parseInt(iiDateArray[2], 10);
		iiDate.setFullYear(iiyear, iimonth-1, iidate);

		var isDateArray = $F("issueDate").split("-");
		var isDate = new Date();
		var isdate = parseInt(isDateArray[1], 10);
		var ismonth = parseInt(isDateArray[0], 10);
		var isyear = parseInt(isDateArray[2], 10);
		isDate.setFullYear(isyear, ismonth-1, isdate);

		//for issue date
		var newDate = new Date();
		/*if (iiyear <= 1996) {
			$("issueDate").value = $F("doi");
		} else {
			$("issueDate").value = (newDate.getMonth()+1 < 10 ? "0"+(newDate.getMonth()+1) : (newDate.getMonth()+1))+"-"+newDate.getDate()+"-"+newDate.getFullYear();
		}*/	
		//replace code above, niknok comment ko muna ung sa taas di na daw applicable ung condition, req by mam grace 11.02.2011
		if (Number(nvl($("parStatus").value,2)) >= 3){
			
		}else{
			//$("issueDate").value = $F("issueDateToday"); commented out by jeffdojello as per QA [SR-12769 Note-30588/30999]
			//$("issueDate").value = formatNumberDigits((newDate.getMonth()+1),2)+"-"+formatNumberDigits(newDate.getDate(),2)+"-"+newDate.getFullYear();
		}	

		var varIDate = "";
		var iDateArray = [];
		if (($("varVdate").value == "1") || (($("varVdate").value == "3") && (isDate > iiDate)) || (($("varVdate").value == "4") && (isDate < iiDate))){
			iDateArray = $F("issueDate").split("-");
			varIDate = $F("issueDate");
		} else if (($("varVdate").value == "2") || (($("varVdate").value == "3") && (isDate <= iiDate)) || (($("varVdate").value == "4") && (isDate >= iiDate))) {
			iDateArray = $F("doi").split("-");
			varIDate = $F("doi");
		}
		
		// this line added by: Nica 05.08.2012 to refresh booking month LOV
		if (nvl(objUW.hidObjGIPIS002.bookingAdv,"N") != "Y"){ 
			new Ajax.Request(contextPath+"/GIPIParInformationController",{
				parameters:{
					action: "getBookingListing",
					parId: $F("parId"),
					date: varIDate				
				},
				asynchronous: false,
				evalScripts: true,
				onComplete:function(response){
					var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
					updateBookingLOV(res);
				}	
			});	
		}
		
		new Ajax.Request(contextPath+"/GIPIParInformationController", {
			method: "GET",
			parameters:{
				action: "getBookingDateGIPIS002",
				parId: $F("parId"),
				varIDate: varIDate				
			},
			asynchronous: false,
			evalScripts: true,
			onComplete:function(response){
				var book = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
				for(var a=0; a<$("bookingMonth").options.length; a++){
					if ($("bookingMonth").options[a].getAttribute("bookingyear") == book.bookingYear
					    && $("bookingMonth").options[a].getAttribute("bookingMth") == book.bookingMth){
						$("bookingMonth").selectedIndex = a;
						$("bookingYear").value = $("bookingMonth").options[a].getAttribute("bookingYear");
					 	$("bookingMth").value = $("bookingMonth").options[a].getAttribute("bookingMth");
					}	
				}	
			}	
		});
		/*
		if (nvl(objUW.hidObjGIPIS002.bookingAdv,"N") != "Y"){
			new Ajax.Request(contextPath+"/GIPIParInformationController",{
				parameters:{
					action: "getBookingListing",
					parId: $F("parId"),
					date: varIDate				
				},
				asynchronous: false,
				evalScripts: true,
				onComplete:function(response){
					var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
					updateBookingLOV(res);
				}	
			});	
			if ($("bookingMonth").options.length > 1){
			 	$("bookingMonth").selectedIndex = 1;
				$("bookingYear").value = $("bookingMonth").options[1].getAttribute("bookingYear");
			 	$("bookingMth").value = $("bookingMonth").options[1].getAttribute("bookingMth");
			}
		}else{
			for(var a=0; a<$("bookingMonth").options.length; a++){
				if ($("bookingMonth").options[a].getAttribute("bookingyear") == iDateArray[2] 
				    && $("bookingMonth").options[a].value == iDateArray[0]){
					$("bookingMonth").selectedIndex = a;
					$("bookingYear").value = $("bookingMonth").options[a].getAttribute("bookingYear");
				 	$("bookingMth").value = $("bookingMonth").options[a].getAttribute("bookingMth");
				}	
			}	
		}*/
	}	
	
	if($F("parType") != "E"){	
		defaultDOE();
		$("paramNoOfDays").value = computeNoOfDays($F("doi"),$F("doe"),$F("compSw"));
		
		$("noOfDays").observe("focus", function(){
			$("paramNoOfDays").value = $("noOfDays").value;
		});

		var doi = $("doi").value;
		var doe;
		var preDoe1 = "";
		$("hrefDoiDate").observe("click", function () {
			if(checkPostedBinder()){ //added edgar 01/29/2015 to check for posted binder
				showWaitingMessageBox("You cannot update Inception Date. PAR has posted binder.", imgMessage.ERROR, 
						function(){
									changeTag = 0;
								  });
				return false;
			}
			preDoe1 = $F("doe");
			scwShow($('doi'),this, null);//edgar 01/29/2015
		});	 
		$("doe").observe("blur", function () {		
			var incept = makeDate($F("doi"));
			var exp = makeDate($F("doe"));	
			if (exp<incept){
				$("doe").value = preDoe1;
				showMessageBox("Expiry date is invalid. Expiry date must be later than Inception date.", imgMessage.ERROR);
				return false;
			}
			
			$("noOfDays").value = computeNoOfDays($F("doi"),$F("doe"),$F("compSw"));
			if ($("defaultDoe").value != $("doe").value){
				$("prorateFlag").enable();
			}else{
				$("prorateFlag").value = "2";
				$("prorateFlag").disable();	
				showRelatedSpan();
			}	
			doi = $("doi").value;	
		});

		$("hrefDoeDate").observe("click", function () {
			if(checkPostedBinder()){ //added edgar 01/29/2015 to check for posted binder
				showWaitingMessageBox("You cannot update Expiry Date. PAR has posted binder.", imgMessage.ERROR, 
						function(){
									changeTag = 0;
								  });
				return false;
			}
			if ($("doi").value == ""){
				$("doi").focus();
			}				
			doe = $("doe").value;	
			scwShow($('doe'),this, null); //edgar 01/29/2015
		});

		$("hrefDoiDate").observe("click", function () {
			if(checkPostedBinder()){ //added edgar 01/29/2015 to check for posted binder
				showWaitingMessageBox("You cannot update Inception Date. PAR has posted binder.", imgMessage.ERROR, 
						function(){
									changeTag = 0;
								  });
				return false;
			}
			doi = $("doi").value;
			scwShow($('doi'),this, null); //edgar 01/29/2015		
		});

		observeBackSpaceOnDate("doe");
		observeBackSpaceOnDate("doi");
		observeChangeTagOnDate("hrefDoiDate", "doi");
		observeChangeTagOnDate("hrefDoeDate", "doe");
		
		$("doi").observe("focus", function () {
			$("noOfDays").value = computeNoOfDays($F("doi"),$F("doe"),$F("compSw"));
		});

		$("doi").observe("blur", function () {
			if ($("doi").value != $("paramDoi").value){
				if ($("prorateFlag").value != 1){
					defaultExpiryDate();
					defaultDOE();
				}
				if ($("doi").value != doi){
					defaultExpiryDate();
					defaultDOE();
				}
				getBookingDate();
				
				/*commented out by jeffdojello 04.26.2013 as per QA [SR-12769 Note-30588/30999/0031079]
				if (Number(nvl($("parStatus").value,2)) >= 3){
					$("updateIssueDate").value = "N";
				}else{
					//$("issueDate").value = $F("issueDateToday"); commented out by jeffdojello 04.25.2013 as per QA [SR-12769 Note-30588/30999]
					$("updateIssueDate").value = "Y";	
				}*/	
				
				$("updateIssueDate").value = "N"; //by jeffdojello as per QA [SR-12769 Note-30588/30999/0031079]
			}
				
			$("noOfDays").value = computeNoOfDays($F("doi"),$F("doe"),$F("compSw"));
			
			if ($("doi").value != ""){
				if ($("prorateFlag") != 2){
					if ($("defaultDoe").value == $("doe").value){
						$("prorateFlag").selectedIndex = 1;
						showRelatedSpan();
						$("prorateFlag").disable();
					} else {
						$("prorateFlag").enable();
						showRelatedSpan();
					}	
				}				
			}
		});		

		var preCompSw;
		$("compSw").observe("click", function () {
			if(checkPostedBinder()){ //added edgar 01/29/2015 to check for posted binder
				showWaitingMessageBox("You cannot update Prorate Condition. PAR has posted binder.", imgMessage.ERROR, 
						function(){
									changeTag = 0;
								  });
				return false;
			}
			preCompSw = $("compSw").value;
		});
		$("compSw").observe("focus", function () {//added edgar 01/30/2015
			preCompSw = $("compSw").value;
		});
		$("compSw").observe("change", function () {			
			if(checkPostedBinder()){ //added edgar 01/29/2015 to check for posted binder
				showWaitingMessageBox("You cannot update Prorate Condition. PAR has posted binder.", imgMessage.ERROR, 
						function(){
									changeTag = 0;
									$("compSw").value = preCompSw;
								  });
				return false;
			}
			var noOfDays = $("noOfDays").value;
			$("noOfDays").value = objUWParList.parType == "P" ? computeNoOfDays($F("doi"),$F("doe"),$F("compSw")) : computeNoOfDays($F("endtEffDate"),$F("endtExpDate"),$F("compSw"));
			if (parseInt($("noOfDays").value) < 0 && $F("compSw") == "M"){
				showMessageBox("Tagging of -1 day will result to invalid no. of days. Changing is not allowed.", imgMessage.ERROR);
				$("noOfDays").value = noOfDays ;//$("paramNoOfDays").value; 
				$("compSw").value = preCompSw;
			}
			var preDoe = $("doe").value; 
			var incept = makeDate($F("doi"));
			var exp = makeDate($F("doe"));	
			if (exp<incept){
				$("doe").value = preDoe;
				customShowMessageBox("Expiry date is invalid. Expiry date must be later than Inception date.", imgMessage.ERROR, "compSw");
				return false;
			}
			
			if(objUWParList.parType == "E"){
				var plus = 0;
				if($F("compSw") == "Y"){
					plus = 1;
				}else if($F("compSw") == "M"){
					plus = -1;
				}

				$("noOfDays").value = parseInt($F("noOfDays")) + plus;
			}			
		});		
	
		if($("bookingDateExist").value == 1){
			$("opt2") ? $("opt2").remove() :null; //remove option 2 if record exist in listing
		}
		if (objUW.hidObjGIPIS002.gipiWPolbasExist != "1"){
			$("opt2").remove();
		}	

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
		
		function defaultExpiryDate() {
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
				$("doe").value = (month < 10 ? "0"+month : month) +"-"+(date < 10 ? "0"+date : date)+"-"+year;
			}
		}		

		//upon change of booking date
		$("bookingMonth").observe("change", function() {
			$("bookingYear").value = $("bookingMonth").options[$("bookingMonth").selectedIndex].getAttribute("bookingYear");
			$("bookingMth").value = $("bookingMonth").options[$("bookingMonth").selectedIndex].getAttribute("bookingMth");
		});

		$("shortRatePercent").observe("blur", function() {
			if ($F("shortRatePercent") != "" ){
				if (parseFloat($F("shortRatePercent")) < 0.000000001 || parseFloat($F('shortRatePercent')) >  100.000000000 || isNaN(parseFloat($F('shortRatePercent')))) {
					$("shortRatePercent").clear();
					showMessageBox("Entered short rate percent is invalid. Valid value is from 0.000000001 to 100.000000000.", imgMessage.ERROR);
				}	
			}
		});	
	}else if($F("parType") == "E"){
		$("shortRatePercent").observe("change", function() { // andrew - 3.4.2013 - copied validation from parType = 'P'
			if ($F("shortRatePercent") != ""){
				if (parseFloat($F("shortRatePercent")) < 0.000000001 || parseFloat($F('shortRatePercent')) >  100.000000000 || isNaN(parseFloat($F('shortRatePercent')))) {
					//$("shortRatePercent").clear();
					showWaitingMessageBox("Invalid Short Rate Percent. Valid value should be from 0.000000001 to 100.000000000.", imgMessage.ERROR, 
						function(){
							$("shortRatePercent").value = formatToNineDecimal($("shortRatePercent").readAttribute("oldShortRatePercent"));
							$("shortRatePercent").focus();
						});
				} else {
					$("shortRatePercent").writeAttribute("oldShortRatePercent", $F("shortRatePercent"));
				}
			}
		});
		
		// added by mark jm 09.16.2011 for endorsement only
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
				
		$("hrefDoeDate").observe("click", function () {
			if(checkPostedBinder()){ //added edgar 01/29/2015 to check for posted binder
				showWaitingMessageBox("You cannot update Expiry Date. PAR has posted binder.", imgMessage.ERROR, 
						function(){
									changeTag = 0;
								  });
				return false;
			}
			if(!($F("doe").blank())){
				$("varExpOldDte").value = $F("doe");
			}			
			
			//checkDateFieldsForChanges();
			scwShow($('doe'),this, null);				
		});
		
		$("hrefDoiDate").observe("click", function () {
			if(checkPostedBinder()){ //added edgar 01/29/2015 to check for posted binder
				showWaitingMessageBox("You cannot update Inception Date. PAR has posted binder.", imgMessage.ERROR, 
						function(){
									changeTag = 0;
								  });
				return false;
			}
			if($F("endtEffDate")=="") {
				showMessageBox("Endt Effectivity Date must be entered. ", "E");
				return false;
			}
			
			if(!($F("doi").blank())){
				$("varEffOldDte").value = $F("doi");
			}			
			
			//checkDateFieldsForChanges();
			scwShow($('doi'),this, null);			
		});
		
		$("hrefEndtEffDate").observe("click", function(){
			if(!($F("endtEffDate").blank())){			
				$("varOldDateEff").value = $F("endtEffDate");
			}
			
			$("varMplSwitch").value = "N";		
			//checkDateFieldsForChanges();
			scwShow($('endtEffDate'),this, null);
			if('${isPack }' == 'Y' && objUWGlobal.parType == "E") {getBookingDate();}
		});

		$("hrefEndtExpDate").observe("click", function(){
			if(!($F("endtExpDate").blank)){
				$("varOldDateExp").value = $F("endtExpDate");
			}		
			
			$("varMplSwitch").value = "N";
			//checkDateFieldsForChanges();
			scwShow($('endtExpDate'),this, null);						
		});

		$("hrefIssueDate").observe("click", function(){
			if(checkPostedBinder()){ //added edgar 01/29/2015 to check for posted binder
				showWaitingMessageBox("You cannot update Issue Date. PAR has posted binder.", imgMessage.ERROR, 
						function(){
									changeTag = 0;
								  });
				return false;
			}
			scwShow($('issueDate'),this, null);
		});

		$("doi").observe("blur", function(){
			if(($F("doi") != $F("varEffOldDte")) && !($F("doi").blank())){
				$("recordStatus").value = "1";
				$("fieldName").value = "INCEPT_DATE";
				validateInceptExpiryDate();
				//$("varEffOldDte").value = $F("doi");
				$("b540InceptDate").value = $F("doi").substr(0, 10) + $F("b540InceptDate").substr(10);				
			}						
		});		

		$("doe").observe("blur", function(){
			if(($F("doe") != $F("varExpOldDte")) && !($F("doe").blank())){
				$("recordStatus").value = "1";
				$("fieldName").value = "EXPIRY_DATE";
				validateInceptExpiryDate();
				//$("varExpOldDte").value = $F("doe");
				$("b540ExpiryDate").value = $F("doe").substr(0, 10) + $F("b540ExpiryDate").substr(10);
			}			
		});

		$("endtEffDate").observe("blur", function(){
			if(($F("endtEffDate") != $F("varOldDateEff")) && !($F("endtEffDate").blank())){
				$("recordStatus").value = "1";
				$("fieldName").value = "";
				validateEndtEffDate();
				//$("varOldEffDate").value = $F("endtEffDate");
				$("b540EffDate").value = $F("endtEffDate").substr(0, 10) + $F("b540EffDate").substr(10);
			}			
		});

		$("endtExpDate").observe("blur", function(){
			if(($F("endtExpDate") != $F("varOldDateExp")) && !($F("endtExpDate").blank())){
				$("recordStatus").value = "1";
				$("fieldName").value = "";
				validateEndtExpiryDate();
				//$("varOldDateExp").value = $F("endtExpDate");
				$("b540EndtExpiryDate").value = $F("endtExpDate").substr(0, 10) + $F("b540EndtExpiryDate").substr(10);
			}			
		});

		$("issueDate").observe("blur", function(){
			if(($F("issueDate") != ($F("b540IssueDate")).substr(0,10)) && !($F("issueDate").blank())){
				$("recordStatus").value = "1";
				validateEndtIssueDate();
				//$("b540IssueDate").value = $F("issueDate");
				$("b540IssueDate").value = $F("issueDate").substr(0, 10) + $F("b540IssueDate").substr(10);
			}
		});

		function validateInceptExpiryDate(){			
			if($F("recordStatus") == "1" && 
					($F(($F("fieldName") == "INCEPT_DATE" ? "varEffOldDte" : "varExpOldDte")) != $F(($F("fieldName") == "INCEPT_DATE" ? "doi" : "doe")))){
				$("varAddTime").value = "0";				
				showWaitingMessageBox("Please change due dates of the previous endorsement/policy", imgMessage.INFO, validateEndtInceptExpiryDate);								
			}	
		}
		
		function validateEndtInceptExpiryDate(){
			try {
				var paramFieldName = nvl('${isPack }', "N") == "Y" ? ($F("fieldName") == "INCEPT_DATE" ? "PACK_INCEPT_DATE" : "PACK_EXPIRY_DATE") : $F("fieldName");
				if($F("endtEffDate")=="") {
					showMessageBox("Endt Effectivity Date must be entered. ", "E");
				} else {
					new Ajax.Request(contextPath + "/GIPIParInformationController?action=validateEndtInceptExpiryDate",{
						method : "GET",
						parameters : {					
							inceptDate : $F("doi"),
							effDate : $F("endtEffDate"),
							expiryDate : $F("doe"),
							parId : '${isPack }' == "Y" ? $F("globalPackParId") : $F("globalParId"),
							lineCd : $F("b540LineCd"),
							sublineCd : $F("b540SublineCd"),
							issCd : $F("b540IssCd"),
							issueYy : $F("b540IssueYY"),
							polSeqNo : $F("b540PolSeqNo"),
							renewNo : $F("b540RenewNo"),
							fieldName : paramFieldName
						},
						asynchronous : true,
						evalScripts : true,
						onCreate : showNotice("Validating date, please wait..."),
						onComplete : function(response){
							hideNotice("");
							if (checkErrorOnResponse(response)) {
								hideNotice("");
								//var result = response.responseText.toQueryParams();
								var result = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
								if(nvl(result.msgAlert,null) != null){
									showMessageBox(result.msgAlert, imgMessage.WARNING);
									if(nvl('${isPack }', "N") == "Y" && $F("parType") == "E"){
										if($("fieldName").value == "INCEPT_DATE"){
											$("doi").value = $("varEffOldDte").value;
										}else if($("fieldName").value == "EXPIRY_DATE"){
											$("doe").value = $("varExpOldDte").value;
										}
									}
								}

								if($F("fieldName") == "EXPIRY_DATE"){
									$("endtExpDate").value = $F("doe");
									$("b540EndtExpiryDate").value = $F("doe") + $F("b540EndtExpiryDate").substr(10);							
								}
							}
						}
					});
				}
				
			} catch(e) {
				showErrorMessage("validateEndtInceptExpiryDate", e);
			}
		}

		function validateEndtEffDate(){				
			if($F("prorateSw") == "1" /*&& $F("prorateFlag") != "2" */ && $F("varOldDateEff") != $F("endtEffDate")){
				$("parProrateCancelSw").value = "Y";
			}

			if(!($("nbtPolFlag").checked)){
				if($F("recordStatus") == "1"){
					if ('${isPack }' == 'Y') {
						new Ajax.Request(contextPath + "/GIPIPackParInformationController?action=validatePackEndtEffDate",{
							method : "GET",
							parameters : {
								varOldDateEff : $F("varOldDateEff"),
								parId : ('${isPack }' == 'Y') ? objUWGlobal.packParId : $F("globalParId"),
								lineCd : ('${isPack }' == 'Y') ? objUWGlobal.lineCd : $F("globalLineCd"),
								sublineCd : ('${isPack }' == 'Y') ? (objUWGlobal.sublineCd == null ? $F("sublineCd") : objUWGlobal.sublineCd) : ($F("globalSublineCd").blank() ? $F("sublineCd") : $F("globalSublineCd")),
								issCd : ('${isPack }' == 'Y') ? objUWGlobal.issCd : $F("globalIssCd"),
								issueYy : $F("b540IssueYY"),
								polSeqNo : $F("b540PolSeqNo"),
								renewNo : $F("b540RenewNo"),
								prorateFlag : $F("b540ProrateFlag"),
								endtExpiryDate : $F("endtExpDate"),
								compSw : $F("b540CompSw"),
								polFlag : $F("b540PolFlag"),
								expChgSw : $F("varExpChgSw"),
								varMaxEffDate : $F("varMaxEffDate"),
								parFirstEndtSw : $F("parFirstEndtSw"),
								varExpiryDate : $F("varExpiryDate"),
								parVarVdate : $F("parVarVdate"),
								issueDate : $F("issueDate"),
								effDate : $F("endtEffDate"),
								inceptDate : $F("doi"),
								expiryDate : $F("doe"),
								endtYY : $F("b540EndtYy"),
								sysdateSw : $F("parSysdateSw"),
								cgBackEndtSw : $F("globalCg$BackEndt"),
								parBackEndtSw : $F("parBackEndtSw")
							},
							asynchronous : true,
							evalScripts : true,
							onCreate : showNotice("Validating endt effitivity date, please wait..."),
							onComplete : function(response){
								if (checkErrorOnResponse(response)) {
									hideNotice("");
									//var result = response.responseText.toQueryParams();
									var result = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
															
									if(nvl(result.msgAlert,null) != null && !(result.msgAlert.blank())){									
										showMessageBox(result.msgAlert, imgMessage.ERROR);
										//$("endtEffDate").value ="";
										$("endtEffDate").value = nvl($("varOldDateEff").value, "");
									}else{						
										$("endtEffDate").value = result.effDate.substr(0, 10);
										$("b540EffDate").value = result.effDate;
										$("varOldEffDate").value = result.effDate;
										$("varOldDateEff").value = $F("endtEffDate");
										$("doi").value = result.inceptDate.substr(0, 10);
										$("b540InceptDate").value = result.inceptDate;
										$("doe").value = result.expiryDate.substr(0, 10);
										$("b540ExpiryDate").value = result.expiryDate;
										$("b540EndtYy").value = result.endtYy;
										$("parSysdateSw").value = result.sysdateSw;
										$("globalCg$BackEndt").value = result.cgBackEndt;
										$("parBackEndtSw").value = result.parBackEndtSw;
										if(result.annTsiAmt != null) $("b540AnnTsiAmt").value = result.annTsiAmt; // andrew - 11.28.2011 - added condition
										if(result.annPremAmt != null) $("b540AnnPremAmt").value = result.annPremAmt; // andrew - 11.28.2011 - added condition
										$("noOfDays").value = result.prorateDays;
										$("varMplSwitch").value = result.mplSwitch;
										$("bookingMonth").value = result.bookingMonth;
										//$("bookingMonth").selectedIndex = getIndexInSelectList("bookingMonth", result.bookingYear + " - " + result.bookingMonth);
										$("bookingYear").value = result.bookingYear;
										$("bookingMth").value = $("bookingMonth").options[$("bookingMonth").selectedIndex].getAttribute("bookingMth");
										
										/** Start here Nica 05.25.2012 Added the following lines to 
										    refresh booking month whenever endt effectivity date changes **/
										   
										new Ajax.Request(contextPath + "/GIPIParInformationController?action=getBookingDate", {
											method : "POST",
											parameters : {
												parId : objUWGlobal.packParId,
												parVarVDate : $("varVdate").value,
												issueDate : $F("issueDate"),
												effDate : $F("endtEffDate")
											},									
											onComplete : function(response){
												if(checkErrorOnResponse(response)){
													var obj = JSON.parse(response.responseText.replace(/\\/g,'\\\\'));
													
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
													
													obj.parVarIDate = dateFormat(obj.parVarIDate,"mm-dd-yyyy");
													
													// update booking listing
													new Ajax.Request(contextPath+"/GIPIParInformationController",{
														parameters:{
															action : "getBookingListing",
															parId : objUWGlobal.packParId,
															date : obj.parVarIDate				
														},												
														onComplete:function(response){
															var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
															updateBookingLOV(res);
															
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
													});												
												}
											}
										});
										
										/** End here Nica 05.25.2012**/
									}											
								}
							}
						});
					} else {
						new Ajax.Request(contextPath + "/GIPIParInformationController?action=validateEndtEffDate",{
							method : "GET",
							parameters : {
								varOldDateEff : $F("varOldDateEff"),
								parId : ('${isPack }' == 'Y') ? objUWGlobal.packParId : $F("globalParId"),
								lineCd : ('${isPack }' == 'Y') ? objUWGlobal.lineCd : $F("globalLineCd"),
								sublineCd : ('${isPack }' == 'Y') ? (objUWGlobal.sublineCd == null ? $F("sublineCd") : objUWGlobal.sublineCd) : ($F("globalSublineCd").blank() ? $F("sublineCd") : $F("globalSublineCd")),
								issCd : ('${isPack }' == 'Y') ? objUWGlobal.issCd : $F("globalIssCd"),
								issueYy : $F("b540IssueYY"),
								polSeqNo : $F("b540PolSeqNo"),
								renewNo : $F("b540RenewNo"),
								prorateFlag : $F("b540ProrateFlag"),
								endtExpiryDate : $F("endtExpDate"),
								compSw : $F("b540CompSw"),
								polFlag : $F("b540PolFlag"),
								expChgSw : $F("varExpChgSw"),
								varMaxEffDate : $F("varMaxEffDate"),
								parFirstEndtSw : $F("parFirstEndtSw"),
								varExpiryDate : $F("varExpiryDate"),
								parVarVdate : $F("parVarVdate"),
								issueDate : $F("issueDate"),
								effDate : $F("endtEffDate"),
								inceptDate : $F("doi"),
								expiryDate : $F("doe"),
								endtYY : $F("b540EndtYy"),
								sysdateSw : $F("parSysdateSw"),
								cgBackEndtSw : $F("globalCg$BackEndt"),
								parBackEndtSw : $F("parBackEndtSw")
							},
							asynchronous : true,
							evalScripts : true,
							onCreate : showNotice("Validating endt effitivity date, please wait..."),
							onComplete : function(response){
								if (checkErrorOnResponse(response)) {
									hideNotice("");
									//var result = response.responseText.toQueryParams();
									var result = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
																
									if(nvl(result.msgAlert,null) != null && !(result.msgAlert.blank())){									
										showMessageBox(result.msgAlert, imgMessage.ERROR);
										$("endtEffDate").value ="";									
									}else{									
										$("endtEffDate").value = result.effDate.substr(0, 10);
										$("b540EffDate").value = result.effDate;
										$("varOldEffDate").value = result.effDate;
										$("varOldDateEff").value = $F("endtEffDate");
										$("doi").value = result.inceptDate.substr(0, 10);
										$("b540InceptDate").value = result.inceptDate;
										$("doe").value = result.expiryDate.substr(0, 10);
										$("b540ExpiryDate").value = result.expiryDate;
										$("b540EndtYy").value = result.endtYy;
										$("parSysdateSw").value = result.sysdateSw;
										$("globalCg$BackEndt").value = result.cgBackEndt;
										$("parBackEndtSw").value = result.parBackEndtSw;
										if(result.annTsiAmt != null) $("b540AnnTsiAmt").value = result.annTsiAmt; // d.alcantara - 03.20.2011 - added condition
										if(result.annPremAmt != null) $("b540AnnPremAmt").value = result.annPremAmt; // d.alcantara - 03.20.2011 - added condition
										$("noOfDays").value = result.prorateDays;
										$("varMplSwitch").value = result.mplSwitch;
										$("bookingMonth").value = result.bookingMonth;
										//$("bookingMonth").selectedIndex = getIndexInSelectList("bookingMonth", result.bookingYear + " - " + result.bookingMonth);
										$("bookingYear").value = result.bookingYear;
										$("bookingMth").value = $("bookingMonth").options[$("bookingMonth").selectedIndex].getAttribute("bookingMth");									
									}											
								}
							}
						});
					}
				}
			}
		}
		
		function validateEndtExpiryDate(){	
			new Ajax.Request(contextPath + "/GIPIParInformationController?action=validateEndtExpiryDate",{
				method : "GET",
				parameters : {
					parId : ('${isPack }' == 'Y') ? objUWGlobal.packParId : $F("globalParId"),//$F("globalParId"), replaced by: Nica 12.20.2012
					recordStatus : $F("recordStatus"),
					lineCd : ('${isPack }' == 'Y') ? objUWGlobal.lineCd : $F("globalLineCd"), //$F("globalLineCd"), replaced by: Nica 12.20.2012
					sublineCd : ('${isPack }' == 'Y') ? (objUWGlobal.sublineCd == null ? $F("sublineCd") : objUWGlobal.sublineCd) : ($F("globalSublineCd").blank() ? $F("sublineCd") : $F("globalSublineCd")),//$F("globalSublineCd"),
					expiryDate : $F("doe"),
					effDate : $F("endtEffDate"),
					endtExpiryDate : $F("endtExpDate"),
					varOldDateExp : $F("varOldDateExp"),
					compSw : $("b540CompSw").value,
					varAddTime : $F("varAddTime")					
				},
				asynchronous : true,
				evalScripts : true,
				onCreate : showNotice("Validating date, please wait..."),
				onComplete : function(response){
					if (checkErrorOnResponse(response)) {
						hideNotice("Done!");
						//var result = response.responseText.toQueryParams();
						var result = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
						
						if(nvl(result.msgAlert,null) != null){
							showMessageBox(result.msgAlert, imgMessage.WARNING);
							$("endtExpDate").value = result.varOldDateExp;
							$("b540EndtExpiryDate").value = result.varOldDateExp + $F("b540EndtExpiryDate").substr(10);
						}else{
							$("varAddTime").value = result.varAddTime;
							$("prorateFlag").value = result.prorateFlag;
							$("varMplSwitch").value = result.varMplSwitch;
							$("parConfirmSw").value = result.parConfirmSw;
							//$("prorateDays").value = result.prorateDays;
						}
					}
				}
			});	
		}

		function validateEndtIssueDate(){	
			new Ajax.Request(contextPath + "/GIPIParInformationController?action=validateEndtIssueDate",{
				method : "GET",
				parameters : {
					parId : ('${isPack }' == 'Y') ? objUWGlobal.packParId : $F("globalParId"), //$F("globalParId"), // replaced by: Nica 12.20.2012
					parVarVdate : $F("parVarVdate"),
					issueDate : $F("issueDate"),
					effDate : $F("endtEffDate")				
				},
				asynchronous : true,
				evalScripts : true,
				onCreate : showNotice("Validating date, please wait..."),
				onComplete : function(response){
					if (checkErrorOnResponse(response)) {
						hideNotice("Done!");
						var result = response.responseText.toQueryParams();
						
						if(nvl(result.msgAlert,null) != null && !(result.msgAlert.isUndefined())){
							showMessageBox(result.msgAlert, imgMessage.WARNING);						
						}else{
							$("parVarIdate").value = result.parVarIdate;						
							$("bookingMonth").selectedIndex = getIndexInSelectList("bookingMonth", result.bookingYear + " - " + result.bookingMonth);
						}
					}
				}
			});	
		}

		observeBackSpaceOnDate("doe");
		observeBackSpaceOnDate("doi");
		observeBackSpaceOnDate("endtEffDate");
		observeBackSpaceOnDate("endtExpDate");
		observeChangeTagOnDate("hrefDoiDate", "doi");
		observeChangeTagOnDate("hrefDoeDate", "doe");
		if(objUWParList.parType == "E") {
			observeChangeTagOnDate("hrefEndtEffDate", "endtEffDate");
			observeChangeTagOnDate("hrefEndtExpDate", "endtExpDate");
		}
		
		function disableFields(){
			//var endtFields = ["parNo", "sublineCd", "manualRenewNo",
			//                  "typeOfPolicy", "address1", "address2", "address3",
			//                  "creditingBranch", "assuredName", "inAccountOf", "issueDate",
			//                  "issuePlace", "riskTag", "referencePolicyNo", "industry",
			//                  "region", /*"packagePolicy", "regularPolicy", "premWarrTag",
			//                  "fleetTag", "wTariff", "endorseTax", "nbtPolFlag",
			//                  "prorateSw", "doi", "endtEffDate",*/ "prorateFlag",
			//                  "bookingMonth", /*"doe", "endtExpDate",*/ "coIns",
			//                  "takeupTermType", "endorsementInformation", "generalInformation"];

			//for(var index = 0, length = endtFields.length; index < length; index++){						
			//	$(endtFields[index]).observe("change", function(){
			//		
			//	});
			//}
			if($("endtEffDate").getAttribute("disabled") != null){
				$("endtEffDate").removeAttribute("disabled");
			}else{
				$("endtEffDate").setAttribute("disabled", "disabled");
			}
		}

		$("compSw").observe("click", function () {
			if(checkPostedBinder()){ //added edgar 01/29/2015 to check for posted binder
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
	}
	showRelatedSpan();
	
	// modification for package, - irwin 10.22.2012
	var isPack2 = '${isPack}'; 
	if(nvl(isPack2,"N") == "Y"){
		$("takeupTermType").value = "ST"; // For now the default for package is Single takeup
		$("takeupTermType").hide();
		$("takeUpTermLabel").hide();
		$("takeUpSelect").setStyle({
		  width: '120px'
		});
	}
	
	//added edgar 01/29/2015 to check for posted binders
	function checkPostedBinder(){ 
		var vExists = false;	
		new Ajax.Request(contextPath+"/GIPIWinvoiceController",{
				parameters:{
					action: "checkForPostedBinders",
					parId : $F("parId")
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
</script>
