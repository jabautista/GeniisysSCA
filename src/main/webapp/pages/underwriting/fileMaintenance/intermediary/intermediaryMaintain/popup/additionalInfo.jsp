<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<div id="addtlInfoMainDiv">
	<div id="addtlInfoDiv" class="sectionDiv" style="width: 450px; height: 240px; padding: 10px; margin: 10px;">
		<table>
			<tr>
				<td class="rightAligned" style="padding-right: 7px;">Nickname</td>
				<td class="leftAligned"><input id="nickname" type="text" maxlength="40" style="width: 300px;" tabindex="701">
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 7px;">Email Address</td>
				<td class="leftAligned"><input id="emailAdd" type="text" maxlength="50" style="width: 300px;" tabindex="702">
			</tr>			
			<tr>
				<td class="rightAligned" style="padding-right: 7px;">Fax No</td>
				<td class="leftAligned"><input id="faxNo" type="text" maxlength="40" style="width: 300px;" tabindex="703">
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 7px;">Default Cellphone #</td>
				<td class="leftAligned"><input id="cpNo" name="mobileNo" type="text" maxlength="40" style="width: 300px;" tabindex="704">
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 7px;">Sun Cellphone #</td>
				<td class="leftAligned"><input id="sunNo" name="mobileNo" type="text" maxlength="40" style="width: 300px;" tabindex="705">
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 7px;">Globe Cellphone #</td>
				<td class="leftAligned"><input id="globeNo" name="mobileNo" type="text" maxlength="40" style="width: 300px;" tabindex="706">
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 7px;">Smart Cellphone #</td>
				<td class="leftAligned"><input id="smartNo" name="mobileNo" type="text" maxlength="40" style="width: 300px;" tabindex="707">
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 7px;">Address</td>
				<td class="leftAligned"><input id="homeAdd" type="text" maxlength="150" style="width: 300px;" tabindex="708">
			</tr>
		</table>
	</div>
	<div align="center">
		<input type="button" class="button" id="btnReturn" value="Return"  style="width: 80px;" tabindex="705">
		<!-- <input type="button" class="button" id="btnSaveInfo" value="Save" tabindex="706"> -->
	</div>
</div>

<script type="text/javascript">
try{
	var defCheck = null;
	var prevVal = null;
	
	if (objUW.GIISS076.giisIntm[0] != undefined){
		$("nickname").value = unescapeHTML2(objUW.GIISS076.giisIntm[0].nickname);
		$("emailAdd").value = unescapeHTML2(objUW.GIISS076.giisIntm[0].emailAdd);
		$("faxNo").value = unescapeHTML2(objUW.GIISS076.giisIntm[0].faxNo);
		$("cpNo").value = unescapeHTML2(objUW.GIISS076.giisIntm[0].cpNo);
		$("sunNo").value = unescapeHTML2(objUW.GIISS076.giisIntm[0].sunNo);
		$("globeNo").value = unescapeHTML2(objUW.GIISS076.giisIntm[0].globeNo);
		$("smartNo").value = unescapeHTML2(objUW.GIISS076.giisIntm[0].smartNo);
		$("homeAdd").value = unescapeHTML2(objUW.GIISS076.giisIntm[0].homeAdd);
		
		$("cpNo").setAttribute("lastValidValue", $F("cpNo"));
		$("globeNo").setAttribute("lastValidValue", $F("globeNo"));
		$("smartNo").setAttribute("lastValidValue", $F("smartNo"));
		$("sunNo").setAttribute("lastValidValue", $F("sunNo"));
	}
	
	function validateMobilePrefix(value){
		var len = value.length;
		var sub = value.substr(0, (len - 7));
		
		var length = null;
		
		if(sub.indexOf('09') != -1){
			length = 11;
		}else if(sub.indexOf('+639') != -1){
			length = 13;
		}else if(sub.indexOf('639') != -1){
			length = 12;
		}
		
		return length;
	}
	
	function validateMobileNo(param, fieldId, cType, vDefault){
		var len = validateMobilePrefix($(fieldId).value);
		var sub = $(fieldId).value.substr(0, (len - 7));
		var prefix = $(fieldId).value.substr(nvl(sub.indexOf('9'), 0), 3);
		var flag = false;
		var val = null;
		var a = null;
		var valid = true;
		
		if ($(fieldId).value.indexOf('+') == 0){
			a = 1;
		}else{
			a = 0;
		}
		
		for (a; a < $(fieldId).value.length; a++){
			val = $(fieldId).value.substr(a, 1);
			if (!validateIntegerNoNegativeUnformattedNoComma(val)){
				valid = false;
				showWaitingMessageBox("Invalid mobile number.", "I", function(){
					$(fieldId).value = $(fieldId).readAttribute("lastValidValue");
					$(fieldId).focus();
					return false;
				});
				
			}
		}		
		
		if($(fieldId).value.length != len){
			valid = false;
			showWaitingMessageBox("Invalid mobile number.", "I", function(){
				$(fieldId).value = $(fieldId).readAttribute("lastValidValue");
				$(fieldId).focus();
				return false;
			});
		}

		if (!valid){
			defCheck = null;
			return false;	
		}
		
		new Ajax.Request(contextPath+"/GIISIntermediaryController", {
			parameters: {
				action: "checkMobilePrefixGiiss076",
				param:	param,
				prefix:	prefix
			},
			asynchronous: false,
			onCreate: showNotice("Validating Mobile Number, please wait..."),
			onComplete: function(response){
				hideNotice();
				
				if(checkErrorOnResponse(response)){
					flag = response.responseText;
					
					if (flag == "TRUE"){
						defCheck = 1;
					}else{
						if (cType != 'all') {
							defCheck = 2;
							return false;
						}else if (cType == 'all'){
							defCheck = 0;
						}
					}
									
					if (fieldId != "cpNo"){
						$(fieldId).setAttribute("lastValidValue", $F(fieldId));
					}
					
					if ($F("cpNo") == "" || (objUW.GIISS076.vDefault == vDefault && $(fieldId).value != "")){ 
						$("cpNo").value = $(fieldId).value;
						objUW.GIISS076.vDefault = vDefault;
					}else if($F("cpNo") != "" && $(fieldId).value != "" && vDefault != undefined){	
						showConfirmBox("CONFIRMATION", "Do you want to change your default cellphone number?", "Yes", "No", 
								function(){
									$("cpNo").value = $(fieldId).value;
									objUW.GIISS076.vDefault = vDefault;
								},
								""
						);
					}
				}
			}
		});	
	}		
	
	$$("input[type='text']").each(function(txt){
		txt.observe("change", function(){
			changeTag = 1;			
		});
		
		txt.observe("focus", function(){
			if (txt.name == "mobileNo"){
				prevVal = txt.value;
			}
		});
	});
	
	$("sunNo").observe("change", function(){
		if (this.value != "" && prevVal != this.value){
			if(!validateMobileNo('SUN_NUMBER', this.id, 'Sun', 1)){
				if(defCheck == 2){
					showWaitingMessageBox("Invalid Sun mobile number.", "E", function(){
						$("sunNo").value = $("sunNo").readAttribute("lastValidValue");
						$("sunNo").focus();
					});
					return false;
				}
			}
		}else if(this.value == "" && objUW.GIISS076.vDefault == 1){
			showWaitingMessageBox("You cannot delete the default cellphone number.", "I", function(){
				$("sunNo").value = $F("cpNo");
				$("sunNo").focus();
				return false;
			});
		}				
	});
	
	$("globeNo").observe("change", function(){
		if (this.value != "" && prevVal != this.value){
			if(!validateMobileNo('GLOBE_NUMBER', this.id, 'Globe', 2)){
				if(defCheck == 2){
					showWaitingMessageBox("Invalid Globe mobile number.", "E", function(){
						$("globeNo").value = $("globeNo").readAttribute("lastValidValue");
						$("globeNo").focus();
					});
					return false;
				}
			}
		}else if(this.value == "" && objUW.GIISS076.vDefault == 2){
			showWaitingMessageBox("You cannot delete the default cellphone number.", "I", function(){
				$("globeNo").value = $F("cpNo");
				$("globeNo").focus();
				return false;
			});
		}
	});
	
	$("smartNo").observe("change", function(){
		if (this.value != "" && prevVal != this.value){
			if(!validateMobileNo('SMART_NUMBER', this.id, 'Smart', 3)){
				if(defCheck == 2){
					showWaitingMessageBox("Invalid Smart mobile number.", "E", function(){
						$("smartNo").value = $("smartNo").readAttribute("lastValidValue");
						$("smartNo").focus();
					});
					return false;
				}
			}
		}else if(this.value == "" && objUW.GIISS076.vDefault == 3){
			showWaitingMessageBox("You cannot delete the default cellphone number.", "I", function(){
				$("smartNo").value = $F("cpNo");
				$("smartNo").focus();
				return false;
			});
		}
	});
	
	$("cpNo").observe("change", function(){
		if (this.value == "" && objUW.GIISS076.vDefaultNo != ""){
			this.value = this.readAttribute("lastValidValue"); //objUW.GIISS076.vDefaultNo;
			showMessageBox("You cannot delete the default mobile number.", "E");
			return false;
		}else if (this.value != "" && prevVal != this.value){
			//for sun number
			if(!validateMobileNo('SUN_NUMBER', this.id, 'all')){	
				if(defCheck == 0){
					//for globe number
					if(!validateMobileNo('GLOBE_NUMBER', this.id, 'all')){		
						if(defCheck == 0){
							//for smart number
							if(!validateMobileNo('SMART_NUMBER', this.id, 'all')){		
								if(defCheck == 0){
									showWaitingMessageBox("Not a valid smart, sun, or globe cell number.", "E", function(){
										$("cpNo").value = $("cpNo").readAttribute("lastValidValue");
										$("cpNo").focus();
										return false;
									});
								}else if(defCheck == 1){
									if($F("smartNo") == ""){
										$("smartNo").value = $("cpNo").value;
										$("cpNo").setAttribute("lastValidValue", $F("cpNo"));
										objUW.GIISS076.vDefault = 3;
										objUW.GIISS076.vDefaultNo = $F("smartNo");
									}else if(this.value != $F("smartNo")){
										showConfirmBox("CONFIRMATION", "Do you want to change your smart mobile no?", "Yes", "No", 
												function(){
													$("smartNo").value = $("cpNo").value;
													$("smartNo").setAttribute("lastValidValue", $F("smartNo"));
													$("cpNo").setAttribute("lastValidValue", $F("cpNo"));
													objUW.GIISS076.vDefault = 3;
													objUW.GIISS076.vDefaultNo = $F("smartNo");
												},
												function(){
													showWaitingMessageBox('You cannot set a default number that is not found on your available mobile nos.','E', function(){
														$("cpNo").value = $("cpNo").readAttribute("lastValidValue");
														$("cpNo").focus();
														return false;
													});
												}
										);
									}else if(this.value == $F("smartNo")){
										objUW.GIISS076.vDefault = 3;
										objUW.GIISS076.vDefaultNo = $F("smartNo");
									}
								}
							}
							//end smart number
						//checks if the number entered is a globe number
						}else if(defCheck == 1){
							if($F("globeNo") == ""){ 
								$("globeNo").value = $("cpNo").value;
								$("cpNo").setAttribute("lastValidValue", $F("cpNo"));
								objUW.GIISS076.vDefault = 2;
								objUW.GIISS076.vDefaultNo = $F("globeNo");
							}else if(this.value != $F("globeNo")){
								showConfirmBox("CONFIRMATION", "Do you want to change your globe mobile no?", "Yes", "No", 
										function(){
											$("globeNo").value = $("cpNo").value;
											$("globeNo").setAttribute("lastValidValue", $F("globeNo"));
											$("cpNo").setAttribute("lastValidValue", $F("cpNo"));
											objUW.GIISS076.vDefault = 2;
											objUW.GIISS076.vDefaultNo = $F("globeNo");
										},
										function(){
											showWaitingMessageBox('You cannot set a default number that is not found on your available mobile nos.','E', function(){
												$("cpNo").value = $("cpNo").readAttribute("lastValidValue");
												$("cpNo").focus();
												return false;
											});
										}
								);
							}else if(this.value == $F("globeNo")){
								objUW.GIISS076.vDefault = 2;
								objUW.GIISS076.vDefaultNo = $F("globeNo");
							}
						}
					}
					//end globe number
				// checks if the entered number is a sun number
				}else if(defCheck == 1){
					if($F("sunNo") == ""){
						$("sunNo").value = $("cpNo").value;
						$("cpNo").setAttribute("lastValidValue", $F("cpNo"));
						objUW.GIISS076.vDefault = 1;
						objUW.GIISS076.vDefaultNo = $F("sunNo");
					}else if(this.value != $F("sunNo")){
						showConfirmBox("CONFIRMATION", "Do you want to change your sun mobile no?", "Yes", "No", 
								function(){
									$("sunNo").value = $("cpNo").value;
									$("sunNo").setAttribute("lastValidValue", $F("sunNo"));
									$("cpNo").setAttribute("lastValidValue", $F("cpNo"));
									objUW.GIISS076.vDefault = 1;
									objUW.GIISS076.vDefaultNo = $F("sunNo");
								},
								function(){
									showWaitingMessageBox('You cannot set a default number that is not found on your available mobile nos.','E', function(){
										$("cpNo").value = $("cpNo").readAttribute("lastValidValue");
										$("cpNo").focus();
										return false;
									});
								}
						);
					}else if(this.value == $F("sunNo")){
						objUW.GIISS076.vDefault = 1;
						objUW.GIISS076.vDefaultNo = $F("sunNo");
					}
				}
				//end sun number
			}
		}
	});	
	
	
	$("btnReturn").observe("click", function(){
		objUW.GIISS076.giisIntm = [];
		objUW.GIISS076.giisIntm.push({nickname: escapeHTML2($F("nickname")),
									 emailAdd: 	escapeHTML2($F("emailAdd")),
									 faxNo: 	escapeHTML2($F("faxNo")),
									 cpNo: 		$F("cpNo"),
									 sunNo: 	$F("sunNo"),
									 globeNo: 	$F("globeNo"),
									 smartNo: 	$F("smartNo"),
									 homeAdd: 	escapeHTML2($F("homeAdd"))});
		
		$("hidHomeAdd").value = escapeHTML2($F("homeAdd")); 
		$("hidNickname").value = escapeHTML2($F("nickname"));
		$("hidEmailAdd").value = escapeHTML2($F("emailAdd"));
		$("hidFaxNo").value = escapeHTML2($F("faxNo"));
		$("hidCpNo").value = $F("cpNo");
		$("hidSunNo").value = $F("sunNo");
		$("hidGlobeNo").value = $F("globeNo");
		$("hidSmartNo").value = $F("smartNo");
		aiOverlay.close();
	});
}catch(e){
	showErrorMessage("Page Error", e);
}
</script>