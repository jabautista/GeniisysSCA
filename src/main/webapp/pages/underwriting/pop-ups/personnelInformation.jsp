<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<jsp:include page="/pages/underwriting/subPages/personnelInformationListing.jsp"></jsp:include>
	<table align="center" width="520px;" border="0">
		<tr>
			<td class="rightAligned" style="width:120px;">Personnel Name </td>
			<td class="leftAligned" >
				<input id="personnelNo" name="personnelNo" type="hidden" style="width: 220px;" maxlength="6" readonly="readonly"/>
				<input id="personnelName" name="personnelName" type="text" style="width: 220px;" maxlength="50" class="required"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width:100px;">Amount Covered </td>
			<td class="leftAligned" >
				<input id="amountCoveredP" name="amountCoveredP" type="text" style="width: 220px;" maxlength="18" class="money"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Capacity</td>
			<td class="leftAligned">
				<select id="capacityCdP" name="capacityCdP" style="width: 228px;" >
					<option value=""></option>
					<c:forEach var="capacity" items="${capacityListing}">
						<option value="${capacity.positionCd}">${capacity.position}</option>				
					</c:forEach>
				</select>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Remarks </td>
			<td class="leftAligned" >
				<textarea onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);" rows="2" cols="1" style="width: 357px;" id="remarksP" name="remarksP"></textarea>
			</td>
		</tr>	
		<tr>
			<td>
				<input id="includeTagP" name="includeTagP" type="hidden" style="width: 220px;" value="Y" maxlength="1" readonly="readonly"/>
				<input id="nextItemNoP" name="nextItemNoP" type="hidden" style="width: 220px;" value="" readonly="readonly"/>
			</td>
		</tr>
	</table>
	<table align="center">
		<tr>
			<td class="rightAligned" style="text-align: left; padding-left: 5px;">
				<input type="button" class="button" 		id="btnAddPersonnel" 	name="btnAddPersonnel" 		value="Add" 		style="width: 60px;" />
				<input type="button" class="disabledButton" id="btnDeletePersonnel" 	name="btnDeletePersonnel" 	value="Delete" 		style="width: 60px;" />
			</td>
		</tr>
	</table>
	
<script type="text/javascript">
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();

	$("amountCoveredP").observe("blur", function() {
		if (parseInt($F('amountCoveredP').replace(/,/g, "")) < -99999999999999.99) {
			showMessageBox("Entered Amount Covered is invalid. Valid value is from -99,999,999,999,999.99 to 99,999,999,999,999.99.", imgMessage.ERROR);
			$("amountCoveredP").focus();
			$("amountCoveredP").value = "";
		} else if (parseInt($F('amountCoveredP').replace(/,/g, "")) >  99999999999999.99){
			showMessageBox("Entered Amount Covered is invalid. Valid value is from -99,999,999,999,999.99 to 99,999,999,999,999.99.", imgMessage.ERROR);
			$("amountCoveredP").focus();
			$("amountCoveredP").value = "";
		}		
	});

	$("btnAddPersonnel").observe("click", function() {
		if(checkIfItemExists($F("itemNo"))){
			addPersonnel();
		} else{
			return false;
		}		
	});

	$$("div[name='per']").each(
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
						$$("div[name='per']").each(function (li)	{
							if (acc.getAttribute("id") != li.getAttribute("id"))	{
								li.removeClassName("selectedRow");
							}	
						});
						var personnelNo = acc.down("input",2).value;	
						var personnelName = acc.down("input",3).value;	
						var amountCovered = acc.down("input",4).value;	
						var capacityCd = acc.down("input",5).value;		
						var remarks = acc.down("input",6).value;	
						var includeTag = acc.down("input",7).value;	
						$("personnelNo").value = personnelNo;
						$("personnelName").value = personnelName;
						$("amountCoveredP").value = amountCovered== "" ? "" :formatCurrency(amountCovered);
						$("capacityCdP").value = capacityCd;
						$("remarksP").value = remarks;
						$("includeTagP").value = includeTag;
						getDefaults();
					} else {
						clearForm();
					}
				}); 
				
			}	
	);
	
	function addPersonnel() {	
		try	{
			var pParId = $F("globalParId");
			var pItemNo = $F("itemNo");
			var pPersonnelNo = $("personnelNo").value;
			var pPersonnelName = changeSingleAndDoubleQuotes2($("personnelName").value);
			var pAmountCovered = $("amountCoveredP").value == "" ? "" :$("amountCoveredP").value;
			var pCapacityCd = $("capacityCdP").value;
			var pRemarks = changeSingleAndDoubleQuotes2($("remarksP").value);
			var pIncludeTag = $("includeTagP").value;
			var pCapacityDesc = changeSingleAndDoubleQuotes2((pCapacityCd =="" ? "" :$("capacityCdP").options[$("capacityCdP").selectedIndex].text));
			var exists = false;
			
			if (pPersonnelNo == "" || pPersonnelName == "") {
				showMessageBox("Please complete fields.", imgMessage.ERROR);
				exists = true;
			}
			
			$$("div[name='per']").each( function(a)	{
				if (a.getAttribute("personnelNo") == pPersonnelNo && a.getAttribute("item") == pItemNo && $F("btnAddPersonnel") != "Update")	{
					exists = true;
					showMessageBox("Record already exists!", imgMessage.ERROR);
				}	
			});

			hideNotice("");

			if (!exists)	{
				var content = '<input type="hidden" id="pParIds" 		     name="pParIds" 	        value="'+pParId+'" />'+
			 	  			  '<input type="hidden" id="pItemNos" 		     name="pItemNos" 	        value="'+pItemNo+'" />'+ 
							  '<input type="hidden" id="pPersonnelNos"       name="pPersonnelNos"     	value="'+pPersonnelNo+'" />'+ 
						 	  '<input type="hidden" id="pPersonnelNames"  	 name="pPersonnelNames"  	value="'+pPersonnelName+'" />'+  
						 	  '<input type="hidden" id="pAmountCovereds" 	 name="pAmountCovereds" 	value="'+pAmountCovered+'" class="money" />'+ 
						 	  '<input type="hidden" id="pCapacityCds" 		 name="pCapacityCds" 		value="'+pCapacityCd+'" />'+ 
						 	  '<input type="hidden" id="pRemarkss" 			 name="pRemarkss" 			value="'+pRemarks+'" />'+ 
						 	  '<input type="hidden" id="pIncludeTags"   	 name="pIncludeTags"  		value="'+pIncludeTag+'" />'+
						 	  '<input type="hidden" id="pCapacityDescs"  	 name="pCapacityDescs" 		value="'+pCapacityDesc+'" />'+
						 	  '<label name="textPersonnel" style="width: 25%; margin-right: 10px;" for="per'+pPersonnelName+'">'+pPersonnelName.truncate(22, "...")+'</label>'+
						 	  '<label name="textPersonnel" style="width: 20%; margin-right: 10px;" for="per'+pCapacityDesc+'">'+(pCapacityDesc == "" ? "---" :pCapacityDesc.truncate(22, "..."))+'</label>'+
							  '<label name="textPersonnel" style="width: 25%; margin-right: 7px;" for="per'+pRemarks+'">'+(pRemarks == "" ? "---" :pRemarks.truncate(22, "..."))+'</label>'+
							  '<label name="textPersonnel" style="width: 26%; text-align: right;" class="money" for="per'+pAmountCovered+'">'+(pAmountCovered == "" ? "---" :pAmountCovered.truncate(22, "..."))+'</label>'; 
							  			   
				if ($F("btnAddPersonnel") == "Update") {	 				 
					$("rowPer"+pItemNo+pPersonnelNo).update(content);					
					updateTempPersonnelItemNos();
				} else {
					var newDiv = new Element('div');
					newDiv.setAttribute("name","per");
					newDiv.setAttribute("id","rowPer"+pItemNo+pPersonnelNo);
					newDiv.setAttribute("item",pItemNo);
					newDiv.setAttribute("personnelNo",pPersonnelNo); 
					newDiv.addClassName("tableRow");
  
					newDiv.update(content);
					$('personnelListing').insert({bottom: newDiv});
							 
					newDiv.observe("mouseover", function ()	{
						newDiv.addClassName("lightblue");
					});
					
					newDiv.observe("mouseout", function ()	{
						newDiv.removeClassName("lightblue");
					});
					
					newDiv.observe("click", function ()	{	
						newDiv.toggleClassName("selectedRow");
						if (newDiv.hasClassName("selectedRow"))	{
							$$("div[name='per']").each(function (li)	{
									if (newDiv.getAttribute("id") != li.getAttribute("id"))	{
									li.removeClassName("selectedRow");
								}
							});
							var personnelNo = newDiv.down("input",2).value;	
							var personnelName = newDiv.down("input",3).value;	
							var amountCovered = newDiv.down("input",4).value;	
							var capacityCd = newDiv.down("input",5).value;		
							var remarks = newDiv.down("input",6).value;	
							var includeTag = newDiv.down("input",7).value;	
							$("personnelNo").value = personnelNo;
							$("personnelName").value = personnelName;
							$("amountCoveredP").value = amountCovered == "" ? "" :formatCurrency(amountCovered);
							$("capacityCdP").value = capacityCd;
							$("remarksP").value = remarks;
							$("includeTagP").value = includeTag;
							getDefaults();
						} else {
							clearForm();
						} 
					}); 
		
					Effect.Appear(newDiv, {
						duration: .5, 
						afterFinish: function ()	{
						checkTableItemInfoAdditional("personnelTable","personnelListing","per","item",$F("itemNo"));
						}
					});
					updateTempPersonnelItemNos();
				}
				clearForm();
			}
		} catch (e)	{
			showErrorMessage("addPersonnel", e);
		}
	}

	$("btnDeletePersonnel").observe("click", function() {
		if(checkIfItemExists($F("itemNo"))){
			deletePersonnelItems();
		} else{
			return false;
		}			
	});

	function deletePersonnelItems(){
		$$("div[name='per']").each(function (acc)	{
			if (acc.hasClassName("selectedRow")){
				Effect.Fade(acc, {
					duration: .5,
					afterFinish: function ()	{
						var itemNo		    = $F("itemNo");
						var pPersonnelNo	= $F("personnelNo");
						var listingDiv 	    = $("personnelListing");
						var newDiv 		    = new Element("div");
						newDiv.setAttribute("id", "row"+itemNo+pPersonnelNo); 
						newDiv.setAttribute("name", "rowDelete"); 
						newDiv.addClassName("tableRow");
						newDiv.setStyle("display : none");
						newDiv.update(										
							'<input type="hidden" name="delPersonnelItemNos" 	value="'+itemNo+'" />' +
							'<input type="hidden" name="delPersonnelNos" 	value="'+pPersonnelNo+'" />');
						listingDiv.insert({bottom : newDiv});
						updateTempPersonnelItemNos();
						acc.remove();
						clearForm();
						checkTableItemInfoAdditional("personnelTable","personnelListing","per","item",$F("itemNo"));
					} 
				});
			}
		});
	}	

	function getDefaults()	{
		$("btnAddPersonnel").value = "Update";
		enableButton("btnDeletePersonnel");
	}

	function clearForm()	{
		generateSequenceItemInfo("per","personnelNo","item",$F("itemNo"),"nextItemNoP");
		$("personnelName").value = "";
		$("capacityCdP").selectedIndex = 0;
		$("amountCoveredP").value = "";
		$("remarksP").value = "";
		$("includeTagP").value = "Y";
		
		$("btnAddPersonnel").value = "Add";
		disableButton("btnDeletePersonnel");
		$$("div[name='per']").each(function (div) {
			div.removeClassName("selectedRow");
		});
		checkTableItemInfoAdditional("personnelTable","personnelListing","per","item",$F("itemNo"));
		computeTotalAmountInTable("personnelTable","per",4,"item",$F("itemNo"),"personnelInfoTotalAmtDiv");
	}

	function updateTempPersonnelItemNos(){
		var temp = $F("tempPersonnelItemNos").blank() ? "" : $F("tempPersonnelItemNos");
		$("tempPersonnelItemNos").value = temp + $F("itemNo") + " ";
	}

	generateSequenceItemInfo("per","personnelNo","item",$F("itemNo"),"nextItemNoP");
	checkTableItemInfoAdditional("personnelTable","personnelListing","per","item",$F("itemNo"));
</script>
		