<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<jsp:include page="/pages/underwriting/subPages/beneficiaryInformationListing.jsp"></jsp:include>
	<table align="center" width="580px;" border="0">
		<tr>
			<td class="rightAligned" style="width:100px;">Name </td>
			<td class="leftAligned" colspan="3">
				<input id="beneficiaryNo" name="beneficiaryNo" type="hidden" style="width: 180px;" maxlength="5" readonly="readonly"/>
				<input id="beneficiaryName" name="beneficiaryName" type="text" style="width: 462px" maxlength="30" class="required"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width:100px;">Address </td>
			<td class="leftAligned" colspan="3">
				<input id="beneficiaryAddr" name="beneficiaryAddr" type="text" style="width: 462px" maxlength="50"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Birthday </td>
			<td class="leftAligned" >
				<div style="float:left; border: solid 1px gray; width: 186px; height: 21px; margin-right:3px;">
			    	<input style="width: 159px; border: none;" id="beneficiaryDateOfBirth" name="beneficiaryDateOfBirth" type="text" value="" readonly="readonly"/>
			    	<img id="hrefBeneficiaryDateOfBirth" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('beneficiaryDateOfBirth'),this, null);" alt="Birthday" />
				</div>
			</td>	
			<td style="width:79px;" class="rightAligned">Age</td>
			<td class="leftAligned" >	
				<input id="beneficiaryAge" name="beneficiaryAge" type="text" style="width: 180px; text-align:right;" maxlength="3" class="integerNoNegativeUnformattedNoComma" readonly="readonly" errorMsg="Entered Age is invalid. Valid value is from 0 to 999" />
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width:100px;">Relation </td>
			<td class="leftAligned" colspan="3">
				<input id="beneficiaryRelation" name="beneficiaryRelation" type="text" style="width: 180px;" maxlength="15"/>
			</td>
		</tr>
		<tr>
<!--			<td class="rightAligned">Remarks </td>
			<td class="leftAligned" colspan="3">
				<textarea onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);" rows="2" cols="1" style="width: 462px;" id="benefeciaryRemarks" name="benefeciaryRemarks"></textarea>
			</td> -->
			<td class="rightAligned">Remarks</td>
			<td class="leftAligned" colspan="3">
				<div style="border: 1px solid gray; height: 20px; width: 100%; ">
					<textarea id="beneficiaryRemarks" name="beneficiaryRemarks" style="width: 91% ; border: none; height: 13px;"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="EditRemark" id="editBenRemarks" />
				</div>
			</td>
		</tr>	
		<tr>
			<td>
				<input id="nextItemNoBen" name="nextItemNoBen" type="hidden" style="width: 220px;" value="" readonly="readonly"/>
			</td>
		</tr>
	</table>
	<table align="center">
		<tr>
			<td class="rightAligned" style="text-align: left; padding-left: 5px;">
				<input type="button" class="button" 		id="btnAddBeneficiary" 	name="btnAddBeneficiary" 		value="Add" 		style="width: 60px;" />
				<input type="button" class="disabledButton" id="btnDeleteBeneficiary" 	name="btnDeleteBeneficiary" 	value="Delete" 		style="width: 60px;" />
			</td>
		</tr>
	</table>

<script type="text/javascript">
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();

	$("beneficiaryAge").observe("blur", function () {
		if (parseInt($F("beneficiaryAge")) > 999 || parseInt($F("beneficiaryAge")) < 0){
			showMessageBox("Entered Age is invalid. Valid value is from 0 to 999", imgMessage.ERROR);
			$("beneficiaryAge").value ="";
			return false;
		} else{
			isNumber("beneficiaryAge","Entered Age is invalid. Valid value is from 0 to 999","");
		}
	});

	$("beneficiaryDateOfBirth").observe("blur", function () {
		if (!$F("beneficiaryDateOfBirth").blank()){
			$("beneficiaryAge").value = computeAge($("beneficiaryDateOfBirth").value);
			checkBday();
		}
	});

	$("beneficiaryAge").observe("blur", function () {
		if ($("beneficiaryDateOfBirth").value != ""){
			if ($("beneficiaryAge").value != ""){
				$("beneficiaryAge").value = computeAge($("beneficiaryDateOfBirth").value);
			}
		}
	});
			
	function checkBday(){
		var today = new Date();
		var bday = makeDate($F("beneficiaryDateOfBirth"));
		if (bday>today){
			$("beneficiaryDateOfBirth").value = "";
			$("beneficiaryAge").value = "";
			hideNotice("");
		}	
	}
	
	$("btnAddBeneficiary").observe("click", function() {
		if(checkIfItemExists($F("itemNo"))){
			addBeneficiary();
		} else{
			return false;
		}		
	});

	$$("div[name='ben']").each(
			function (acc)	{
				acc.observe("mouseover", function ()	{
					acc.addClassName("lightblue");
				});
				
				acc.observe("mouseout", function ()	{
					acc.removeClassName("lightblue");
				});

				acc.observe("click", function ()	{
					acc.toggleClassName("selectedRow");
					if (acc.hasClassName("selectedRow"))	{
						$$("div[name='ben']").each(function (li)	{
							if (acc.getAttribute("id") != li.getAttribute("id"))	{
								li.removeClassName("selectedRow");
							}	
						});
						var beneficiaryNo = acc.down("input",2).value;	
						var beneficiaryName = acc.down("input",3).value;	
						var beneficiaryAddr = acc.down("input",4).value;	
						var beneficiaryDateOfBirth = acc.down("input",5).value;		
						var beneficiaryAge = acc.down("input",6).value;	
						var beneficiaryRelation = acc.down("input",7).value;	
						var benefeciaryRemarks = acc.down("input",8).value;	
						$("beneficiaryNo").value = beneficiaryNo;
						$("beneficiaryName").value = beneficiaryName;
						$("beneficiaryAddr").value = beneficiaryAddr;
						$("beneficiaryDateOfBirth").value = beneficiaryDateOfBirth;
						$("beneficiaryAge").value = beneficiaryAge;
						$("beneficiaryRelation").value = beneficiaryRelation;
						$("benefeciaryRemarks").value = benefeciaryRemarks;
						getDefaults();
					} else {
						clearForm();
					}
				}); 
				
			}	
	);
	
	function addBeneficiary() {	
		try	{
			var bParId = $F("globalParId");
			var bItemNo = $F("itemNo");
			var bBeneficiaryNo = $("beneficiaryNo").value;
			var bBeneficiaryName = changeSingleAndDoubleQuotes2($("beneficiaryName").value);
			var bBeneficiaryAddr = changeSingleAndDoubleQuotes2($("beneficiaryAddr").value);
			var bBeneficiaryDateOfBirth = $("beneficiaryDateOfBirth").value;
			var bBeneficiaryAge = $("beneficiaryAge").value;
			var bBeneficiaryRelation = changeSingleAndDoubleQuotes2($("beneficiaryRelation").value);
			var bBenefeciaryRemarks = changeSingleAndDoubleQuotes2($("beneficiaryRemarks").value);
			var exists = false;
			
			if (bBeneficiaryNo == "" || bBeneficiaryName == "") {
				showMessageBox("Beneficiary name must be entered.", imgMessage.ERROR);
				exists = true;
			}
			
			$$("div[name='ben']").each( function(a)	{
				if (a.getAttribute("beneficiaryNo") == bBeneficiaryNo && a.getAttribute("item") == bItemNo && $F("btnAddBeneficiary") != "Update")	{
					exists = true;
					showMessageBox("Record already exists!", imgMessage.ERROR);
				}	
			});

			hideNotice("");

			if (!exists)	{
				var content = '<input type="hidden" id="bParIds" 		     		name="bParIds" 	        		 value="'+bParId+'" />'+
			 	  			  '<input type="hidden" id="bItemNos" 		     		name="bItemNos" 	        	 value="'+bItemNo+'" />'+ 
							  '<input type="hidden" id="bBeneficiaryNos"       		name="bBeneficiaryNos"     	 	 value="'+bBeneficiaryNo+'" />'+ 
						 	  '<input type="hidden" id="bBeneficiaryNames"  	 	name="bBeneficiaryNames"  		 value="'+bBeneficiaryName+'" />'+  
						 	  '<input type="hidden" id="bBeneficiaryAddrs" 	 		name="bBeneficiaryAddrs" 		 value="'+bBeneficiaryAddr+'" />'+ 
						 	  '<input type="hidden" id="bBeneficiaryDateOfBirths" 	name="bBeneficiaryDateOfBirths"  value="'+bBeneficiaryDateOfBirth+'" />'+ 
						 	  '<input type="hidden" id="bBeneficiaryAges" 			name="bBeneficiaryAges" 		 value="'+bBeneficiaryAge+'" />'+ 
						 	  '<input type="hidden" id="bBeneficiaryRelations"   	name="bBeneficiaryRelations"  	 value="'+bBeneficiaryRelation+'" />'+
						 	  '<input type="hidden" id="bBenefeciaryRemarkss"  	 	name="bBenefeciaryRemarkss" 	 value="'+bBenefeciaryRemarks+'" />'+
						 	  '<label name="textBenefeciary" style="width: 20%; margin-right: 10px;" for="ben'+bBeneficiaryName+'">'+bBeneficiaryName.truncate(20, "...")+'</label>'+
						 	  '<label name="textBenefeciary" style="width: 15%; margin-right: 10px;" for="ben'+bBeneficiaryAddr+'">'+(bBeneficiaryAddr == "" ? "---" :bBeneficiaryAddr.truncate(20, "..."))+'</label>'+
						 	  '<label name="textBenefeciary" style="width: 10%; margin-right: 10px;" for="ben'+bBeneficiaryDateOfBirth+'">'+(bBeneficiaryDateOfBirth == "" ? "---" :bBeneficiaryDateOfBirth.truncate(20, "..."))+'</label>'+
						 	  '<label name="textBenefeciary" style="width: 10%; margin-right: 10px;" for="ben'+bBeneficiaryAge+'">'+(bBeneficiaryAge == "" ? "---" :bBeneficiaryAge.truncate(20, "..."))+'</label>'+
						 	  '<label name="textBenefeciary" style="width: 15%; margin-right: 10px;" for="ben'+bBeneficiaryRelation+'">'+(bBeneficiaryRelation == "" ? "---" :bBeneficiaryRelation.truncate(20, "..."))+'</label>'+
							  '<label name="textBenefeciary" style="width: 20%;" for="per'+bBenefeciaryRemarks+'">'+(bBenefeciaryRemarks == "" ? "---" :bBenefeciaryRemarks.truncate(20, "..."))+'</label>'; 
							  			   
				if ($F("btnAddBeneficiary") == "Update") {	 				 
					$("rowBen"+bItemNo+bBeneficiaryNo).update(content);					
					updateTempBeneficiaryItemNos();
				} else {
					var newDiv = new Element('div');
					newDiv.setAttribute("name","ben");
					newDiv.setAttribute("id","rowBen"+bItemNo+bBeneficiaryNo);
					newDiv.setAttribute("item",bItemNo);
					newDiv.setAttribute("beneficiaryNo",bBeneficiaryNo); 
					newDiv.addClassName("tableRow");
  
					newDiv.update(content);
					$('beneficiaryListing').insert({bottom: newDiv});
							 
					newDiv.observe("mouseover", function ()	{
						newDiv.addClassName("lightblue");
					});
					
					newDiv.observe("mouseout", function ()	{
						newDiv.removeClassName("lightblue");
					});
					
					newDiv.observe("click", function ()	{	
						newDiv.toggleClassName("selectedRow");
						if (newDiv.hasClassName("selectedRow"))	{
							$$("div[name='ben']").each(function (li)	{
									if (newDiv.getAttribute("id") != li.getAttribute("id"))	{
									li.removeClassName("selectedRow");
								}
							});
							var beneficiaryNo = newDiv.down("input",2).value;	
							var beneficiaryName = newDiv.down("input",3).value;	
							var beneficiaryAddr = newDiv.down("input",4).value;	
							var beneficiaryDateOfBirth = newDiv.down("input",5).value;		
							var beneficiaryAge = newDiv.down("input",6).value;	
							var beneficiaryRelation = newDiv.down("input",7).value;	
							var benefeciaryRemarks = newDiv.down("input",8).value;	
							$("beneficiaryNo").value = beneficiaryNo;
							$("beneficiaryName").value = beneficiaryName;
							$("beneficiaryAddr").value = beneficiaryAddr;
							$("beneficiaryDateOfBirth").value = beneficiaryDateOfBirth;
							$("beneficiaryAge").value = beneficiaryAge;
							$("beneficiaryRelation").value = beneficiaryRelation;
							$("benefeciaryRemarks").value = benefeciaryRemarks;
							getDefaults();
						} else {
							clearForm();
						} 
					}); 
		
					Effect.Appear(newDiv, {
						duration: .5, 
						afterFinish: function ()	{
						checkTableItemInfoAdditional("benefeciaryTable","beneficiaryListing","ben","item",$F("itemNo"));
						}
					});
					updateTempBeneficiaryItemNos();
				}
				clearForm();
			}
		} catch (e)	{
			showErrorMessage("addBeneficiary", e);
		}
	}

	$("btnDeleteBeneficiary").observe("click", function() {
		if(checkIfItemExists($F("itemNo"))){
			deleteBeneficiaryItems();
		} else{
			return false;
		}			
	});

	function deleteBeneficiaryItems(){
		$$("div[name='ben']").each(function (acc)	{
			if (acc.hasClassName("selectedRow")){
				Effect.Fade(acc, {
					duration: .5,
					afterFinish: function ()	{
						var itemNo		    = $F("itemNo");
						var beneficiaryNo	= $F("beneficiaryNo");
						var listingDiv 	    = $("beneficiaryListing");
						var newDiv 		    = new Element("div");
						newDiv.setAttribute("id", "row"+itemNo+beneficiaryNo); 
						newDiv.setAttribute("name", "rowDelete"); 
						newDiv.addClassName("tableRow");
						newDiv.setStyle("display : none");
						newDiv.update(										
							'<input type="hidden" name="delBeneficiaryItemNos" 	value="'+itemNo+'" />' +
							'<input type="hidden" name="delBeneficiaryNos" 	value="'+beneficiaryNo+'" />');
						listingDiv.insert({bottom : newDiv});
						updateTempBeneficiaryItemNos();
						acc.remove();
						clearForm();
						checkTableItemInfoAdditional("benefeciaryTable","beneficiaryListing","ben","item",$F("itemNo"));
					} 
				});
			}
		});
	}	
	
	function getDefaults()	{
		$("btnAddBeneficiary").value = "Update";
		enableButton("btnDeleteBeneficiary");
	}

	function clearForm()	{
		generateSequenceItemInfo("ben","beneficiaryNo","item",$F("itemNo"),"nextItemNoBen");
		$("beneficiaryName").value = "";
		$("beneficiaryAddr").value = "";
		$("beneficiaryDateOfBirth").value = "";
		$("beneficiaryAge").value = "";
		$("beneficiaryRelation").value = "";
		$("benefeciaryRemarks").value = "";

		$("btnAddBeneficiary").value = "Add";
		disableButton("btnDeleteBeneficiary");
		$$("div[name='ben']").each(function (div) {
			div.removeClassName("selectedRow");
		});
		checkTableItemInfoAdditional("benefeciaryTable","beneficiaryListing","ben","item",$F("itemNo"));
	}

	function updateTempBeneficiaryItemNos(){
		var temp = $F("tempBeneficiaryItemNos").blank() ? "" : $F("tempBeneficiaryItemNos");
		$("tempBeneficiaryItemNos").value = temp + $F("itemNo") + " ";
	}

	$("editBenRemarks").observe("click", function () {
		showEditor("beneficiaryRemarks", 4000);
	});

	$("beneficiaryRemarks").observe("keyup", function () {
		limitText(this, 4000);
	});

	generateSequenceItemInfo("ben","beneficiaryNo","item",$F("itemNo"),"nextItemNoBen");
	checkTableItemInfoAdditional("benefeciaryTable","beneficiaryListing","ben","item",$F("itemNo"));
</script>	