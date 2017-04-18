<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
	
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<!-- <div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
   		<label>Accessory Information</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" style="margin-left: 5px;">Hide</label>
   		</span>
   	</div>
</div>
 -->
<!-- <div id="groupDiv" name="groupDiv" class="sectionDiv"> -->
	<!-- <span class="notice" id="noticePopup" name="noticePopup" style="display: none;">Saving, please wait...</span>  -->
	<!-- <form id="accessoryForm" name="accessoryForm" style="margin: 10px;"> -->
	<!-- <input type="hidden" id="parId" name="parId" value="${parId}" /> -->
	<!-- <input type="hidden" id="itemNo" name="itemNo" value="${itemNo}" /> -->	
	<jsp:include page="/pages/underwriting/subPages/accessoryTable.jsp"></jsp:include>
		<table align="center" border="0" id="maintainAccForm">
			<tr>
				<td class="rightAligned">Accessory Name</td>
				<td class="leftAligned">
					<input type="text" name="txtAccessoryName" id="txtAccessoryName" class="required" readonly="readonly" style="width: 360px; height: 13px;" />
					<select id="selAccessory" name="selAccessory" style="width: 368px;" class="required">
						<option value="" aDesc="" aAmt=""></option>
						<c:forEach var="a" items="${accessoryListing}">
							<option value="${a.accessoryCd}" aDesc="${a.accessoryDesc}" aAmt="${a.accAmt}" >${a.accessoryDesc}</option>
						</c:forEach>						
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Amount</td>
				<td class="leftAligned">
				<input type="hidden" name="accessoryDesc" id="accessoryDesc" value="" />
				<!-- <input id="accessoryAmount" name="accessoryAmount" type="text" value="" class="money2" style="width: 227px;" maxlength="13" min="0.00" max="9999999999.99" errorMsg="Entered Amount is invalid. Valid value is from 0.00 to 9,999,999,999.99" /> -->
				<input id="accessoryAmount" name="accessoryAmount" type="text" value="" class="money" style="width: 360px;" maxlength="13" min="0.00" max="9999999999.99" errorMsg="Entered Amount is invalid. Valid value is from 0.00 to 9,999,999,999.99" />
			</tr>
		</table>
		<table align="center">
			<tr>
				<td colspan="2" style="text-align:center;">
					<input type="button" class="button" 		id="btnAddA" 	name="btnAddA" 		value="Add" />
					<input type="button" class="disabledButton" id="btnDeleteA" name="btnDeleteA" 	value="Delete" />
				</td>
			</tr>
		</table>
	<!-- </form> -->
<!-- </div> -->
<!-- 
<div class="buttonsDivPopup">
	<input type="button" class="button" style="width: 130px;" id="btnMaintainD" name="btnMaintainD" value="Maintain Deductible" />
	<input type="button" class="button" style="width: 60px;" id="btnCancel" name="btnCancel" value="Cancel" />
	<input type="button" class="button" style="width: 60px;" id="btnSaveA" name="btnSaveA" value="Save" />
</div>	  
 -->
<script type="text/javascript">
	//$("btnCancel").observe("click", function() {
	//	Modalbox.hide();
	//});

	//$("btnSaveA").observe("click", function() {
	//	saveAccesorry();
	//});
try{
	
	//objGIPIWMcAcc = null;	// <== @UCPBGEN
	//objGIPIWMcAcc = JSON.parse('${objGIPIWMcAccs}');	// <== @UCPBGEN	

	function loadSelectedAccessory(row){
		var currentObj = new Object();

		for(var i=0, length=objGIPIWMcAcc.length; i < length; i++){				
			if(objGIPIWMcAcc[i].itemNo == row.getAttribute("item") && objGIPIWMcAcc[i].accessoryCd == row.getAttribute("accCd")){										
				currentObj = objGIPIWMcAcc[i];
				break;
			}
		}

		setAccessoryForm(currentObj);

		delete currentObj;
	}	

	function setAccessory(){
		try{
			var newObj = new Object();

			newObj.parId			= (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
			newObj.itemNo			= $F("itemNo");
			newObj.accessoryCd		= $F("selAccessory");
			newObj.accessoryDesc	= $("selAccessory").options[$("selAccessory").selectedIndex].text;
			newObj.accAmt			= $F("accessoryAmount").empty() ? null : formatCurrency($F("accessoryAmount")).replace(/,/g, "");
			newObj.userId			= $F("userId");

			return newObj;
		}catch(e){
			showErrorMessage("setAccessory", e);
		}
	}
	
	showAccessoryList();
	setAccessoryForm(null);
	
	//loadAccessoryRowObserver();
	
	initializeAll();
	initializeAllMoneyFields();
	addStyleToInputs();	
	
	$("accessoryAmount").observe("blur", function() {
		if (parseFloat($F("accessoryAmount").replace(/,/g, "")) > 9999999999.99 || parseFloat($F("accessoryAmount").replace(/,/g, "")) < 0){
			showMessageBox("Entered Amount is invalid. Valid value is from 0.00 to 9,999,999,999.99.", imgMessage.ERROR);
			$("accessoryAmount").clear();
			$("accessoryAmount").focus();
		}	
	});
	
	$("btnAddA").observe("click", function() {		
		var selected = false;
		$$("div#itemTable .selectedRow").each(function(row){
			selected = true;
		});

		if(!selected){
			showMessageBox("Please select an item first.", imgMessage.ERROR);
			return false;
		}

		if($F("selAccessory").blank()){
			showMessageBox("Accessory name required.", imgMessage.ERROR);
			return false;			
		}

		addAccessory();
		($$("div#accessory [changed=changed]")).invoke("removeAttribute", "changed");
	});	

	function addAccessory(){
		try{
			var obj 	= setAccessory();
			var content = prepareAccessory(obj);

			if($F("btnAddA") == "Update"){
				$("rowAcc" + obj.itemNo + "_" + obj.accessoryCd).update(content);
				$("rowAcc" + obj.itemNo + "_" + obj.accessoryCd).removeClassName("selectedRow");
				addModedObjByAttr(objGIPIWMcAcc, obj, "accessoryCd");
			}else{
				var table 	= $("accListing");
				var newDiv	= new Element("div");

				newDiv.setAttribute("id", "rowAcc" + obj.itemNo + "_" + obj.accessoryCd);
				newDiv.setAttribute("name", "rowAcc");
				newDiv.setAttribute("item", obj.itemNo);
				newDiv.setAttribute("accCd", obj.accessoryCd);				
				newDiv.addClassName("tableRow");

				newDiv.update(content);
				table.insert({bottom : newDiv});

				loadAccessoryRowObserver(newDiv);

				new Effect.Appear("rowAcc" + obj.itemNo + "_" + obj.accessoryCd, {
					duration : 0.2
				});

				addNewJSONObject(objGIPIWMcAcc, obj);
				//filterLOV("selAccessory","acc",2,acc.down("input",2).value,"item",$F("itemNo"));
				//filterLOV3("selAccessory", "rowAcc", "accCd", "item", obj.itemNo);				
			}
			toggleSubpagesRecord(objGIPIWMcAcc, objItemNoList, $F("itemNo"), "rowAcc", "accessoryCd",
					"accessoryTable", "accTotalAmountDiv", "accTotalAmount", "accListing", "accAmt", false);
			setAccessoryForm(null);				
		}catch(e){
			showErrorMessage("addAccessory", e);
			//showMessageBox("addAccessory : " + e.message);
		}
	}

	

	$("btnDeleteA").observe("click", function() {		
		var selected = false;
		$$("div#itemTable .selectedRow").each(function(row){
			selected = true;
		});

		if(!selected){
			showMessageBox("Please select an item first.", imgMessage.ERROR);
			return false;
		}
		deleteAccessory();
	});

	function deleteAccessory(){
		try{
			$$("div#accessoryTable .selectedRow").each(function(row){
				Effect.Fade(row, {
					duration : .3,
					afterFinish : function(){
						var delObj = setAccessory();
						addDelObjByAttr(objGIPIWMcAcc, delObj, "accessoryCd");
						row.remove();
						setAccessoryForm(null);
						filterLOV3("selAccessory", "rowAcc", "accCd", "item", delObj.itemNo);
						checkPopupsTableWithTotalAmountbyObject(objGIPIWMcAcc, "accessoryTable", "accListing", "rowAcc",
								"accAmt", "accTotalAmountDiv", "accTotalAmount");
					}
				});
			});
		}catch(e){
			showErrorMessage("deleteAccessory", e);
			//showMessageBox("deleteAccessory : " + e.message);
		}
	}

	/*
	$$("div[name='acc']").each(
			function (acc)	{
				acc.observe("mouseover", function ()	{
					acc.addClassName("lightblue");
				});
				
				acc.observe("mouseout", function ()	{
					acc.removeClassName("lightblue");
				});

				acc.observe("click", function ()	{
					$("selAccessory").enable();
					acc.toggleClassName("selectedRow");
					if (acc.hasClassName("selectedRow"))	{
						$$("div[name='acc']").each(function (li)	{
							if (acc.getAttribute("id") != li.getAttribute("id"))	{
								li.removeClassName("selectedRow");
							}	
						});
						
						var no = acc.getAttribute("id");
						var amt = (acc.getAttribute("dAmt") == "" ? "" :acc.getAttribute("dAmt"));				
						$("selAccessory").disable();
						
						filterLOV("selAccessory","acc",2,acc.down("input",2).value,"item",$F("itemNo"));
						$("selAccessory").selectedIndex = 0;
						$("selAccessory").value = acc.down("input",2).value;
						$("accessoryAmount").value = (amt == "" ? "" :formatCurrency(amt));						
						
						//var accs = $("selAccessory");
						//for (var k=0; k<accs.length; k++)	{
						//	if (accs.options[k].value == no)	{
						//		accs.selectedIndex = k;
						//	}
						//}
						
						getDefaults();
					} else {
						clearForm();
					}
				}); 
				
			}	
	);	
	
	function addAccessory() {			
		var accParId = $F("globalParId");
		var accItemNo = $F("itemNo");
		var accCD = $("selAccessory").value;
		var accDesc = $("selAccessory").options[$("selAccessory").selectedIndex].text;
		var accAmt = $("accessoryAmount").value;
		var exists = false;
		
		if (accCD == "") {
			showMessageBox("Please select an accessory.", imgMessage.ERROR);
			exists = true;
		}
		
		$$("div[name='acc']").each( function(a)	{
			if (a.getAttribute("id") == "rowAcc"+accItemNo+accCD && $F("btnAddA") != "Update")	{
				exists = true;
				showMessageBox("Record already exists!", imgMessage.ERROR);
			}
		});

		hideNotice("");
		
		if (!exists)	{
			
			var content = '<input type="hidden" id="accParIds" 		name="accParIds" 	value="'+accParId+'" />'+
		 	  			  '<input type="hidden" id="accItemNos" 	name="accItemNos" 	value="'+accItemNo+'" />'+ 
						  '<input type="hidden" id="accCds"			name="accCds" 		value="'+accCD+'" />'+
					 	  '<input type="hidden" id="accDescs" 		name="accDescs" 	value="'+accDesc+'" />'+ 
					 	  '<input type="hidden" id="accAmts" 		name="accAmts" 		value="'+accAmt+'" class="money" />'+
					 	  '<label name="text" style="text-align: right; width: 5%; margin-right: 10px;" for="accessory'+accItemNo+'">'+accItemNo+'</label>'+
					 	  '<label name="text" style="text-align: left; width: 55%; margin-right: 8px;" for="accessory'+accCD+'">'+accDesc.truncate(35, "...")+'</label>'+
						  '<label name="text" style="text-align: right; width: 37%;" class="money" for="accessory'+accCD+'">'+accAmt+'</label>';
			if ($F("btnAddA") == "Update") {					
				$("rowAcc"+accItemNo+accCD).update(content);	
				$("rowAcc"+accItemNo+accCD).setAttribute("dAmt",$F("accessoryAmount"));				
				updateTempAccessoryItemNos();
			} else {
				var newDiv = new Element('div');
				newDiv.setAttribute("name", "acc");
				newDiv.setAttribute("id", "rowAcc"+accItemNo+accCD);
				newDiv.setAttribute("dAmt",accAmt);
				newDiv.setAttribute("item",accItemNo);
				newDiv.addClassName("tableRow");
 
				newDiv.update(content);
				$('accListing').insert({bottom: newDiv});
						 
				newDiv.observe("mouseover", function ()	{
					newDiv.addClassName("lightblue");
				});
				
				newDiv.observe("mouseout", function ()	{
					newDiv.removeClassName("lightblue");
				});
				
				newDiv.observe("click", function ()	{
					$("selAccessory").enable();	
					newDiv.toggleClassName("selectedRow");
					if (newDiv.hasClassName("selectedRow"))	{
						$$("div[name='acc']").each(function (li)	{
								if (newDiv.getAttribute("id") != li.getAttribute("id"))	{
								li.removeClassName("selectedRow");
							}
						});
						var no = newDiv.getAttribute("id");
						var amt = (newDiv.getAttribute("dAmt") == "" ? "" :newDiv.getAttribute("dAmt"));				
						$("selAccessory").disable();
						
						filterLOV("selAccessory","acc",2,newDiv.down("input",2).value,"item",$F("itemNo"));
						$("selAccessory").selectedIndex = 0;
						$("selAccessory").value = newDiv.down("input",2).value;
						$("accessoryAmount").value = (amt == "" ? "" :formatCurrency(amt));
						
						
						//var accs = $("selAccessory");
						//for (var k=0; k<accs.length; k++)	{
						//	if (accs.options[k].value == no)	{
						//		accs.selectedIndex = k;
						//	}
						//}
						
						getDefaults();
					} else {
						clearForm();
					} 
				}); 
	
				Effect.Appear(newDiv, {
					duration: .5, 
					afterFinish: function ()	{
						checkTableItemInfoAdditional("accessoryTable","accListing","acc","item",$F("itemNo"));
					}
				});
				updateTempAccessoryItemNos();
			}
			checkTableItemInfoAdditional("accessoryTable","accListing","acc","item",$F("itemNo"));
			clearForm();
		}		
	}
	
	function deleteAccessory(){
		try{
			$$("div[name='acc']").each(function (acc)	{
				if (acc.hasClassName("selectedRow")){
					//delAccParIds
					Effect.Fade(acc, {
						duration: .5,
						afterFinish: function ()	{
							var itemNo		= $F("itemNo");
							var accCd		= $F("selAccessory"); //getSelectedRowAttrValue("acc","accCd");
							var listingDiv 	= $("accListing");
							var newDiv 		= new Element("div");
							newDiv.setAttribute("id", "row"+itemNo+accCd);
							newDiv.setAttribute("name", "rowDel");
							newDiv.addClassName("tableRow");
							newDiv.setStyle("display : none");
							newDiv.update(										
								'<input type="hidden" name="delAccItemNos" 	value="'+itemNo+'" />' +
								'<input type="hidden" name="delAccAccCds" 	value="'+accCd+'" />');
							listingDiv.insert({bottom : newDiv});
							updateTempAccessoryItemNos();
							acc.remove();
							$("selAccessory").enable();
							clearForm();	
							checkTableItemInfoAdditional("accessoryTable","accListing","acc","item",$F("itemNo"));				
						} 
					});
				}
			});
		} catch (e)	{
			showErrorMessage("deleteAccessory", e);
		}
	}	
	*/
	function getDefaults()	{
		$("btnAddA").value = "Update";
		enableButton("btnDeleteA");
	}

	function clearForm() {
		deselectRows("accessoryTable","acc");
		$("selAccessory").selectedIndex = 0;
		$("selAccessory").enable();
		$("accessoryAmount").clear();
		$("btnAddA").value = "Add";
		disableButton("btnDeleteA");
		checkTableItemInfoAdditional("accessoryTable","accListing","acc","item",$F("itemNo"));
		computeTotalAmountInTable("accessoryTable","acc",4,"item",$F("itemNo"),"accTotalAmtDiv");
		filterLOV("selAccessory","acc",2,"","item",$F("itemNo"));
	}

	
	$("selAccessory").observe("change", function() {
		$("accessoryAmount").value = ($("selAccessory").options[$("selAccessory").selectedIndex].getAttribute("aAmt") == "" ? "" :formatCurrency($("selAccessory").options[$("selAccessory").selectedIndex].getAttribute("aAmt")));
		$("accessoryDesc").value = $("selAccessory").options[$("selAccessory").selectedIndex].getAttribute("aDesc");
	});	

	
	$("selAccessory").observe("click", function() {
		$("selAccessory").observe("change", function() {
			var accItemNo = $F("itemNo");
			var accCD = $("selAccessory").value;
			var exist = "N";
			$$("div[name='acc']").each( function(a)	{
				a.removeClassName("selectedRow");
				if (a.getAttribute("id") == "rowAcc"+accItemNo+accCD)	{
					exist = "Y";
					a.toggleClassName("selectedRow");
					$("accessoryAmount").value = (a.getAttribute("dAmt") == "" ? "" :formatCurrency(a.getAttribute("dAmt")));
				} 
			});
			buttonAdd(exist);
		});
	});		
	
	function buttonAdd(exist){
		if (exist == "Y"){
			getDefaults();
		} else {
			$("btnAddA").value = "Add";
			disableButton("btnDeleteA");
		}		
	}

	function updateTempAccessoryItemNos(){
		var temp = $F("tempAccessoryItemNos").blank() ? "" : $F("tempAccessoryItemNos");
		$("tempAccessoryItemNos").value = temp + $F("itemNo") + " ";
	}
	//clearForm();
}catch(e){
	showErrorMessage("accessoryInformation.jsp", e);
}
</script>
