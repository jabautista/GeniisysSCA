<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" >
   		<label>Address &amp; Contact</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" id="lblHideAddressContact" style="margin-left: 5px;">Hide</label>
   		</span>
   	</div>
</div>

<div id="assuredAndContactDiv" class="sectionDiv">
	<table align="center" border="0" style="margin: 10px auto; padding-bottom: 10px; border-bottom: 1px solid silver;">
		<tr>
			<td class="rightAligned" style="width: 100px;">
				Mailing Address </td>
			<td class="leftAligned">
				<input type="text" id="mailAddress1" name="mailAddress1" style="width: 210px;" tabindex="23" maxlength="50" value="${assured.mailAddress1}" class="required" /></td>
			<td class="rightAligned" style="width: 100px;">
				Billing Address </td>
			<td class="leftAligned">
				<input type="text" id="billAddress1" name="billAddress1" style="width: 210px;" tabindex="26" maxlength="50" value="${assured.billingAddress1}" /></td>
		</tr>
		<tr>
			<td></td>
			<td class="leftAligned">
				<input type="text" id="mailAddress2" name="mailAddress2" style="width: 210px;" tabindex="24" maxlength="50" value="${assured.mailAddress2}" /></td>
			<td></td>
			<td class="leftAligned">
				<input type="text" id="billAddress2" name="billAddress2" style="width: 210px;" tabindex="27" maxlength="50" value="${assured.billingAddress2}" /></td>
		</tr>
		<tr>
			<td></td>
			<td class="leftAligned">
				<input type="text" id="mailAddress3" name="mailAddress3" style="width: 90px;" tabindex="25" maxlength="50" value="${assured.mailAddress3}" />
				<span class="rightAligned">Zip Code </span>
				<input type="text" id="zipCode" name="zipCode" style="width: 52px;" tabindex="28" maxlength="12" value="${assured.zipCode}" /></td>
			<td></td>
			<td class="leftAligned">
				<input type="text" id="billAddress3" name="billAddress3" style="width: 210px;" tabindex="29" maxlength="50" value="${assured.billingAddress3}" /></td>
		</tr>
	</table>

	<table align="center" border="0" style="margin: 10px auto; padding-bottom: 10px;">
		<tr>
			<td class="rightAligned" style="width: 100px;">Default Cell No </td>
			<td class="leftAligned">
				<input type="text" id="cpNo" name="cpNo" style="width: 210px;" tabindex="30" maxlength="40" value="${assured.cpNo}" lastValidValue=""/></td>
			<td class="rightAligned" style="width: 100px;">Globe Cell No </td>
			<td class="leftAligned">
				<input type="text" id="globeNo" name="globeNo" style="width: 210px;" tabindex="32" maxlength="40" value="${assured.globeNo}" lastValidValue=""/></td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 100px;">Sun Cell No </td>
			<td class="leftAligned">
				<input type="text" id="sunNo" name="sunNo" style="width: 210px;" tabindex="31" maxlength="40" value="${assured.sunNo}" lastValidValue=""/>
			</td>
			<td class="rightAligned" style="width: 100px;">Smart Cell No </td>
			<td class="leftAligned">
				<input type="text" id="smartNo" name="smartNo" style="width: 210px;" tabindex="33" maxlength="40" value="${assured.smartNo}" lastValidValue=""/>
			</td>
		</tr>
	</table>
	
<%-- 	<table align="center" border="0" style="margin-top: 10px; padding-left: 61px;">
		<tr>
			<td colspan="2" class="rightAligned" style="float: left;">
				Global Contact Numbers </td>
		</tr>
		<tr>
			<td style="text-align: left;">
				<div id="contactNumbers" name="contactNumbers" style="width: 500px;">
					<div>
						<select id="contactNoType" style="display: none;">
							<option value=""></option>
							<c:forEach var="c" items="${contactNoTypes}">
								<option value="${c.rvLowValue}">${c.rvMeaning}</option>
							</c:forEach>
						</select>
						<c:choose>
							<c:when test="${not empty assured}">
								<c:if test="${not empty assured.phoneNo}">
									<select id="cNo" name="contactNoType" style="width: 218px;" tabindex="29">
										<option value=""></option>
										<c:forEach var="c" items="${contactNoTypes}">
											<option value="${c.rvLowValue}"
												<c:if test="${c.rvLowValue eq 'PHONE_NO'}">
													selected="selected"
												</c:if>
											>${c.rvMeaning}</option>
										</c:forEach>
									</select>
									<input type="text" id="phoneNo" name="number" style="width: 210px;" tabindex="30" maxlength="40" value="${assured.phoneNo}" />
								</c:if>
								
								<c:if test="${not empty assured.cpNo}">
									<select id="cNo" name="contactNoType" style="width: 218px;" tabindex="29">
										<option value=""></option>
										<c:forEach var="c" items="${contactNoTypes}">
											<option value="${c.rvLowValue}"
												<c:if test="${c.rvLowValue eq 'CP_NO'}">
													selected="selected"
												</c:if>
											>${c.rvMeaning}</option>
										</c:forEach>
									</select>
									<input type="text" id="cellphoneNo" name="number" style="width: 210px;" tabindex="30" maxlength="40" value="${assured.cpNo}" />
								</c:if>
								
								<c:if test="${not empty assured.sunNo}">
									<select id="cNo" name="contactNoType" style="width: 218px;" tabindex="29">
										<option value=""></option>
										<c:forEach var="c" items="${contactNoTypes}">
											<option value="${c.rvLowValue}"
												<c:if test="${c.rvLowValue eq 'SUN_NO'}">
													selected="selected"
												</c:if>
											>${c.rvMeaning}</option>
										</c:forEach>
									</select>
									<input type="text" id="sunNo" name="number" style="width: 210px;" tabindex="30" maxlength="40" value="${assured.sunNo}" />
								</c:if>
								
								<c:if test="${not empty assured.globeNo}">
									<select id="cNo" name="contactNoType" style="width: 218px;" tabindex="29">
										<option value=""></option>
										<c:forEach var="c" items="${contactNoTypes}">
											<option value="${c.rvLowValue}"
												<c:if test="${c.rvLowValue eq 'GLOBE_NO'}">
													selected="selected"
												</c:if>
											>${c.rvMeaning}</option>
										</c:forEach>
									</select>
									<input type="text" id="globeNo" name="number" style="width: 210px;" tabindex="30" maxlength="40" value="${assured.globeNo}" />
								</c:if>
								
								<c:if test="${not empty assured.smartNo}">
									<select id="cNo" name="contactNoType" style="width: 218px;" tabindex="29">
										<option value=""></option>
										<c:forEach var="c" items="${contactNoTypes}">
											<option value="${c.rvLowValue}"
												<c:if test="${c.rvLowValue eq 'SMART_NO'}">
													selected="selected"
												</c:if>
											>${c.rvMeaning}</option>
										</c:forEach>
									</select>
									<input type="text" id="smartNo" name="number" style="width: 210px;" tabindex="30" maxlength="40" value="${assured.smartNo}" />
								</c:if>
							</c:when>
							<c:otherwise>
								<select id="cNo" name="contactNoType" style="width: 218px;" tabindex="29">
									<option value=""></option>
									<c:forEach var="c" items="${contactNoTypes}">
										<option value="${c.rvLowValue}">${c.rvMeaning}</option>
									</c:forEach>
								</select>
								<input type="text" name="number" style="width: 210px;" tabindex="30" maxlength="40" />
							</c:otherwise>							
						</c:choose>
					</div>
				</div>
				<input type="button" class="button" name="addNo" id="addNo" value="Add No." style="margin: 10px 187px;" tabindex="31" />
			</td>
		</tr>
	</table> --%>
</div>

<script>
	//robert 07.13.11
	var defaultNo = "";
	var defaultMailAdd1 = ""; //added by steven 8/30/2012
	var defaultMailAdd2 = ""; //added by steven 8/30/2012
	var defaultMailAdd3 = ""; //added by steven 8/30/2012
	var defaultBillAdd1 = ""; //added by steven 8/30/2012
	var defaultBillAdd2 = ""; //added by steven 8/30/2012
	var defaultBillAdd3 = ""; //added by steven 8/30/2012
	objUW.hidObjGIISS006B = {}; //added by steven 8/30/2012
	objUW.hidObjGIISS006B.modifySw = "N"; //marco - 07.09.2014
	
	$("cpNo").observe("focus", function(){
		defaultNo = this.value;
		$("cpNo").setAttribute("lastValidValue", $F("cpNo"));
	});

	$("cpNo").observe("change", function(){
		if($F("cpNo") != ""){
			checkAssdMobileNo(this.value);
		} else if ($("cpNo").value == "" && ($("globeNo").value != "" || $("sunNo").value != "" || $("smartNo").value != "" )){
			showWaitingMessageBox("You cannot delete the default mobile number.", imgMessage.ERROR, function(){$("cpNo").value = $("cpNo").getAttribute("lastValidValue"); $("cpNo").focus();});
		}
	});

	function checkAssdMobileNo(cellNo){
		new Ajax.Request(contextPath+"/GIISAssuredController", {
			method: "POST",
			parameters: {action : "checkAssdMobileNo",
								cellNo : cellNo},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var arr = response.responseText.split(",");
					var network = arr[0];
					var msg = arr[1];
					if(network == ""){
						showWaitingMessageBox("Not a valid smart, sun or globe cell number.", imgMessage.ERROR, function(){$("cpNo").value = defaultNo; $("cpNo").focus();});
					} else if (network == "GLOBE") {
						if($("globeNo").value == "") {
							$("globeNo").value = cellNo;
						}else if($F("globeNo") != cellNo){ //marco - 07.08.2014
							showConfirmBox("Confirmation", "Do you want to change your globe mobile no?", "Yes", "No", 
									function(){$("globeNo").value = cellNo;}, 
									function(){showMessageBox("You cannot set a default number that is not found on your available mobile nos.", imgMessage.ERROR);
													 $("cpNo").value = $("globeNo").value;});
						}
					} else if (network == "SMART") {
						if($("smartNo").value == "") {
							$("smartNo").value = cellNo;
						}else if($F("smartNo") != cellNo){ //marco - 07.08.2014
							showConfirmBox("Confirmation", "Do you want to change your smart mobile no?", "Yes", "No", 
									function(){$("smartNo").value = cellNo;}, 
									function(){showMessageBox("You cannot set a default number that is not found on your available mobile nos.", imgMessage.ERROR);
													 $("cpNo").value = $("smartNo").value;});
						}
					} else if (network == "SUN") {
						if($("sunNo").value == "") {
							$("sunNo").value = cellNo;
						}else if($F("sunNo") != cellNo){ //marco - 07.08.2014
							showConfirmBox("Confirmation", "Do you want to change your sun mobile no?", "Yes", "No", 
									function(){$("sunNo").value = cellNo;},
									function(){showMessageBox("You cannot set a default number that is not found on your available mobile nos.", imgMessage.ERROR);
													 $("cpNo").value = $("sunNo").value;});
						}				
					}  
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	$("globeNo").observe("focus", function(){
		defaultNo = this.value;
		$("globeNo").setAttribute("lastValidValue", $F("globeNo"));
	});
	
	$("globeNo").observe("change", function(){
		if($F("globeNo") != ""){
			checkGlobeNo(this.value);
		} else if ($("globeNo").value == "" && $("cpNo").value == $("globeNo").getAttribute("lastValidValue")){
			showWaitingMessageBox("You cannot delete the default cellphone number.", imgMessage.ERROR, 
												function(){$("globeNo").value = $("globeNo").getAttribute("lastValidValue");});
		}
	}); 
	
	function checkGlobeNo(cellNo){
		new Ajax.Request(contextPath+"/GIISAssuredController", {
			method: "POST",
			parameters: {	action : "checkAssdMobileNo",
								cellNo : cellNo },
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var arr = response.responseText.split(",");
					var network = arr[0];
					if(network != "GLOBE"){
						//$("globeNo").value = ""; // added by: Nica 06.13.2012
						$("globeNo").value = $("globeNo").getAttribute("lastValidValue"); //marco - 07.08.2014
						customShowMessageBox("Invalid Globe mobile number.", imgMessage.ERROR, "globeNo");
					} else{
						function generateDefaultCpNO() {
							$("cpNo").value = cellNo;
						} ;
						if ($F("cpNo") == ""){
							generateDefaultCpNO();
						} else {
							showConfirmBox("Confirm", "Do you want to change your default cellphone number?", 
									"Yes", "No", generateDefaultCpNO,  "");
						}
					}
				}
			}
		});
	}
	
	$("sunNo").observe("focus", function(){
		defaultNo = this.value;
		$("sunNo").setAttribute("lastValidValue", $F("sunNo"));
	});
	
	$("sunNo").observe("change", function(){
		if($F("sunNo") != ""){
			checkSunNo(this.value);
		} else if ($("sunNo").value == "" && $("cpNo").value == $("sunNo").getAttribute("lastValidValue")){
			showWaitingMessageBox("You cannot delete the default cellphone number.", imgMessage.ERROR, 
												function(){$("sunNo").value = $("sunNo").getAttribute("lastValidValue");});
		}
	});
	
	function checkSunNo(cellNo){
		new Ajax.Request(contextPath+"/GIISAssuredController", {
			method: "POST",
			parameters: {	action : "checkAssdMobileNo",
								cellNo : cellNo },
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var arr = response.responseText.split(",");
					var network = arr[0];
					if(network != "SUN"){
						//$("sunNo").value = ""; // added by: Nica 06.13.2012
						$("sunNo").value = $("sunNo").getAttribute("lastValidValue"); //marco - 07.08.2014
						customShowMessageBox("Invalid Sun mobile number.", imgMessage.ERROR, "sunNo");
					} else{
						function generateDefaultCpNO() {
							$("cpNo").value = cellNo;
						} ;
						if ($F("cpNo") == ""){
							generateDefaultCpNO();
						} else {
							showConfirmBox("Confirm", "Do you want to change your default cellphone number?", 
									"Yes", "No", generateDefaultCpNO,   "");
						}
					}
				}
			}
		});
	}
	
	$("smartNo").observe("focus", function(){
		defaultNo = this.value;
		$("smartNo").setAttribute("lastValidValue", $F("smartNo"));
	});
	
	$("smartNo").observe("change", function(){
		if($F("smartNo") != ""){
			checkSmartNo(this.value);
		} else if ($("smartNo").value == "" && $("cpNo").value == $("smartNo").getAttribute("lastValidValue")){
			showWaitingMessageBox("You cannot delete the default cellphone number.", imgMessage.ERROR, 
												function(){$("smartNo").value = $("smartNo").getAttribute("lastValidValue");});
		}
	});
	
	function checkSmartNo(cellNo){
		new Ajax.Request(contextPath+"/GIISAssuredController", {
			method: "POST",
			parameters: {	action : "checkAssdMobileNo",
								cellNo : cellNo },
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var arr = response.responseText.split(",");
					var network = arr[0];
					if(network != "SMART"){
						//$("smartNo").value = ""; // added by: Nica 06.13.2012
						$("smartNo").value = $("smartNo").getAttribute("lastValidValue"); //marco - 07.08.2014
						customShowMessageBox("Invalid Smart mobile number.", imgMessage.ERROR, "smartNo");
					} else{
						function generateDefaultCpNO() {
							$("cpNo").value = cellNo;
						} ;
						if ($F("cpNo") == ""){
							generateDefaultCpNO();
						} else {
							showConfirmBox("Confirm", "Do you want to change your default cellphone number?", 
									"Yes", "No", generateDefaultCpNO,  "");
						}
					}
				}
			}
		});
	}

	
	$("mailAddress1").observe("focus", function(){ //added by steven 8/30/2012
		defaultMailAdd1 = this.value;
	}); 
	$("mailAddress2").observe("focus", function(){ //added by steven 8/30/2012
		defaultMailAdd2 = this.value;
	}); 
	$("mailAddress3").observe("focus", function(){ //added by steven 8/30/2012
		defaultMailAdd3 = this.value;
	}); 
	$("billAddress1").observe("focus", function(){ //added by steven 8/30/2012
		defaultBillAdd1 = this.value;
	}); 
	$("billAddress2").observe("focus", function(){ //added by steven 8/30/2012
		defaultBillAdd2 = this.value;
	}); 
	$("billAddress3").observe("focus", function(){ //added by steven 8/30/2012
		defaultBillAdd3 = this.value;
	}); 
	
	
	$("mailAddress1").observe("change", function(){ //added by steven 8/30/2012
		checkChanges("mailAddress1",defaultMailAdd1);
	}); 
	$("mailAddress2").observe("change", function(){ //added by steven 8/30/2012
		checkChanges("mailAddress2",defaultMailAdd2);
	}); 
	$("mailAddress3").observe("change", function(){ //added by steven 8/30/2012
		checkChanges("mailAddress3",defaultMailAdd3);
	}); 
	$("billAddress1").observe("change", function(){ //added by steven 8/30/2012
		checkChanges("billAddress1",defaultBillAdd1);
	}); 
	$("billAddress2").observe("change", function(){ //added by steven 8/30/2012
		checkChanges("billAddress2",defaultBillAdd2);
	}); 
	$("billAddress3").observe("change", function(){ //added by steven 8/30/2012
		checkChanges("billAddress3",defaultBillAdd3);
	}); 
	
	function checkChanges(id,val) {  //added by steven 8/30/2012
		if($("assuredNo").value != null && $("assuredNo").value != "" && nvl(objUW.hidObjGIISS006B.modifySw, "N") == "N"){
			showConfirmBox("Confirm","You are about to modify an assured with"+$F("vLine")+" policy.","Continue", "Cancel",
					function(){
						objUW.hidObjGIISS006B.modifySw = "Y";
					},
					function(){
						$(id).value = val;
					});
		}
	}
	objUW.hidObjGIISS006B.checkChanges = checkChanges;
</script>
