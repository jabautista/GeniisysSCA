<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="beneficiaryInformationInfo" class="sectionDiv" style="display: none; width:872px; background-color:white; ">
	<jsp:include page="/pages/underwriting/subPages/accidentBeneficiaryListing.jsp"></jsp:include>
	<table align="center" width="580px;" border="0">
		<tr>
			<td class="rightAligned" style="width:100px;">Name </td>
			<td class="leftAligned" colspan="3">
				<input id="bBeneficiaryNo" name="bBeneficiaryNo" type="hidden" style="width: 180px;" maxlength="5" readonly="readonly"/>
				<input id="bBeneficiaryName" name="bBeneficiaryName" type="text" style="width: 462px" maxlength="30" class="required"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width:100px;">Address </td>
			<td class="leftAligned" colspan="3">
				<input id="bBeneficiaryAddr" name="bBeneficiaryAddr" type="text" style="width: 462px" maxlength="50"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Birthday </td>
			<td class="leftAligned" >
				<div style="float:left; border: solid 1px gray; width: 186px; height: 21px; margin-right:3px;">
			    	<input style="width: 159px; border: none;" id="bDateOfBirth" name="bDateOfBirth" type="text" value="" readonly="readonly"/>
			    	<img name="accModalDate" id="hrefBeneficiaryDateOfBirth" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('bDateOfBirth'),this, null);" alt="Birthday" />
				</div>
			</td>	
			<td class="rightAligned" >Age
				<input id="bAge" name="bAge" type="text" style="width: 90px; text-align:right;" maxlength="3" class="integerNoNegativeUnformattedNoComma" errorMsg="Entered Age is invalid. Valid value is from 0 to 999" readonly="readonly"/>
			</td>
			<td class="rightAligned" >Sex	
				<select id="bSex" name="bSex" style="width:106px;">
					<option value=""></option>
					<option value="F">Female</option>
					<option value="M">Male</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width:100px;">Relation </td>
			<td class="leftAligned">
				<input id="bRelation" name="bRelation" type="text" style="width: 180px;" maxlength="15"/>
			</td>
			<td class="rightAligned" >Civil Status </td>
			<td class="leftAligned">
				<select  id="bCivilStatus" name="bCivilStatus" style="width: 142px">
					<option value=""></option>
					<c:forEach var="civilStats" items="${civilStats}">
						<option value="${civilStats.rvLowValue}">${civilStats.rvMeaning}</option>
					</c:forEach>
				</select>
			</td>
		</tr>	
		<tr>
			<td>
				<input id="bGroupedItemNo" 	name="cGroupedItemNo" 	type="hidden" style="width: 215px;" value="" />
				<input id="nextItemNoBen2"  name="nextItemNoBen2"   type="hidden" style="width: 220px;" value="" readonly="readonly"/>
			</td>
		</tr>
	</table>
	<table align="center" style="margin-bottom:10px;">
		<tr>
			<td class="rightAligned" style="text-align: left; padding-left: 5px;">
				<input type="button" class="button" 		id="btnAddBeneficiary" 	name="btnAddBeneficiary" 		value="Add" 		style="width: 60px;" />
				<input type="button" class="disabledButton" id="btnDeleteBeneficiary" 	name="btnDeleteBeneficiary" 	value="Delete" 		style="width: 60px;" />
			</td>
		</tr>
	</table>
	<jsp:include page="/pages/underwriting/subPages/accidentBeneficiaryPerilListing.jsp"></jsp:include>
	<table align="center" border="0">
		<tr> 
			<td class="rightAligned" >Peril Name </td>
			<td class="leftAligned" >
				<select  id="bpPerilCd" name="bpPerilCd" style="width: 223px" class="required">
					<option value=""></option>
					<c:forEach var="bPerils" items="${beneficiaryPerils}">
						<option value="${bPerils.perilCd}">${bPerils.perilName}</option>
					</c:forEach>
				</select>
			</td>
			<td class="rightAligned" style="width:105px;">TSI Amt. </td>
			<td class="leftAligned" >
				<input id="bpTsiAmt" name="bpTsiAmt" type="text" style="width: 215px;" value="" maxlength="18" class="money"/>
			</td>
		</tr>
		<tr>
			<td>
				<input id="bpGroupedItemNo" 	name="cGroupedItemNo" 	type="hidden" style="width: 215px;" value="" />
				<input id="bpBeneficiaryNo" 	name="bpBeneficiaryNo" 	type="hidden" style="width: 215px;" value="" />
				<input id="bpLineCd" 			name="bpLineCd" 		type="hidden" style="width: 215px;" value="" />
				<input id="bpRecFlag" 			name="bpRecFlag" 		type="hidden" style="width: 215px;" value="" />
				<input id="bpPremRt" 			name="bpPremRt" 		type="hidden" style="width: 215px;" value="" />
				<input id="bpPremAmt" 			name="bpPremAmt" 		type="hidden" style="width: 215px;" value="" />
				<input id="bpAnnTsiAmt" 		name="bpAnnTsiAmt" 		type="hidden" style="width: 215px;" value="" />
				<input id="bpAnnPremAmt" 		name="bpAnnPremAmt" 	type="hidden" style="width: 215px;" value="" />
				<input id="perilsItemSeqNo"		name="perilsItemSeqNo"  type="hidden"   style="width: 215px;" value="" />
				<input id="perilsItemSeqNo2"	name="perilsItemSeqNo2" type="hidden"   style="width: 215px;" value="" />
			</td>
		</tr>
	</table>
	<table align="center" border="0" style="margin-bottom:10px;">	
		<tr>
			<td class="rightAligned" style="text-align: left; padding-left: 5px;">
				<input type="button" class="button" 		id="btnAddBeneficiaryPerils" 	name="btnAddBeneficiaryPerils" 		value="Add" 		style="width: 85px;" />
				<input type="button" class="disabledButton" id="btnDeleteBeneficiaryPerils" 	name="btnDeleteBeneficiaryPerils" 	value="Delete" 		style="width: 85px;" />
			</td>
		</tr>
	</table>
</div>
<script type="text/javascript">
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	
	$("bAge").observe("blur", function () {
		if (parseInt($F("bAge")) > 999 || parseInt($F("bAge")) < 0){
			showMessageBox("Entered Age is invalid. Valid value is from 0 to 999", imgMessage.ERROR);
			$("bAge").value ="";
			return false;
		} else{
			isNumber("bAge","Entered Age is invalid. Valid value is from 0 to 999","");
		}

		
	});
	
	$("bDateOfBirth").observe("blur", function () {
		$("bAge").value = computeAge($("bDateOfBirth").value);
		checkBday();
	});

	$("bAge").observe("blur", function () {
		if ($("bDateOfBirth").value != ""){
			if ($("bAge").value != ""){
				$("bAge").value = computeAge($("bDateOfBirth").value);
			}
		}
	});
			
	function checkBday(){
		var today = new Date();
		var bday = makeDate($F("bDateOfBirth"));
		if (bday>today){
			$("bDateOfBirth").value = "";
			$("bAge").value = "";
			hideNotice("");
		}	
	}

//start for perils
	$("bpTsiAmt").observe("blur", function() {
		if (parseFloat($F('bpTsiAmt').replace(/,/g, "")) < -99999999999999.99) {
			showMessageBox("Entered TSI Amount is invalid. Valid value is from -99,999,999,999,999.99 - 99,999,999,999,999.99.", imgMessage.ERROR);
			$("bpTsiAmt").focus();
			$("bpTsiAmt").value = "";
		} else if (parseFloat($F('bpTsiAmt').replace(/,/g, "")) >  99999999999999.99){
			showMessageBox("Entered TSI Amount is invalid. Valid value is from -99,999,999,999,999.99 - 99,999,999,999,999.99.", imgMessage.ERROR);
			$("bpTsiAmt").focus();
			$("bpTsiAmt").value = "";
		}
	});	

	function checkBeneficiaryExist(){
		var ok = true;
		var selected = 0;
		
		$$("div[name='benefit']").each(function(row){
			if (row.hasClassName("selectedRow")){
				selected = 1;
			}	
		});	
		
		if (selected == 0){
			showMessageBox("Please select a Beneficiary Item first.", imgMessage.ERROR);
			ok = false;
		}
		return ok;
	}

	$("btnAddBeneficiaryPerils").observe("click", function() {
		$("popBenDiv").hide();
		if (checkBeneficiaryExist()){
			addBeneficiaryPeril();
		} else{
			return false;
		}		
	});

	$$("div[name='benPeril']").each(
			function (newDiv)	{
				newDiv.observe("mouseover", function ()	{
					newDiv.addClassName("lightblue");
				});
				
				newDiv.observe("mouseout", function ()	{
					newDiv.removeClassName("lightblue");
				});

				newDiv.observe("click", function ()	{
					newDiv.toggleClassName("selectedRow");
					if (newDiv.hasClassName("selectedRow"))	{
						$$("div[name='benPeril']").each(function (li)	{
							if (newDiv.getAttribute("id") != li.getAttribute("id"))	{
								li.removeClassName("selectedRow");
							}	
						});

						$("bpPerilCd").value = newDiv.down("input",2).value;	
						$("bpTsiAmt").value = (newDiv.down("input",3).value == "" ? "" :formatCurrency(newDiv.down("input",3).value));	
						$("bpGroupedItemNo").value = newDiv.down("input",4).value;	
						$("bpBeneficiaryNo").value = newDiv.down("input",5).value;	
						$("bpLineCd").value = newDiv.down("input",6).value;	
						$("bpRecFlag").value = newDiv.down("input",7).value;	
						$("bpPremRt").value = newDiv.down("input",8).value;	
						$("bpPremAmt").value = newDiv.down("input",9).value;	
						$("bpAnnTsiAmt").value = newDiv.down("input",10).value;	
						$("bpAnnPremAmt").value = newDiv.down("input",11).value;	

						getDefaultsPeril();
					} else {
						clearFormPeril();
					} 
				}); 
			}	
	);

	function addBeneficiaryPeril() {	
		try	{
			var bpParId = $F("parId");
			var bpItemNo = $F("itemNo");
			var bpPerilCd = $F("bpPerilCd");
			var bpTsiAmt = $F("bpTsiAmt");
			var bpGroupedItemNo = getSelectedRowAttrValue("grpItem","groupedItemNo");
			var bpBeneficiaryNo = $F("bBeneficiaryNo");
			var bpLineCd = ($F("bpLineCd") == "" ? $F("globalLineCd") :$F("bpLineCd")); 
			var bpRecFlag = ($F("bpRecFlag") == "" ? "C" :$F("bpRecFlag"));
			var bpPremRt = $F("bpPremRt");
			var bpPremAmt = $F("bpPremAmt");
			var bpAnnTsiAmt = $F("bpAnnTsiAmt");
			var bpAnnPremAmt = $F("bpAnnPremAmt");
			var bpPerilName = changeSingleAndDoubleQuotes2($("bpPerilCd").options[$("bpPerilCd").selectedIndex].text);
			var exists = false;

			generateSeqNoForPeril();
			
			if (bpBeneficiaryNo == "" || bpPerilCd == "") {
				showMessageBox("Peril Name must be entered.", imgMessage.ERROR);
				exists = true;
			} else if (parseFloat($F('bpTsiAmt').replace(/,/g, "")) < -99999999999999.99) {
				showMessageBox("Entered TSI Amount is invalid. Valid value is from -99,999,999,999,999.99 - 99,999,999,999,999.99.", imgMessage.ERROR);
				exists = true;
			} else if (parseFloat($F('bpTsiAmt').replace(/,/g, "")) >  99999999999999.99){
				showMessageBox("Entered TSI Amount is invalid. Valid value is from -99,999,999,999,999.99 - 99,999,999,999,999.99.", imgMessage.ERROR);
				exists = true;
			}

			hideNotice("");

			if (!exists)	{
				var content = '<input type="hidden" id="bpParIds" 		    name="bpParIds" 	        value="'+bpParId+'" />'+
			 	  			  '<input type="hidden" id="bpItemNos" 		    name="bpItemNos" 	        value="'+bpItemNo+'" />'+ 
							  '<input type="hidden" id="bpPerilCds"      	name="bpPerilCds"   	 	value="'+bpPerilCd+'" />'+ 
						 	  '<input type="hidden" id="bpTsiAmts"  		name="bpTsiAmts"  			value="'+bpTsiAmt+'" />'+  
						 	  '<input type="hidden" id="bpGroupedItemNos" 	name="bpGroupedItemNos" 	value="'+bpGroupedItemNo+'" />'+ 
						 	  '<input type="hidden" id="bpBeneficiaryNos" 	name="bpBeneficiaryNos"  	value="'+bpBeneficiaryNo+'" />'+ 
						 	  '<input type="hidden" id="bpLineCds" 			name="bpLineCds" 		 	value="'+bpLineCd+'" />'+ 
						 	  '<input type="hidden" id="bpRecFlags"   		name="bpRecFlags"  	 		value="'+bpRecFlag+'" />'+
						 	  '<input type="hidden" id="bpPremRts"  	 	name="bpPremRts" 	 		value="'+bpPremRt+'" />'+
						 	  '<input type="hidden" id="bpPremAmts"  		name="bpPremAmts" 			value="'+bpPremAmt+'" />'+
						 	  '<input type="hidden" id="bpAnnTsiAmts"  		name="bpAnnTsiAmts" 		value="'+bpAnnTsiAmt+'" />'+
						 	  '<input type="hidden" id="bpAnnPremAmts"  	name="bpAnnPremAmts" 		value="'+bpAnnPremAmt+'" />'+
						 	  '<label style="text-align: left; width: 49%; margin-right: 10px;">'+bpPerilName.truncate(20, "...")+'</label>'+
							  '<label style="text-align: right; width: 49%;">'+(bpTsiAmt == "" ? "---" :bpTsiAmt.truncate(20, "..."))+'</label>';
							  
				if ($F("btnAddBeneficiaryPerils") == "Update") {
					//$("rowBenPeril"+bpGroupedItemNo+bpBeneficiaryNo).update(content);		
					$(getSelectedRowId_noSubstring("benPeril")).update(content);				
					//updateTempBeneficiaryItemNos();
					$("tempSave").value = "Y";
				} else {
					var newDiv = new Element('div');
					newDiv.setAttribute("name","benPeril");
					newDiv.setAttribute("id","rowBenPeril"+bpGroupedItemNo+bpBeneficiaryNo+$F("perilsItemSeqNo")); 
					newDiv.setAttribute("item",bpItemNo);
					newDiv.setAttribute("beneficiaryNo",bpBeneficiaryNo); 
					newDiv.setAttribute("groupedItemNo",bpGroupedItemNo); 
					newDiv.setAttribute("itemSeqNo",$F("perilsItemSeqNo")); 
					newDiv.addClassName("tableRow"); 
  
					newDiv.update(content);
					$('benPerilListing').insert({bottom: newDiv});
							 
					newDiv.observe("mouseover", function ()	{
						newDiv.addClassName("lightblue");
					});
					
					newDiv.observe("mouseout", function ()	{
						newDiv.removeClassName("lightblue");
					});
					
					newDiv.observe("click", function ()	{	
						newDiv.toggleClassName("selectedRow");
						if (newDiv.hasClassName("selectedRow"))	{
							$$("div[name='benPeril']").each(function (li)	{
									if (newDiv.getAttribute("id") != li.getAttribute("id"))	{
									li.removeClassName("selectedRow");
								}
							});

							$("bpPerilCd").value = newDiv.down("input",2).value;	
							$("bpTsiAmt").value = (newDiv.down("input",3).value == "" ? "" :formatCurrency(newDiv.down("input",3).value));	
							$("bpGroupedItemNo").value = newDiv.down("input",4).value;	
							$("bpBeneficiaryNo").value = newDiv.down("input",5).value;	
							$("bpLineCd").value = newDiv.down("input",6).value;	
							$("bpRecFlag").value = newDiv.down("input",7).value;	
							$("bpPremRt").value = newDiv.down("input",8).value;	
							$("bpPremAmt").value = newDiv.down("input",9).value;	
							$("bpAnnTsiAmt").value = newDiv.down("input",10).value;	
							$("bpAnnPremAmt").value = newDiv.down("input",11).value;	

							getDefaultsPeril();
						} else {
							clearFormPeril();
						} 
					}); 
		
					Effect.Appear(newDiv, {
						duration: .5, 
						afterFinish: function ()	{
						checkTableItemInfoAdditionalModal2("benPerilTable","benPerilListing","benPeril","beneficiaryNo",getSelectedRowAttrValue("benefit","beneficiaryNo"),"groupedItemNo",getSelectedRowAttrValue("grpItem","groupedItemNo"));
						}
					});
					//updateTempBeneficiaryItemNos();
					$("tempSave").value = "Y";
				}
				clearFormPeril();
				computeTotalForPeril();
			}
		} catch (e)	{
			showErrorMessage("addBeneficiaryPeril", e);
		}
	}

	$("btnDeleteBeneficiaryPerils").observe("click", function() {
		$("popBenDiv").hide();
		deleteBeneficiaryPeril();
	});

	function deleteBeneficiaryPeril(){
		$$("div[name='benPeril']").each(function (acc)	{
			if (acc.hasClassName("selectedRow")){
				Effect.Fade(acc, {
					duration: .5,
					afterFinish: function ()	{
						var groupedItemNo	= getSelectedRowAttrValue("grpItem","groupedItemNo");
						var beneficiaryNo	= $F("bBeneficiaryNo");
						var listingDiv 	    = $("benPerilListing");
						var newDiv 		    = new Element("div");
						newDiv.setAttribute("id", "row"+groupedItemNo+beneficiaryNo); 
						newDiv.setAttribute("name", "rowDelete"); 
						newDiv.addClassName("tableRow");
						newDiv.setStyle("display : none");
						newDiv.update(										
							'<input type="hidden" name="delBenPerilGroupedItemNos" 	value="'+groupedItemNo+'" />' +
							'<input type="hidden" name="delBenPerilBeneficiaryNos" 	value="'+beneficiaryNo+'" />');
						listingDiv.insert({bottom : newDiv});
						//updateTempBeneficiaryItemNos();
						$("tempSave").value = "Y";
						acc.remove();
						clearFormPeril();
						computeTotalForPeril();
						checkTableItemInfoAdditionalModal2("benPerilTable","benPerilListing","benPeril","beneficiaryNo",getSelectedRowAttrValue("benefit","beneficiaryNo"),"groupedItemNo",getSelectedRowAttrValue("grpItem","groupedItemNo"));
					} 
				});
			}
		});
	}	

	function getDefaultsPeril()	{
		$("btnAddBeneficiaryPerils").value = "Update";
		enableButton("btnDeleteBeneficiaryPerils");
	}

	function clearFormPeril()	{
		generateSeqNoForPeril();
		$("bpPerilCd").selectedIndex = 0;
		$("bpTsiAmt").value = "";
		$("bpGroupedItemNo").value = "";
		$("bpBeneficiaryNo").value = "";
		$("bpLineCd").value = "";
		$("bpRecFlag").value = "";
		$("bpPremRt").value = "";
		$("bpPremAmt").value = "";
		$("bpAnnTsiAmt").value = "";
		$("bpAnnPremAmt").value = "";

		$("btnAddBeneficiaryPerils").value = "Add";
		disableButton("btnDeleteBeneficiaryPerils");
		deselectRows("benPerilTable","benPeril");
		checkTableItemInfoAdditionalModal2("benPerilTable","benPerilListing","benPeril","beneficiaryNo",getSelectedRowAttrValue("benefit","beneficiaryNo"),"groupedItemNo",getSelectedRowAttrValue("grpItem","groupedItemNo"));
	}

	function generateSeqNoForPeril(){
		var itemNoSize = $$("div[name='benPeril']").size();
		var getItemNo = 0;
		if (itemNoSize > 0){
			$$("div[name='benPeril']").each(function (a){
					getItemNo = getItemNo+ " " + a.getAttribute("itemSeqNo");
			});	
		}
		$("perilsItemSeqNo2").value = (getItemNo == "" ? "0 ": getItemNo);
		var newItemNo = sortNumbers($("perilsItemSeqNo2").value).last();
		$("perilsItemSeqNo").value = parseInt(newItemNo)+1;
	}
	
	$$("div[name='benPeril']").each(function(newDiv){
		no = newDiv.getAttribute("groupedItemNo");
		beneficiaryNo = newDiv.getAttribute("beneficiaryNo");
		seqNo = newDiv.getAttribute("itemSeqNo"); 
		newDiv.setAttribute("groupedItemNo",formatNumberDigits(no,7)); 
		newDiv.setAttribute("id","rowBenPeril"+formatNumberDigits(no,7)+beneficiaryNo+seqNo);
	});

	function computeTotalForPeril(){
		var tsiAmtTotal = 0;
		$$("div[name='benPeril']").each(function(row){
			if (row.getAttribute("groupedItemNo") == getSelectedRowAttrValue("grpItem","groupedItemNo") && row.getAttribute("beneficiaryNo") == getSelectedRowAttrValue("benefit","beneficiaryNo")){
				tsiAmtTotal = parseFloat(tsiAmtTotal) + parseFloat(row.down("input",3).value.replace(/,/g, ""));
			}
		});
		$$("div[name='benefit']").each(function(grp){
			if (grp.getAttribute("groupedItemNo") == getSelectedRowAttrValue("grpItem","groupedItemNo") && grp.getAttribute("beneficiaryNo") == getSelectedRowAttrValue("benefit","beneficiaryNo")){
				grp.down("label",5).update(formatCurrency(tsiAmtTotal).truncate(15, "..."));
			}	
		});	
	}	
//end for perils

	$("btnAddBeneficiary").observe("click", function() {
		$("popBenDiv").hide();
		if (checkGroupedItemNoExist()){
			addBeneficiary();
		} else{
			return false;
		}		
	});

	$$("div[name='benefit']").each(
			function (newDiv)	{
				newDiv.observe("mouseover", function ()	{
					newDiv.addClassName("lightblue");
				});
				
				newDiv.observe("mouseout", function ()	{
					newDiv.removeClassName("lightblue");
				});

				newDiv.observe("click", function ()	{
					newDiv.toggleClassName("selectedRow");
					if (newDiv.hasClassName("selectedRow"))	{
						$$("div[name='benefit']").each(function (li)	{
							if (newDiv.getAttribute("id") != li.getAttribute("id"))	{
								li.removeClassName("selectedRow");
							}	
						});

						$("bBeneficiaryNo").value = newDiv.down("input",2).value;	
						$("bBeneficiaryName").value = newDiv.down("input",3).value;	
						$("bBeneficiaryAddr").value = newDiv.down("input",4).value;	
						$("bDateOfBirth").value = newDiv.down("input",5).value;	
						$("bAge").value = newDiv.down("input",6).value;	
						$("bRelation").value = newDiv.down("input",7).value;	
						$("bCivilStatus").value = newDiv.down("input",8).value;	
						$("bSex").value = newDiv.down("input",9).value;	
						$("bGroupedItemNo").value = newDiv.down("input",10).value;	

						setRecordListPerItem(true);
						getDefaults();
					} else {
						clearForm();
					}
				}); 
			}	
	);

	function addBeneficiary() {	
		try	{
			var bParId = $F("parId");
			var bItemNo = $F("itemNo");
			var bBeneficiaryNo = $("bBeneficiaryNo").value;
			var bBeneficiaryName = changeSingleAndDoubleQuotes2($("bBeneficiaryName").value);
			var bBeneficiaryAddr = changeSingleAndDoubleQuotes2($("bBeneficiaryAddr").value);
			var bBeneficiaryDateOfBirth = $("bDateOfBirth").value;
			var bBeneficiaryAge = $("bAge").value;
			var bBeneficiaryRelation = changeSingleAndDoubleQuotes2($("bRelation").value);
			var bBeneficiaryCivilStatus = $("bCivilStatus").value;
			var bGroupedItemNo = getSelectedRowAttrValue("grpItem","groupedItemNo");
			var bSex = $("bSex").value;
			var bTsiAmtTotal = "";
			var exists = false;
			
			if (bBeneficiaryNo == "" || bBeneficiaryName == "") {
				showMessageBox("Beneficiary name must be entered.", imgMessage.ERROR);
				exists = true;
			}
			
			$$("div[name='benefit']").each( function(a)	{
				if (a.getAttribute("beneficiaryNo") == bBeneficiaryNo && a.getAttribute("groupedItemNo") == bGroupedItemNo && $F("btnAddBeneficiary") != "Update")	{
					exists = true;
					showMessageBox("Record already exists!", imgMessage.ERROR);
				}	
			});

			hideNotice("");

			if (!exists)	{
				var content = '<input type="hidden" id="benParIds" 		     	name="benParIds" 	        value="'+bParId+'" />'+
			 	  			  '<input type="hidden" id="benItemNos" 		    name="benItemNos" 	        value="'+bItemNo+'" />'+ 
							  '<input type="hidden" id="benBeneficiaryNos"      name="benBeneficiaryNos"    value="'+bBeneficiaryNo+'" />'+ 
						 	  '<input type="hidden" id="benBeneficiaryNames"  	name="benBeneficiaryNames"  value="'+bBeneficiaryName+'" />'+  
						 	  '<input type="hidden" id="benBeneficiaryAddrs" 	name="benBeneficiaryAddrs" 	value="'+bBeneficiaryAddr+'" />'+ 
						 	  '<input type="hidden" id="benDateOfBirths" 		name="benDateOfBirths"  	value="'+bBeneficiaryDateOfBirth+'" />'+ 
						 	  '<input type="hidden" id="benAges" 				name="benAges" 		 		value="'+bBeneficiaryAge+'" />'+ 
						 	  '<input type="hidden" id="benRelations"   		name="benRelations"  	 	value="'+bBeneficiaryRelation+'" />'+
						 	  '<input type="hidden" id="benCivilStatuss"  	 	name="benCivilStatuss" 	 	value="'+bBeneficiaryCivilStatus+'" />'+
						 	  '<input type="hidden" id="benSexs"  				name="benSexs" 				value="'+bSex+'" />'+
						 	  '<input type="hidden" id="benGroupedItemNos"  	name="benGroupedItemNos" 	value="'+bGroupedItemNo+'" />'+
						 	  '<label name="textBen" style="width: 20%; margin-right: 10px; text-align: left;">'+bBeneficiaryName.truncate(20, "...")+'</label>'+
						 	  '<label name="textBen" style="width: 17%; margin-right: 10px; text-align: left;">'+(bBeneficiaryAddr == "" ? "---" :bBeneficiaryAddr.truncate(20, "..."))+'</label>'+
						 	  '<label name="textBen" style="width: 10%; margin-right: 10px; text-align: left;">'+(bBeneficiaryDateOfBirth == "" ? "---" :bBeneficiaryDateOfBirth.truncate(20, "..."))+'</label>'+
						 	  '<label name="textBen" style="width: 10%; margin-right: 10px; text-align: left;">'+(bBeneficiaryAge == "" ? "---" :bBeneficiaryAge.truncate(20, "..."))+'</label>'+
						 	  '<label name="textBen" style="width: 14%; margin-right: 10px; text-align: left;">'+(bBeneficiaryRelation == "" ? "---" :bBeneficiaryRelation.truncate(20, "..."))+'</label>'+
							  '<label name="textBen" style="width: 20%; text-align: right;">'+(bTsiAmtTotal == "" ? "---" :bTsiAmtTotal.truncate(20, "..."))+'</label>'; 
							  			   
				if ($F("btnAddBeneficiary") == "Update") {	 				 
					$("rowBenInfo"+bGroupedItemNo+bBeneficiaryNo).update(content);					
					//updateTempBeneficiaryItemNos();
					$("tempSave").value = "Y";
				} else {
					var newDiv = new Element('div');
					newDiv.setAttribute("name","benefit");
					newDiv.setAttribute("id","rowBenInfo"+bGroupedItemNo+bBeneficiaryNo);
					newDiv.setAttribute("item",bItemNo);
					newDiv.setAttribute("beneficiaryNo",bBeneficiaryNo); 
					newDiv.setAttribute("groupedItemNo",bGroupedItemNo); 
					newDiv.addClassName("tableRow"); 
  
					newDiv.update(content);
					$('bBeneficiaryListing').insert({bottom: newDiv});
							 
					newDiv.observe("mouseover", function ()	{
						newDiv.addClassName("lightblue");
					});
					
					newDiv.observe("mouseout", function ()	{
						newDiv.removeClassName("lightblue");
					});
					
					newDiv.observe("click", function ()	{	
						newDiv.toggleClassName("selectedRow");
						if (newDiv.hasClassName("selectedRow"))	{
							$$("div[name='benefit']").each(function (li)	{
									if (newDiv.getAttribute("id") != li.getAttribute("id"))	{
									li.removeClassName("selectedRow");
								}
							});

							$("bBeneficiaryNo").value = newDiv.down("input",2).value;	
							$("bBeneficiaryName").value = newDiv.down("input",3).value;	
							$("bBeneficiaryAddr").value = newDiv.down("input",4).value;	
							$("bDateOfBirth").value = newDiv.down("input",5).value;	
							$("bAge").value = newDiv.down("input",6).value;	
							$("bRelation").value = newDiv.down("input",7).value;	
							$("bCivilStatus").value = newDiv.down("input",8).value;	
							$("bSex").value = newDiv.down("input",9).value;	
							$("bGroupedItemNo").value = newDiv.down("input",10).value;	
							
							setRecordListPerItem(true);
							getDefaults();
						} else {
							clearForm();
						} 
					}); 
		
					Effect.Appear(newDiv, {
						duration: .5, 
						afterFinish: function ()	{
						checkTableItemInfoAdditionalModal("bBenefeciaryTable","bBeneficiaryListing","benefit","groupedItemNo",getSelectedRowAttrValue("grpItem","groupedItemNo"));
						}
					});
					//updateTempBeneficiaryItemNos();
					$("tempSave").value = "Y";
				}
				clearForm();
			}
		} catch (e)	{
			showErrorMessage("addBeneficiary", e);
		}
	}

	$("btnDeleteBeneficiary").observe("click", function() {
		$("popBenDiv").hide();
		deleteBeneficiaryItems();
	});

	function deleteBeneficiaryItems(){
		$$("div[name='benefit']").each(function (acc)	{
			if (acc.hasClassName("selectedRow")){
				Effect.Fade(acc, {
					duration: .5,
					afterFinish: function ()	{
						var groupedItemNo	= getSelectedRowAttrValue("grpItem","groupedItemNo");
						var beneficiaryNo	= $F("bBeneficiaryNo");
						var listingDiv 	    = $("bBeneficiaryListing");
						var newDiv 		    = new Element("div");
						newDiv.setAttribute("id", "row"+groupedItemNo+beneficiaryNo); 
						newDiv.setAttribute("name", "rowDelete"); 
						newDiv.addClassName("tableRow");
						newDiv.setStyle("display : none");
						newDiv.update(										
							'<input type="hidden" name="delBenefitGroupedItemNos" 	value="'+groupedItemNo+'" />' +
							'<input type="hidden" name="delBenefitBeneficiaryNos" 	value="'+beneficiaryNo+'" />');
						listingDiv.insert({bottom : newDiv});
						//updateTempBeneficiaryItemNos();
						$("tempSave").value = "Y";
						acc.remove();
						clearForm();
						checkTableItemInfoAdditionalModal("bBenefeciaryTable","bBeneficiaryListing","benefit","groupedItemNo",getSelectedRowAttrValue("grpItem","groupedItemNo"));
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
		generateSequenceItemInfo("benefit","bBeneficiaryNo","groupedItemNo",getSelectedRowAttrValue("grpItem","groupedItemNo"),"nextItemNoBen2");
		$("bBeneficiaryName").value = "";
		$("bBeneficiaryAddr").value = "";
		$("bDateOfBirth").value = "";
		$("bAge").value = "";
		$("bRelation").value = "";
		$("bCivilStatus").selectedIndex = 0;
		$("bSex").selectedIndex = 0;

		$("btnAddBeneficiary").value = "Add";
		disableButton("btnDeleteBeneficiary");
		deselectRows("bBenefeciaryTable","benefit");
		checkTableItemInfoAdditionalModal("bBenefeciaryTable","bBeneficiaryListing","benefit","groupedItemNo",getSelectedRowAttrValue("grpItem","groupedItemNo"));
		setRecordListPerItem(false);
	}

	$$("div[name='benefit']").each(function(newDiv){
		no = newDiv.getAttribute("groupedItemNo");
		beneficiaryNo = newDiv.getAttribute("beneficiaryNo");
		newDiv.setAttribute("groupedItemNo",formatNumberDigits(no,7)); 
		newDiv.setAttribute("id","rowBenInfo"+formatNumberDigits(no,7)+beneficiaryNo);
	});

	function setRecordListPerItem(blnApply){			
		var listTableName 	= ["benPerilTable",];
		var listRowName		= ["benPeril"];
		var listCode 		= ["beneficiaryNo"];

		clearFormPeril();
		
		if(blnApply){
			for(var index = 0, length = listTableName.length; index < length; index++){				
				$$("div[name='"+listRowName[index]+"']").each(
					function(row){						
						if (row.getAttribute("beneficiaryNo") != getSelectedRowAttrValue("benefit","beneficiaryNo") || row.getAttribute("groupedItemNo") != getSelectedRowAttrValue("grpItem","groupedItemNo")){
							$(row.getAttribute("id")).hide();
						} else{
							$(row.getAttribute("id")).show();
						}	
					});
			}			
		} else{			
			for(var index = 0, length = listTableName.length; index < length; index++){				
				$$("div[name='"+listRowName[index]+"']").each(
					function(row){
						row.hide();
					});
			}
		}
		checkTableItemInfoAdditionalModal2("benPerilTable","benPerilListing","benPeril","beneficiaryNo",getSelectedRowAttrValue("benefit","beneficiaryNo"),"groupedItemNo",getSelectedRowAttrValue("grpItem","groupedItemNo"));
	}

	computeTotalForPeril();
	generateSeqNoForPeril();
	setRecordListPerItem(false);
	checkTableItemInfoAdditionalModal("bBenefeciaryTable","bBeneficiaryListing","benefit","groupedItemNo",getSelectedRowAttrValue("grpItem","groupedItemNo"));
</script>