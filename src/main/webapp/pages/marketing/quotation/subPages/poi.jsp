<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
   		<label>Period Of Insurance</label>
   		<span class="refreshers" style="margin-top: 0;"> 
   			<label name="gro">Hide</label>
   		</span>
   	</div>
 </div>
<div class="sectionDiv" id="periodOfInsuranceDiv" changeTagAttr="true">
	<div id="" style="margin: 10px;">
		<table cellspacing="1" border="0" style="margin: 10px auto;">
			<tr>
				<td class="rightAligned">Inception Date </td>
				<td class="leftAligned">					
					<!-- <span class="required"> -->
					<div id="doiDiv" name="doiDiv" style="float: left; border: solid 1px gray; height: 21px; margin-right: 3px;" class="required">
						<%-- <input style="border: none;" id="doi" name="doi" type="text" value="<fmt:formatDate value="${gipiQuote.inceptDate }" pattern="MM-dd-yyyy" />" readonly="readonly" class="required"/> --%>
						<input style="float: left; border: none; margin-top: 0px; width: 147px;" id="doi" name="doi" type="text" value="${gipiQuote.inceptDate}" readonly="readonly" class="required"/>
						<img id="hrefInceptionDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('doi'),this, null);" class="hover" alt="Inception Date" />
					</div>						
					<!-- </span> -->
					<input id="inceptTag" name="inceptTag" type="checkbox" value="Y" style=" margin-left: 5px;"
					<c:if test="${'Y' eq gipiQuote.inceptTag}">
						checked="checked"
					</c:if> /> TBA
				</td>
				<td class="rightAligned">Expiry Date </td>
				<td class="leftAligned">
					<!-- <span class="required"> -->
					<div id="doeDiv" name="doeDiv" style="float: left; border: solid 1px gray; height: 21px; margin-right: 3px;" class="required">
						<%-- <input class="required" style="border: none;" id="doe" name="doe" type="text" value="<fmt:formatDate value="${gipiQuote.expiryDate}" pattern="MM-dd-yyyy" />" readonly="readonly" /> --%>
						<input style="float: left; border: none; margin-top: 0px; width: 140px;" id="doe" name="doe" type="text" class="required" value="${gipiQuote.expiryDate}" readonly="readonly" />
						<img id="hrefExpiryDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('doe'),this, null);" class="hover" alt="Expiry Date" />
					</div>
					<!-- </span> -->
					<input id="expiryTag" name="expiryTag" type="checkbox" value="Y" style=" margin-left: 5px;" 
					<c:if test="${'Y' eq gipiQuote.expiryTag}">
						checked="checked"
					</c:if> /> TBA
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Condition </td>
				<td class="leftAligned" colspan="3">
					<select id="prorateFlag" name="prorateFlag" style="width: 171px;">
						<option value=""></option>
						<option value="1"
						<c:if test="${gipiQuote.prorateFlag eq 1}">
							selected="selected"
						</c:if>
						>Pro-rate</option>
						<option value="2"
						<c:if test="${gipiQuote.prorateFlag eq 2}">
							selected="selected"
						</c:if>
						>Straight</option>
						<option value="3"
						<c:if test="${gipiQuote.prorateFlag eq 3}">
							selected="selected"
						</c:if>
						>Short Rate</option>
					</select>
					<span id="prorateSelected" name="prorateSelected" style="display: none;">
						<input type="text" style="width: 50px;" id="noOfDays" name="noOfDays" value="${gipiQuote.noOfDays}" class="required"/> 
						<select id="compSw" name="compSw">
							<option value="Y"
							<c:if test="${gipiQuote.compSw eq 'Y'}">
								selected="selected"
							</c:if>
							>+1 day</option>
							<option value="M"
							<c:if test="${gipiQuote.compSw eq 'M'}">
								selected="selected"
							</c:if>
							>-1 day</option>
							<option value="N"
							<c:if test="${empty gipiQuote}">
								selected="selected"
							</c:if>
							<c:if test="${gipiQuote.compSw eq 'N'}">
								selected="selected"
							</c:if>
							>Ordinary</option>
						</select>
					</span>
					<span id="shortRateSelected" name="shortRateSelected" style="display: none;">
						<input type="text" id="shortRatePercent" name="shortRatePercent" class="required" style="width: 90px;" maxlength="12" value="${gipiQuote.shortRatePercent}" />
						<input type="hidden" id="tempDays" value=""/>
						<input type="hidden" id="calledFromNoOfDays" value="N"/>
					</span><!-- *moneyRate     percentRate -->
				</td>
			</tr>
		</table>
	</div>
</div>
<script>

	/*$("doe").observe("focus", function () {
		scwShow($('doe'),$('doe'), null);
	});

	$("doi").observe("focus", function () {
		scwShow($('doi'),$("doi"), null);
	});*/
	disableProrate();

	function disableProrate(){
		var days = $F("noOfDays");
		//var tempDays = $F("tempDays");
		
		var iDateArray = $F("doi").split("-");
		var iDate = new Date();
		var date = parseInt(iDateArray[1], 10);
		var month = parseInt(iDateArray[0], 10);
		var year = parseInt(iDateArray[2], 10);
		iDate.setFullYear(year, month-1, date);

		var eDateArray = $F("doe").split("-");
		var eDate = new Date();
		var edate = parseInt(eDateArray[1], 10);
		var emonth = parseInt(eDateArray[0], 10);
		var eyear = parseInt(eDateArray[2], 10);
		eDate.setFullYear(eyear, emonth-1, edate);

		var oneDay = 1000*60*60*24;
		var tempDays = Math.floor((parseInt(Math.floor(eDate.getTime() - iDate.getTime()))/oneDay));
		if(days == "" || tempDays == "365"){
			$("prorateFlag").selectedIndex = 1;
			$("prorateFlag").disable();
			$("noOfDays").hide();
			$("compSw").hide();
			$("shortRatePercent").hide();
	
		}else{
			$("prorateFlag").enable();
			$("noOfDays").show();
			$("compSw").show();
			$("shortRatePercent").show();	
		}		
		
	}
	

	$("doe").observe("blur", function () {
		computeNoOfDays();
		disableProrate();
	});

	$("doi").observe("blur", function () {
		//validateDOI();//added condition to validate date of inception BJGA 12.21.2010// REMOVED - Irwin 3.2.2011
		defaultExpiryDate();
		computeNoOfDays();
		disableProrate();
	});

	$("compSw").observe("change", function () {
		computeNoOfDays();
		if($F("compSw") == "N"){
			disableProrate();
		}
	});

	$("noOfDays").observe("blur", function (){
		$("calledFromNoOfDays").value = "Y";
		updateExpiryDate();
		if($F("compSw") == "N"){
			disableProrate();
		}
		$("calledFromNoOfDays").value = "N";
	});


	$("noOfDays").observe("keypress", function (event){
     	onEnterEvent(event, updateExpiryDate); 
	});

	$("shortRatePercent").observe("change", function(){
		var rate = $F("shortRatePercent");
		if ("" == rate){
			return false;
		} else if (isNaN(rate) || rate.split(".").size()>2){
			showWaitingMessageBox("Entered short rate percent is invalid. Valid value is from 0.000000001 to 100.000000000.", imgMessage.ERROR,
					function(){
				$("shortRatePercent").value = "";
				$("shortRatePercent").focus();
				});
			return false;
		} else if (parseFloat(rate) <= 0 || 
				parseFloat(rate) > 100){
			showWaitingMessageBox("Entered short rate percent is invalid. Valid value is from 0.000000001 to 100.000000000.", imgMessage.ERROR,
					function(){
				$("shortRatePercent").value = "";
				$("shortRatePercent").focus();
				});
			return false;
		} else {
			$("shortRatePercent").value = formatToNineDecimal(rate);
		}
	});

	function validateDOI(){
		var today = new Date();
		var incept = makeDate($F("doi"));
		var result = true;
		if (incept<today) {
			$('doi').focus();
			showWaitingMessageBox("Expiry date must not be earlier than incept date.", imgMessage.ERROR,
					function(){
						$("doi").value = "";
						$("doi").focus();
						$("doe").value = "";
				});
			return false;
		}
	}
	
	function defaultExpiryDate() {
	//	if ("" == $F("doe")){ //to avoid setting default expiry when doe is already filled out BJGA 12.21.2010  -- EDITED Back because expiry date must recompute every time the incept date changes.
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
			$("doe").value = (month < 10 ? "0" + month : month) + "-" + (date < 10 ? "0" + date : date) + "-" + year;
			//} 
		}
	}
	
	function updateExpiryDate()	{
		var expiryDate 			= Date.parse($F("doi"));
		var noOfDays            = $F("noOfDays");
		var yearLimit           = 9999;
		if (isNaN($F("noOfDays"))
				|| $F("noOfDays").split(" ").size() > 1){//added condition to handle spaces BJGA12.21.2010
			showMessageBox('Entered pro-rate number of days is invalid. Entered value should not result to a year greater than 9999.', imgMessage.ERROR);
			$('noOfDays').focus();
			$('noOfDays').value = "";
			$("doe").value = "";
		}else if($F("noOfDays").blank()){
			$("doe").value = "";
			//showMessageBox('Expiry Date is required.', imgMessage.ERROR); BJGA12.21.2010
		}else if("M" == $F("compSw") && $F("noOfDays") == "0"){
			showMessageBox("Tagging of -1 day will result to invalid no. of days. Changing is not allowed.",imgMessage.ERROR);
			$("doe").value = "";
			$("noOfDays").value = "";
		}else if("Y" == $F("compSw") && $F("noOfDays") == "0"){
			showMessageBox("Expiry date is invalid. Expiry date must be later than Inception date.",imgMessage.ERROR);
			$("doe").value = "";
			$("noOfDays").value = "";
		}else{
			if(expiryDate != null){
				var dec = true;
				if(dec == checkIfDecimal(noOfDays)){
					showMessageBox('Entered pro-rate number of days is invalid. Entered value should not result to a year greater than 9999.', imgMessage.ERROR);
					$('noOfDays').focus();
					$('noOfDays').value = "";
					$("doe").value = "";
				} else {		
					var daysToAdd 			= $("noOfDays").value;
	
					if($("compSw").value=="Y"){
						daysToAdd = daysToAdd - 1;
					} else if($("compSw").value=="M"){
						daysToAdd = parseInt(daysToAdd) + parseInt(1);
					} 

					daysToAdd = parseInt(daysToAdd);
					expiryDate 				= expiryDate.add(daysToAdd).days();
					$("doe").value 	=  expiryDate.format("mm-dd-yyyy"); //expiryDate.getMonth() + "-" + expiryDate.getDate() + "-" + expiryDate.getFullYear();
					if(yearLimit < expiryDate.getFullYear()){
						//showMessageBox('Expiry date is invalid. Expiry year should not exceed '+yearLimit, imgMessage.ERROR); BJGA12.21.2010
						showMessageBox('Entered pro-rate number of days is invalid. Entered value should not result to a year greater than 9999.', imgMessage.ERROR);
						$('noOfDays').focus();
						$('noOfDays').value = "";
						$("doe").value = "";
					} else if(noOfDays <= 0 || yearLimit < expiryDate.getFullYear()){
						//showMessageBox('Entered pro-rate number of days is invalid. ', imgMessage.ERROR); BJGA12.21.2010
						showMessageBox('Entered pro-rate number of days is invalid. Entered value should not result to a year greater than 9999. ', imgMessage.ERROR);
						$('noOfDays').focus();
						$('noOfDays').value = "";
						$("doe").value = "";
					} 
				}
			}	
		}
	}	

	function computeNoOfDays()	{
		if ($F("doi") == "" || $F("doe") == "") {
			return false;
		} else {
			var compSwAddtl = $F("compSw");
			var addtl = 0;
			if ("Y" == compSwAddtl) {
				addtl = 1;
			} else if ("M" == compSwAddtl) {
				addtl = -1;
			}
			var iDateArray = $F("doi").split("-");
			var iDate = new Date();
			var date = parseInt(iDateArray[1], 10);
			var month = parseInt(iDateArray[0], 10);
			var year = parseInt(iDateArray[2], 10);
			iDate.setFullYear(year, month-1, date);

			var eDateArray = $F("doe").split("-");
			var eDate = new Date();
			var edate = parseInt(eDateArray[1], 10);
			var emonth = parseInt(eDateArray[0], 10);
			var eyear = parseInt(eDateArray[2], 10);
			eDate.setFullYear(eyear, emonth-1, edate);

			if (eDate < iDate)	{
				showMessageBox("Expiry date must not be earlier than incept date.",imgMessage.ERROR);
				$("doe").value = "";

				return false;
			}else if("M" == compSwAddtl && $F("noOfDays") == "0"){
				showMessageBox("Tagging of -1 day will result to invalid no. of days. Changing is not allowed.",imgMessage.ERROR);
				$("doe").value = "";
				$("noOfDays").value = "";

			} else {
				var oneDay = 1000*60*60*24;
				var numberOfDays = Math.floor((parseInt(Math.floor(eDate.getTime() - iDate.getTime()))/oneDay)) + addtl;

				$("noOfDays").value = numberOfDays;

				if(numberOfDays <= 1){
					showNegativeSelection(false);  
				}
				else{
					showNegativeSelection(true);
				}
			}
		}
		// ADDED FOR CHANGE TAG - irwin
		changeTag = 1;
	}


	/**
	* Hides the -1 option in condition2 of prorate when the difference between Inception Date and Expiration Date <= 1.
	* 	Otherwise, shows the said option
	*	@author rencela
	*/
	function showNegativeSelection(willShow){
		var prorateOptions = $("compSw").options;
		for(var index = 0; index < prorateOptions.length; index++){
			if(prorateOptions[index].value=="M"){
				if(willShow ==true)
					prorateOptions[index].show();
				else
					prorateOptions[index].hide();
				break;
			}
		}
	}

	$("prorateFlag").observe("change", showRelatedSpan);

	function showRelatedSpan()	{
		if ($F("prorateFlag") == 1)	{
			$("shortRateSelected").hide();
			$("prorateSelected").show();
			<c:if test="${empty gipiQuote}">
				$("compSw").selectedIndex = 2;
			</c:if>
			$("shortRatePercent").value = "";
			computeNoOfDays();
		} else if ($F("prorateFlag") == 3) {
			$("prorateSelected").hide();			
			$("shortRateSelected").show();
			$("noOfDays").value = "";
		} else {
			$("shortRateSelected").hide();
			$("prorateSelected").hide();
			$("noOfDays").value = "";
			$("shortRatePercent").value = "0.00000000";
		}
	}

	/*<c:if test="${empty gipiQuote}">
		$("prorateFlag").selectedIndex = 2;
	</c:if> replaced by: Nica 06.04.2012*/
	
	<c:choose>
		<c:when test="${empty gipiQuote}">
			$("prorateFlag").selectedIndex = 2;
		</c:when>
		<c:otherwise>
			$("prorateFlag").value = '${gipiQuote.prorateFlag}';
		</c:otherwise>
	</c:choose>
	
	addStyleToInputs();
	initializeAll();
	showRelatedSpan();
	
	objGIPIQuote.disableProrate = disableProrate; //added by robert 9.20.2012
	
	$("shortRatePercent").value = formatToNineDecimal('${gipiQuote.shortRatePercent}'); 
</script>