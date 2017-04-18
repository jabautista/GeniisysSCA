<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="additionalInformationDiv" name="additionalInformationDiv" style="display: none;">
<div class="sectionDiv" id="additionalInformationSectionDiv" name="additionalInformationSectionDiv" style="overflow: visible; display: none;">
	<form id="marineCargoAdditionalInformationForm" name="marineCargoAdditionalInformationForm">
		<table id="additionalInformationTable" align="center" style="width: 80%; margin-top: 10px; margin-bottom: 10px;">
			<tr>
				<td class="rightAligned" style="width: 150px;">Geography Description</td>
				<td class="leftAligned">
					<select id="geogCd" name="geogCd" style="width: 218px;" class="aiInput">
						<option value=""></option>
						<c:forEach var="g" items="${geogs}">
							<option value="${g.geogCd}">${g.geogType} - ${g.geogDesc}</option>
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" style="width: 80px;">Voyage No</td>
				<td class="leftAligned">
					<input type="text" id="voyageNo" name="voyageNo" style="width: 210px;" value="${quoteItemMn.voyageNo}" maxlength="30" class="aiInput"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Carrier</td>
				<td class="leftAligned">
					<select id="vesselCd" name="vesselCd" style="width: 218px;" class="required hover" > <!-- emsy 12.16.2011 modified class to "required hover"-->
						<option value=""></option>
						<c:forEach var="c" items="${quoteVessels}">
							<option value="${c.vesselCd}">${c.vesselName}</option>
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned">LC No</td>
				<td class="leftAligned">
					<input type="text" id="lcNo" name="lcNo" style="width: 210px;" value="${quoteItemMn.lcNo}" maxlength="30" class="aiInput"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Cargo Class</td>
				<td class="leftAligned" colspan="3">
					<%-- ~ emsy 12.05.2011  
					<select id="cargoClassCd" name="cargoClassCd" style="width: 550px;" class="aiInput">
						<option value=""></option>
						<c:forEach var="cc" items="${cargoClasses}">
							<option value="${cc.cargoClassCd}" title="${cc.cargoClassDesc}">${cc.cargoClassDesc}</option>
						</c:forEach>
					</select> --%>
					<div style="float:left; border: solid 1px gray; width: 550px; height: 21px; margin-right:4px; " class="aiInput">
						<input type="hidden" id="cargoClassCd" name="cargoClassCd" />
						<input type="text" tabindex="1505" style="float: left; margin-top: 0px; margin-right: 3px; width: 520px; border: none;" name="cargoClass" id="cargoClass" class="aiInput" value="" tabindex="19" />
						<img id="hrefCargoClass" alt="goCargoClass" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />
					</div>	
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Cargo Type</td>
				<td class="leftAligned">
					<%-- emsy 12.05.2011
					 <select id="cargoType" name="cargoType" style="width: 218px;" class="aiInput">
						<option value=""></option>
						<c:forEach var="ct" items="${cargoTypes}">
							<option value="${ct.cargoType}" cd="${ct.cargoClassCd}">${ct.cargoTypeDesc}</option>
						</c:forEach>
					</select> --%>
					<div style="float:left; border: solid 1px gray; width: 216px; height: 21px; margin-right:4px;" class="aiInput">
						<input type="hidden" id="cargoType" name="cargoType" />
						<input tabindex="1508" type="text" tabindex="17" style="float: left; margin-top: 0px; margin-right: 3px; width: 189px; border: none;  name="cargoTypeDesc" id="cargoTypeDesc" readonly="readonly" class="aiInput" value=""/>
						<img id="hrefCargoType" alt="goCargoType" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />
					</div>		
				</td>
				<td class="rightAligned">Print?</td>
				<td class="leftAligned">
					<select id="printTag" name="printTag" style="width: 218px;" class="aiInput">
						<option value=""></option>
						<c:forEach var="pt" items="${printTags}">
							<option value="${pt.rvLowValue}">${pt.rvMeaning}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">ETD</td>
				<td class="leftAligned">
					<span style="width: 218px;">
						<input type="text" id="etd" name="etd" style="width: 185px;" value="<fmt:formatDate pattern="MM-dd-yyyy" value="${quoteItemMn.etd}" />" readonly="readonly" />
						<img id="imgEtd" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="$('etd').focus(); scwShow($('etd'),this, null);" style="margin: 0;" alt="Go" class="aiInput"/>
					</span>
				</td>
				<td class="rightAligned">ETA</td>
				<td class="leftAligned">
					<span style="width: 98px;">
						<input type="text" id="eta" name="eta" style="width: 210px;" value="<fmt:formatDate pattern="MM-dd-yyyy" value="${quoteItemMn.eta}" />" readonly="readonly" />
						<img id="imgEta" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="$('eta').focus(); scwShow($('eta'),this, null);"  style="margin: 0;" alt="Go" class="aiInput"/>
					</span>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Type of Packing</td>
				<td class="leftAligned">
					<input type="text" id="packMethod" name="packMethod" value="${quoteItemMn.packMethod}" style="width: 210px;" maxlength="50" class="aiInput"/>
				</td>
				<td class="rightAligned">BL/AWB</td>
				<td class="leftAligned">
					<input type="text" id="blAwb" name="blAwb" value="${quoteItemMn.blAwb}" style="width: 210px;" maxlength="30" class="aiInput"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Transhipment Origin</td>
				<td class="leftAligned">
					<input type="text" id="transhipOrigin" name="transhipOrigin" value="${quoteItemMn.transhipOrigin}" style="width: 210px;" maxlength="30" class="aiInput"/>
				</td>
				<td class="rightAligned">Origin</td>
				<td class="leftAligned">
					<input type="text" id="origin" name="origin" value="${quoteItemMn.origin}" style="width: 210px;" maxlength="50" class="aiInput"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Transhipment Destination</td>
				<td class="leftAligned">
					<input type="text" id="transhipDestination" name="transhipDestination" value="${quoteItemMn.transhipDestination}" style="width: 210px;" maxlength="30" class="aiInput"/>
				</td>
				<td class="rightAligned">Destination</td>
				<td class="leftAligned">
					<input type="text" id="destn" name="destn" value="${quoteItemMn.destn}" style="width: 210px;" maxlength="50" class="aiInput"/>
				</td>
			</tr>
		</table>
		<div style="margin-left: auto; margin-right: auto; margin-bottom: 20px;">
			<input type="button" id="aiMRUpdateBtn" name="aiMRUpdateBtn" value="Apply Changes" class="disabledButton"/>  <!-- edited by steven 11/7/2012 binago ko ung id niya kasi parehas siya sa ibang jsp na tinatawag dito kaya nag-eerror ung function --> 
		</div>
	</form>
</div>
</div>
<script>
	try{
		initializeAll();
		function validateAndSave(){
			if(isMarineCargoAdditionalInfoValid()!=false){
				new Ajax.Request(contextPath+"/GIPIQuotationMarineCargoController?action=save", {
					method: "POST",
					postBody: Form.serialize("marineCargoAdditionalInformationForm"),
					onCreate: function () {
						showNotice("Saving, please wait...");
						$("marineCargoAdditionalInformationForm").disable();
					},
					onComplete: function (response){
						if (checkErrorOnResponse(response)){
							hideNotice(response.responseText);
							$("marineCargoAdditionalInformationForm").enable();
							if ("SUCCESS" == response.responseText) {
								showNotice("SUCCESS");
							}
						}
					}
				});
			}
		}
		/* emsy 12.05.2011 ~ not needed
		function filterCargoTypes() {
			if ($F("cargoClassCd") != ""){
				var cargoClassCd = $F("cargoClassCd");
				var cargoTypeCd = $("cargoType").options[$("cargoType").selectedIndex].getAttribute("cargoType");
		
				for (var i = 0; i<$("cargoType").length; i++){
					if (cargoClassCd != $("cargoType").options[i].getAttribute("cd")){
						$("cargoType").options[i].hide();
						$("cargoType").options[i].disabled = true;
						$("cargoType").options[0].show();
						$("cargoType").options[0].disabled = false;
					} else if(cargoClassCd == $("cargoType").options[i].getAttribute("cd")  ){
						$("cargoType").options[i].show();
						$("cargoType").options[i].disabled = false;
						if($("cargoType").options[i].value == cargoTypeCd){
							$("cargoType").selectedIndex = i; 
						}
					}
				}
			}	
			*/
			/* made into a comment by grace 09242010
			   replaced by the codes written above
			   to resolve error when the list for cargoType is null
			   whenver the cargoClass is null */
			/*$("cargoType${aiItemNo}").childElements().invoke("show");
			$("cargoType${aiItemNo}").childElements().each(function (c) {
				if (c.getAttribute("cd") != $F("cargoClassCd${aiItemNo}")) {
					c.show();
				}
			});*/	
		//}
		
		// ~ emsy 12.05.2011 commented next two lines
		//$("cargoClassCd").observe("change", filterCargoTypes);
		//filterCargoTypes();
		
		$("hrefCargoClass").observe("click", showCargoClassLOV);
		$("cargoClass").observe("keyup", function(event){
			if(event.keyCode == 46){
				$("cargoClassCd").value = "";
				$("cargoType").value = "";
				$("cargoTypeDesc").value = "";
			}
		});
		
		$("hrefCargoType").observe("click", function(){	showCargoTypeLOV($F("cargoClassCd"));	});
		$("cargoTypeDesc").observe("keyup", function(event){
			if(event.keyCode == 46){
				$("cargoType").value = "";
				$("cargoTypeDesc").value = "";	
			}		
		});
		
		$("eta").setStyle("border: none; width: 185px; margin: 0;");
		$("eta").up("span", 0).setStyle("float: left; border: 1px solid gray; padding: 0; background-color: #fff; width: 216px;");
	
		$("etd").setStyle("border: none; width: 185px; margin: 0;");
		$("etd").up("span", 0).setStyle("float: left; border: 1px solid gray; padding: 0; background-color: #fff; width: 216px;");
	
		//commented by: nica 06.13.2011
		//var inceptDate = makeDate($F("txtInceptionDate"));
		//var expiryDate = makeDate($F("txtExpirationDate"));
	
		$("eta").observe("blur", function () {
			// modified by: nica 06.13.2011 - to be reusable by package quotation
			var inceptDate = makeDate(objMKGlobal.packQuoteId != null ? objCurrPackQuote.inceptDate : $F("txtInceptionDate"));
			var expiryDate = makeDate(objMKGlobal.packQuoteId != null ? objCurrPackQuote.expiryDate : $F("txtExpirationDate"));
			var etd = makeDate($F("etd"));
			var eta = makeDate($F("eta"));
	
			if (compareDatesIgnoreTime(etd,eta)==-1) {
				showQuotationListingError("ETA must not be earlier than ETD.");
				$("eta").value = "";
				$("eta").focus();
			} else if(compareDatesIgnoreTime(eta,inceptDate)==1 || compareDatesIgnoreTime(eta,expiryDate)==-1){
				showQuotationListingError("ETD and ETA must be within the Inception Date and Expiry Date.");
				$("eta").value = "";
				$("eta").focus();
			}
		});
	
		$("etd").observe("blur", function () {
			// modified by: nica 06.13.2011 - to be reusable by package quotation
			var inceptDate = makeDate(objMKGlobal.packQuoteId != null ? objCurrPackQuote.inceptDate : $F("txtInceptionDate"));
			var expiryDate = makeDate(objMKGlobal.packQuoteId != null ? objCurrPackQuote.expiryDate : $F("txtExpirationDate"));
			var etd = makeDate($F("etd"));
			var eta = makeDate($F("eta"));
			if (eta < etd) {
				showQuotationListingError("ETA must not be earlier than ETD.");
				$("etd").value = "";
				$("etd").focus();
			} else if((etd < inceptDate) || (etd > expiryDate)){
				showQuotationListingError("ETD and ETA must be within the Inception Date and Expiry Date.");
				$("etd").value = "";
				$("etd").focus();
			}
		});
	
		function isMarineCargoAdditionalInfoValid(){
			// modified by: nica 06.13.2011 - to be reusable by package quotation
			var inceptDate = makeDate(objMKGlobal.packQuoteId != null ? objCurrPackQuote.inceptDate : $F("txtInceptionDate"));
			var expiryDate = makeDate(objMKGlobal.packQuoteId != null ? objCurrPackQuote.expiryDate : $F("txtExpirationDate"));
			var eta = makeDate($F("eta"));
			var etd = makeDate($F("etd"));
	
			if(eta<etd){
				showQuotationListingError("ETA must not be earlier than ETD.");
				return false;
			} else if((eta < inceptDate) || (eta > expiryDate )){
				showQuotationListingError("ETA and ETD must be within the Inception Date and Expiry Date.");
				return false;
			} else if((etd < inceptDate) || (etd > expiryDate)){
				showQuotationListingError("ETA and ETD must be within the Inception Date and Expiry Date.");
				return false;
			} else{
				hideNotice();
			}
		}
		
		//initializeAccordion(); 
		initializeAiType("aiMRUpdateBtn");
		$("aiMRUpdateBtn").observe("click", function(){
			//emsy 12.19.2011 -- added if-else to check if required field is null 
			if( $("vesselCd").value == "" ) {
				showMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR);
			}
			else{
				fireEvent($("btnAddItem"), "click");
				clearChangeAttribute("additionalInformationSectionDiv");
			}
		});
	}catch(e){
		showErrorMessage("error in marineCargoAdditionalInformation.jsp",  e);
	}

</script>