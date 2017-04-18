<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" >
   		<label>Basic Information - <span id="selectedAssuredType">Corporate</span></label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" id="lblHideBasicInformation" style="margin-left: 5px;">Hide</label>
   		</span>
   	</div>
</div>

<div id="basicInformationDiv" class="sectionDiv">
	<input type="hidden" id="assdName" name="assdName" value="${assured.assdName}" />
	<input type="hidden" id="nameOrder" name="nameOrder" value="${nameOrder}" />
	<input type="hidden" id="vLine" name="vLine" value="${vLine }" />
	<table align="center" style="margin: 10px auto;">
		<tr>
			<td class="rightAligned" style="width: 100px;" id="assuredNoTd">
				Assured No. </td>
			<td class="leftAligned">
				<input type="text" id="generatedAssuredNo" name="generatedAssuredNo" style="width: 100px; margin-right: 20px;" readonly="readonly" tabindex="7" value="${assured.assdNo}" />
				<input type="checkbox" value="" id="activeTag" name="activeTag" tabindex="8"
				<c:if test="${assured.activeTag eq 'Y'}">
					checked="checked"
				</c:if>
				 />
				<span class="rightAligned"><label for="activeTag" style="float: right; margin: 5px 10px 0px 0px;">Active Tag </label></span></td>
			<td class="rightAligned" style="width: 100px;" name="forPersonal">
				Designation </td>
			<td class="leftAligned" name="forPersonal">
				<select style="width: 218px;" id="designation" name="designation" tabindex="9">
					<option value=""></option>
					<c:forEach var="d" items="${designations}">
						<option value="${d.rvLowValue}"
						<c:if test="${assured.designation eq d.rvLowValue}">
							selected="selected"
						</c:if>
						>${d.rvMeaning}</option>
					</c:forEach>
				</select></td>
		</tr>
		<tr name="forPersonal">
			<td class="rightAligned">
				Last Name </td> 
			<td class="leftAligned" colspan="3">
				<input type="text" id="lastName" name="lastName" style="width: 541px;" maxlength="244" tabindex="10" value="${assured.lastName}" class="upper" /></td>
		</tr>
		<tr name="forPersonal">
			<td class="rightAligned">
				First Name </td> 
			<td class="leftAligned" colspan="3">
				<input type="text" id="firstName" name="firstName" style="width: 541px;" maxlength="244" tabindex="11" value="${assured.firstName}" class="upper" /></td>
		</tr>		
		<tr name="forPersonal">
			<td class="rightAligned">
				Middle Initial </td>
			<td class="leftAligned">
				<input type="text" id="middleInitial" name="middleInitial" style="width: 210px;" maxlength="2" tabindex="12" value="${assured.middleInitial}" class="upper" /></td>
			<td class="rightAligned">
				Suffix </td> 
			<td class="leftAligned">
				<select style="width: 218px;" id="suffix" name="suffix" tabindex="13">
					<option value=""></option>
					<c:forEach var="s" items="${suffices}">
						<option value="${s.rvLowValue}"
							<c:if test="${assured.suffix eq s.rvLowValue}">
								selected
							</c:if> 
						>${s.rvMeaning}</option>
					</c:forEach>
				</select></td>
		</tr>
		<tr name="forCorporate" style="display: none;">
			<td class="rightAligned">
				Assured/Principal </td> 
			<td class="leftAligned" colspan="3">
				<input type="text" id="assuredNameMaint" name="assuredNameMaint" style="width: 541px;" maxlength="500" tabindex="14" value="${assured.assdName}" class="required upper" /></td>
		</tr>
		
		<!-- added by robert -->
		<tr name="forCorporate">
		    <td style="width: 100px"></td>
			<td class="leftAligned" colspan="3">
				<input type="text" id="assuredName2Corp" name="assuredName2Corp" style="width: 541px;" maxlength="50" tabindex="15" value="${assured.assuredName2}" class="upper" /></td>
		</tr>
		
		<tr name="forJoint" style="display: none;">
		    <td style="width: 100px"></td>
			<td class="leftAligned" colspan="3">
				<input type="text" id="assuredName2" name="assuredName2" style="width: 541px;" maxlength="500" tabindex="15" value="${assured.assuredName2}" class="upper" /></td>
		</tr>
		
		<tr><td colspan="4" style="height: 10px; border-bottom: 1px solid #E0E0E0;"></td></tr>
		<tr><td style="height: 10px;"></td></tr>
		
		<tr>
			<td class="rightAligned">
				<!-- Industry </td>  -->
				Assured Type </td> 
			<td class="leftAligned">
				<select style="width: 218px;" id="industry" name="industry" tabindex="16" class="required">
					<option></option>
					<c:forEach var="industry" items="${industryList}">
						<option value="${industry.industryCd}"
							<c:if test="${assured.industryCd eq industry.industryCd}">
								selected="selected"
							</c:if>
						>${industry.industryName}</option>
					</c:forEach>
				</select></td>
			<td class="rightAligned">
				Parent Assured </td>
			<td class="leftAligned">
				<div style="float: left; border: solid 1px gray; width: 215px; height: 20px; margin-right: 3px;">
					<input type="hidden" id="parentAssdNo" name="parentAssdNo" value="${assured.parentAssuredNo}" />
					<input type="text" tabindex="17" style="float: left; margin-top: 0px; margin-right: 3px; width: 187px; border: none; height: 13px;" name="parentAssdName" id="parentAssdName" value="${assured.parentAssuredName}" class="upper" lastValidValue="${assured.parentAssuredName}"/>
					<img id="hrefParentAssured" alt="goParentAssured" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />
				</div>		
				<%-- <input type="text" style="width: 210px;" id="parentAssured" name="parentAssured" readonly="readonly" tabindex="17"  value="${assured.parentAssuredName}" /> --%>
				<input id="assuredNo" name="assuredNo" type="hidden" value="${assured.assdNo}" />
				<input id="address1" name="address1" type="hidden" value="" />
				<input id="address2" name="address2" type="hidden" value="" />
				<input id="address3" name="address3" type="hidden" value="" /></td>
		</tr>
		<tr>
			<td class="rightAligned">
				Control Type </td> 
			<td class="leftAligned">
				<select style="width: 218px;" id="controlType" name="controlType" tabindex="18" class="required">
					<option></option>
						<c:forEach var="controlType" items="${controlTypeList}">
						<option value="${controlType.controlTypeCd}"
							<c:if test="${assured.controlTypeCd eq controlType.controlTypeCd}">
								selected="selected"
							</c:if>
						>${controlType.controlTypeDesc}</option>
					</c:forEach>
				</select></td>
			<td class="rightAligned">
				Reference Code </td>
			<td class="leftAligned">
				<input type="text" id="referenceCode" name="referenceCode" style="width: 210px;" tabindex="19" maxlength="20" value="${assured.referenceNo}" /></td>
				<input type="hidden" id="hidRefCd" value="${assured.referenceNo}" />
		</tr>
		<tr>
			<td class="rightAligned">
				Contact Person </td>
			<td class="leftAligned">
				<input type="text" id="contactPerson" name="contactPerson" style="width: 210px;" tabindex="20" maxlength="50" value="${assured.contactPersons}" /></td>
		<td class="rightAligned">
				Contact Number </td>
			<td class="leftAligned">
				<input type="text" id="phoneNo" name="phoneNo" style="width: 210px;" tabindex="22" maxlength="40" value="${assured.phoneNo}" class="mandatoryEnchancement"  /></td>
			
			<%-- <td class="rightAligned">
				TIN No. </td>
			<td class="leftAligned">
				<input type="text" id="tinNo" name="tinNo" style="width: 210px;" tabindex="21" maxlength="15" value="${assured.assuredTIN}" /></td> --%>
		</tr>
		<tr>
			<%-- <td class="rightAligned">
				Contact Number </td>
			<td class="leftAligned">
				<input type="text" id="phoneNo" name="phoneNo" style="width: 210px;" tabindex="22" maxlength="50" value="${assured.phoneNo}" /></td> --%>
				<td class="rightAligned">
				TIN </td>
			<td class="leftAligned">
				<input type="text" id="tinNo" name="tinNo" style="width: 210px;" tabindex="21" maxlength="15" value="${assured.assuredTIN}" /></td>
			<td class="rightAligned">
				No TIN Reason </td>
			<td class="leftAligned">
				<input type="text" id="noTINReason" name="noTINReason" style="width: 210px;" tabindex="22" maxlength="50" value="${assured.noTINReason}" class="mandatoryEnchancement"/></td>
			<td></td><td>
		</tr>
			<td class="rightAligned" id="birthDateLabel">Birthdate/Date of Incorporation</td>
			<td class="leftAligned">
				<select style="width: 55px;" id="birthmonth" name="birthmonth" tabindex="23" class="mandatoryEnchancement">
					<option></option>
					<option value="January">Jan</option>
					<option value="February">Feb</option>
					<option value="March">Mar</option>
					<option value="April">April</option>
					<option value="May">May</option>
					<option value="June">Jun</option>
					<option value="July">Jul</option>
					<option value="August">Aug</option>
					<option value="September">Sep</option>
					<option value="October">Oct</option>
					<option value="November">Nov</option>
					<option value="December">Dec</option>	
				</select>
				<select style="width: 50px;" id="birthDate" name="birthDate" tabindex="24" class="mandatoryEnchancement" >
				</select>
				<select style="width: 70px;" id="birthYear" name="birthYear" tabindex="25" class="mandatoryEnchancement" >
				</select>
			</td>
			<td class="rightAligned">Email Address</td>
			<td class="leftAligned">
				<!-- Modified by reymon 02152013 edited maxlength from 50 to 100 -->
				<input type="text" id="emailAddress" name="emailAddress" style="width: 210px;" tabindex="26" maxlength="100" class="mandatoryEnchancement" value="${assured.emailAddress}"/></td>
			<td></td><td>
		<tr>
		
		</tr>
	</table>
</div>

<script>

	// added by irwin - 5.16.2012
	/**
		revised validation of fields: lastName, firstName, middleInitial and etc.
	*/
	var lastFirstName = $F("firstName");
	var lastLastName = $F("lastName");
	var lastMiddleInitial = $F("middleInitial");
	var defaultAssdName2Corp = ""; //added by steven 8/30/2012 
	lastAssdName = ltrim(rtrim($F("assuredNameMaint")));
	
	function showCommonAssured(){
		Modalbox.show(contextPath+"/GIISAssuredController?action=showSameAssuredName&ajaxModal=1",
				{title: 'Assured',
				width: 800});
		Modalbox.resizeToContent();
	}
	
	function showCommonIndiAssured(){
		Modalbox.show(contextPath+"/GIISAssuredController?action=showSameIndiAssuredName&ajaxModal=1",
				{title: 'Assured',
				width: 800});
		Modalbox.resizeToContent();
	}
	
	var assdName = "";
	
	function showExistingAssuredTGListing(){
		try{
			showNotice("Please wait..");
			genericObjOverlay = Overlay.show(contextPath+"/GIISAssuredController", { 
				urlContent: true,
				urlParameters: {action : "getGiiss006bExistingAssdTg",
								assdName: objTempAssured.assdName,
								lastName: objTempAssured.lastName,
								firstName: objTempAssured.firstName,
								middleInitial: objTempAssured.middleInitial,
								assdNo : objTempAssured.assdNo,
								ajax : "1"},
				title: "Assured",							
				height: 500,
			    width: 900,
			    draggable: true 
			});
		}catch(e){
			showErrorMessage("showExistingAssuredTGListing",e);
		}
	}
	
	function checkAssuredExistGiiss006b2(){
		popObjTempAssured();

		new Ajax.Request(contextPath+"/GIISAssuredController?action=checkAssuredExistGiiss006b2",{
			method: "POST",
			parameters: {
				assdName: objTempAssured.assdName,
				lastName: objTempAssured.lastName,
				firstName: objTempAssured.firstName,
				middleInitial: objTempAssured.middleInitial,
				assdNo: $F("assuredNo")
			},
			evalScripts: true,
			asynchronous: false,
			onComplete: function (response) {
				if (checkErrorOnResponse(response)){
					if(response.responseText == "Y"){
						showExistingAssuredTGListing(); 
					}else{
						if($F("assuredNo") != ""){ // conditions added by: Nica 05.29.2012 for exiting records
							checkIfJointAssured();
						}else{ // for newly created records
							if ($("personal").checked == true){ //added by steven 9/12/2012 for Corporate so that the Assured/Principal field will not be cleared.
								generateAssuredName();
							}else if ($("joint").checked == true){
								if($F("lastName").replace(/\s/g,"")  != "" || $F("firstName").replace(/\s/g,"") != "" || $F("middleInitial").replace(/\s/g,"") != "" || $F("suffix") != ""){
									generateAssuredName();
								}
							}
							lastAssdName = ltrim(rtrim($F("assuredNameMaint")));
							checkAssuredExistGiiss006b();
						}
					}
				} 
			}
		});
	}
	
	
	$("assuredNameMaint").observe("focus", function(){
		lastAssdName = ltrim(rtrim($F("assuredNameMaint")));
	});
	
	$("assuredNameMaint").observe("change", function(){
		/* if (checkIfAssuredIsExisting() && $F("assuredNo") == "" && $("selectedAssuredType").innerHTML == "Corporate"){
			//showWaitingMessageBox('Assured is already existing.', imgMessage.INFO, showCommonAssured); removed message - irwin
			showCommonAssured(); 
		} */
		
		if($F("assuredNo") != ""){
			if(nvl($F("assuredNameMaint"), "") != nvl(lastAssdName," ") && nvl(objUW.hidObjGIISS006B.modifySw, "N") == "N"){  //change by steven 8/30/2012 from: "assuredName"	to: "assuredNameMaint"
				showConfirmBox("Confirmation","You are about to modify an assured with"+$F("vLine")+" policy.","Continue", "Cancel",
					function(){
						lastAssdName = $F("assuredNameMaint");	//change by steven 8/30/2012 from: "assuredName"	to: "assuredNameMaint"
						checkAssuredExistGiiss006b2();
						objUW.hidObjGIISS006B.modifySw = "Y";
					},function(){
						$("assuredNameMaint").value = lastAssdName;	//change by steven 8/30/2012 from: "assuredName"	to: "assuredNameMaint"
					}
				);
			}
		}else{
			if ($("joint").checked == true){ //added by steven 9/12/2012
				$("lastName").clear();
				$("firstName").clear();
				$("middleInitial").clear();
				$("suffix").clear();
			}
			checkAssuredExistGiiss006b2();
		}
	});
	
	$("firstName").observe("focus", function(){
		assdName = this.value;
		
		lastFirstName = $F("firstName");
	});
	
	$("firstName").observe("change", function(){
		if ($("personal").checked == true){ //added by steven 9/12/2012 
			generateAssuredName();
		}else if ($("joint").checked == true){
			if($F("lastName").replace(/\s/g,"")  != "" || $F("firstName").replace(/\s/g,"") != "" || $F("middleInitial").replace(/\s/g,"") != "" || $F("suffix") != ""){
				generateAssuredName();
			}
		}
// 		generateAssuredName();
		if($F("assuredNo") != ""){ // for existing records
			if(nvl($F("firstName")," ") != nvl(lastFirstName," ") && nvl(objUW.hidObjGIISS006B.modifySw, "N") == "N"){
				showConfirmBox("Confirmation","You are about to modify an assured with"+$F("vLine")+" policy.","Continue", "Cancel",
					function(){
						lastFirstName = $F("firstName");
						checkAssuredExistGiiss006b2();
						objUW.hidObjGIISS006B.modifySw = "Y";
					},function(){
						$("firstName").value = lastFirstName;
						generateAssuredName(); //marco - 07.09.2014
					}
				);
			}
		}else{
			checkAssuredExistGiiss006b2();
		}
		/* if (checkIfAssuredIsExisting() && $F("assuredNo") == "" &&  $F("lastName") != ""){
			//showWaitingMessageBox('Assured with the same first name and last name already exists.', imgMessage.INFO, showCommonIndiAssured); removed message - irwin
			showCommonIndiAssured();
		} else if($("selectedAssuredType").innerHTML == 'Joint'){
			function resetAssdname (){
				$("firstName").value = assdName;
			};
			showConfirmBox("Confirm", "Entry on Assured will override previous Name entry. Do you want to continue anyway?", 
					"OK", "Cancel", generateAssuredName,  resetAssdname);
		} else {
			 generateAssuredName();
		} */
	});   
	
	$("lastName").observe("focus", function(){
		assdName = this.value;
		
		lastLastName= $F("lastName");
	});
	
	$("lastName").observe("change", function(){
		if ($("personal").checked == true){ //added by steven 9/12/2012 
			generateAssuredName();
		}else if ($("joint").checked == true){
			if($F("lastName").replace(/\s/g,"")  != "" || $F("firstName").replace(/\s/g,"") != "" || $F("middleInitial").replace(/\s/g,"") != "" || $F("suffix") != ""){
				generateAssuredName();
			}
		}
// 		generateAssuredName();
		if($F("assuredNo") != ""){ // for existing records
			if(nvl($F("lastName")," ") != nvl(lastLastName," ") && nvl(objUW.hidObjGIISS006B.modifySw, "N") == "N"){
				showConfirmBox("Confirmation","You are about to modify an assured with"+$F("vLine")+" policy.","Continue", "Cancel",
					function(){
						lastLastName = $F("lastName");
						checkAssuredExistGiiss006b2();
						objUW.hidObjGIISS006B.modifySw = "Y";
					},function(){
						$("lastName").value = lastLastName;
						generateAssuredName(); //marco - 07.09.2014
					}
				);
			}
		}else{ // new recs
			checkAssuredExistGiiss006b2();
		}
	});  
	
	$("middleInitial").observe("focus", function(){
		assdName = this.value;
		lastMiddleInitial = $F("middleInitial");
	});
	
	$("middleInitial").observe("change", function(event){
		if($F("assuredNo") != ""){ // for existing records
			if(nvl($F("middleInitial")," ") != nvl(lastMiddleInitial," ") && nvl(objUW.hidObjGIISS006B.modifySw, "N") == "N"){
				showConfirmBox("Confirmation","You are about to modify an assured with"+$F("vLine")+" policy.","Continue", "Cancel",
					function(){
						lastMiddleInitial = $F("middleInitial");
						checkAssuredExistGiiss006b2();
						objUW.hidObjGIISS006B.modifySw = "Y";
					},function(){
						$("middleInitial").value = lastMiddleInitial;
						lastMiddleInitial = $F("middleInitial");
						generateAssuredName(); //marco - 07.09.2014
					}
				);
			}
		}else{ // new recs
			checkAssuredExistGiiss006b2();
		}
		
		/* if($("selectedAssuredType").innerHTML == 'Joint'){
			function resetAssdname (){
				$("firstName").value = assdName;
			};
			showConfirmBox("Confirm", "Entry on Assured will override previous Name entry. Do you want to continue anyway?", 
					"OK", "Cancel", generateAssuredName,  resetAssdname);
		} else {
			 generateAssuredName();
		} */
	}); 
	
	$("suffix").observe("change", function() {
		if($("selectedAssuredType").innerHTML == 'Joint'){
			function resetAssdname (){
				$("firstName").value = assdName;
			};
			showConfirmBox("Confirmation", "Entry on Assured will override previous Name entry. Do you want to continue anyway?", 
					"OK", "Cancel", generateAssuredName,  resetAssdname);
		} else {
			 generateAssuredName();
		}
	});
 
	if ($F("generatedAssuredNo") != ""){
		$("generatedAssuredNo").value = formatNumberDigits($F("generatedAssuredNo"), 12); // initializes assured number to be in 12 digits
		$("personal").disable(); // added by grace to disable corporate_tag if assured is already saved - 05.05.11 
		$("corporate").disable(); // added by grace to disable corporate_tag if assured is already saved - 05.05.11
		$("joint").disable(); // added by grace to disable corporate_tag if assured is already saved - 05.05.11
	}

/*  	$("parentAssdName").observe("focus", function () {
		openSearchClientModal();
	}); */
	$("hrefParentAssured").observe("click", function() {
		if (parentAssuredDisable == 1) { // by bonok: 01.03.2012
			showGIISParentAssuredLOV("getGIISAssuredLOVTG", function(row) {
				$("parentAssdNo").value = row.assdNo;
				$("parentAssdName").value = unescapeHTML2(row.assdName);
				$("parentAssdName").setAttribute("lastValidValue", $F("parentAssdName")); 	//marco - 07.08.2014
				changeTag = 1;																//
			});
		}
	});

	//marco - 07.08.2014
	$("parentAssdName").observe("change", function(){
		if($F("parentAssdName") == ""){
			$("parentAssdName").setAttribute("lastValidValue", "");
		}else{
			showGIISParentAssuredLOV("getGIISAssuredLOVTG", function(row) {
				$("parentAssdNo").value = row.assdNo;
				$("parentAssdName").value = unescapeHTML2(row.assdName);
				$("parentAssdName").setAttribute("lastValidValue", $F("parentAssdName"));	//marco - 07.08.2014
				changeTag = 1;																//
			});
		}
	});
		
	if($F("assuredNo") != ""){
		$("activeTag").value = $("activeTag").checked ? "Y" : "N"; // added by: Nica 06.20.2012
	}else{
		$("activeTag").checked = true;		
		$("activeTag").value = "Y";
	}
	
	$("activeTag").observe("click", function(){ // added by: Nica 06.20.2012
		$("activeTag").value = $("activeTag").checked ? "Y" : "N";
	});
	
	$("assuredName2Corp").observe("focus", function(){ //added by steven 8/30/2012
		defaultAssdName2Corp = this.value;
	}); 
	$("assuredName2Corp").observe("change", function(){ //added by steven 8/30/2012
		objUW.hidObjGIISS006B.checkChanges("assuredName2Corp",defaultAssdName2Corp);
	});
	
</script>