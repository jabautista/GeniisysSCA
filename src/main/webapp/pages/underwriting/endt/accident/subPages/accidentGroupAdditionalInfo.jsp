<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="message" style="display:none;">${message}</div>
<div id="accidentModalMainDiv" style="height:525px; overflow-y:auto; ">
	<form id="accidentModalForm" name="accidentModalForm">
		<input type="hidden" id="globalParId" 	 name="globalParId" 	value="${parId}" />
		<input type="hidden" id="parId" 		 name="parId" 			value="${parId}" />
		<input type="hidden" id="itemNo" 	     name="itemNo" 			value="${itemNo}" />
		<input type="hidden" id="globalLineCd" 	 name="globalLineCd" 	value="${lineCd}" />
		<input type="hidden" id="itemPerilExist" name="itemPerilExist"  value="${itemPerilExist }" />
		<input type="hidden" id="itemPerilGroupedExist" name="itemPerilGroupedExist"  value="${itemPerilGroupedExist }" />
		<input type="hidden" id="tempSave" 		 name="tempSave"  		value="" />
		<input type="hidden" id="isSaved" 	 	 name="isSaved"  		value="" />
		<input type="hidden" id="newNoOfPerson"  name="newNoOfPerson"  	value="" />
		<input type="hidden" id="totalTsiAmtPerItem"   name="totalTsiAmtPerItem"  	value="${gipiWItem.tsiAmt }" class="money" maxlength="18"/>
		<input type="hidden" id="totalPremAmtPerItem"  name="totalPremAmtPerItem"  	value="${gipiWItem.premAmt }" class="money" maxlength="14"/>
		<input type="hidden" id="isFromOverwriteBen"   name="isFromOverwriteBen"    value="${isFromOverwriteBen }" />
		<input type="hidden" id="doRenumber"     	   name="doRenumber"  			value="" />
		<input type="hidden" id="popBenefitsSw" 	   name="popBenefitsSw" 		value="" />
		<input type="hidden" id="popBenefitsGroupedItemNo" name="popBenefitsGroupedItemNo" value="" />
		<input type="hidden" id="popBenefitsPackBenCd" name="popBenefitsPackBenCd" value="" />
		<input type="hidden" id="retGrpItemsTag" name="retGrpItemsTag"	value="N" />
		
	<div id="groupedItemsDetail">
		<div id="outerDiv" name="outerDiv" style="width:872px; background-color:white;" >
			<div id="innerDiv" name="innerDiv">
				<label>Grouped Items/Beneficiary Information</label>
					<span class="refreshers" style="margin-top: 0;">
					<label id="showGroupedItems" name="gro2" style="margin-left: 5px;">Hide</label>
				</span>
			</div>
		</div>	
		<jsp:include page="/pages/underwriting/endt/accident/pop-ups/accidentEndtGroupedItems.jsp"></jsp:include>
	</div>
	
	<div id="popGrpItems" style="display : none;">
		<div id="outerDiv" name="outerDiv" style="width:872px; background-color:white;">
			<div id="innerDiv" name="innerDiv">
				<label>Grouped Items</label>
					<span class="refreshers" style="margin-top: 0;">
					<label id="showPopGrpItems" name="gro" style="margin-left: 5px;">Hide</label>
					</span>
			</div>
		</div>
		<jsp:include page="/pages/underwriting/endt/accident/pop-ups/accidentEndtRetGroupedItems.jsp"></jsp:include>
	</div>
	
	<div id="popBenDiv" style="display : none;">
		<div id="outerDiv" name="outerDiv" style="width:872px; background-color:white;" >
			<div id="innerDiv" name="innerDiv">
				<label>Copy Benefits</label>
					<span class="refreshers" style="margin-top: 0;">
					<label id="showPopBenefit" name="gro" style="margin-left: 5px;">Hide</label>
				</span>
			</div>
		</div>	
		<jsp:include page="/pages/underwriting/endt/accident/pop-ups/accidentEndtPopulateBenefits.jsp"></jsp:include>
	</div>
	
	<div id="coverageDetail">
		<div id="outerDiv" name="outerDiv" style="width:872px; background-color:white;" >
			<div id="innerDiv" name="innerDiv">
				<label>Enrollee Coverage</label>
					<span class="refreshers" style="margin-top: 0;">
					<label id="showCoverage" name="gro3" style="margin-left: 5px;">Show</label>
				</span>
			</div>
		</div>			
		<jsp:include page="/pages/underwriting/endt/accident/pop-ups/accidentEndtCoverage.jsp"></jsp:include>
	</div>
	
	<div id="beneficiaryDetail">
		<div id="outerDiv" name="outerDiv" style="width:872px; background-color:white;" >
			<div id="innerDiv" name="innerDiv">
				<label>Beneficiary Information</label>
					<span class="refreshers" style="margin-top: 0;">
					<label id="showBeneficiary" name="gro" style="margin-left: 5px;">Show</label>
				</span>
			</div>
		</div>			
		<jsp:include page="/pages/underwriting/endt/accident/pop-ups/accidentEndtBeneficiary.jsp"></jsp:include>
	</div>
	
	<div class="buttonsDiv">
		<input type="button" class="button"  id="btnCancel" name="btnCancel"  value="Cancel" 	style="width: 60px;" />
		<input type="button" class="button"  id="btnSave" 	name="btnSave" 	  value="OK" 		style="width: 60px;" />
	</div>	

	</form>
</div>
<script type="text/javascript">
	//objects for reference
	/*
	objGipiwGroupedItemsList = eval('${gipiWGroupedItems}');
	objGipiwCoverageItems = eval('${gipiWCoverageItems}');
	objGipiwGroupedBenItems = eval('${gipiWGroupedBenItems}');
	objGipiwGroupedBenPerils = eval('${gipiWGroupedBenPerils}');
	*/

	objRetGipiwGroupedItems = eval('[]');
	objRetGipiwCoverageItems = eval('[]');
	objRetGipiwGroupedBenItems = eval('[]');
	objRetGroupedItemsParams = eval('[]');
	
	var itemNo 			= $F("itemNo");
	var popBenObjArray	= eval('[]');
	var ctr = 0;

	initializeAll();
	initializeAllMoneyFields();
	initializeAccordion();
	initializeAccordion2();
	initializeAllGroupedItems();
	
	/*************************************************************************/
	/*  						LOAD ALL FUNCTIONS							 */
	/*************************************************************************/
	
	function fillPopBenDiv(){
		preparePopBenObjArray();

		for (var i = 0; i < popBenObjArray.length; i++){
			var itemNo = popBenObjArray[i].itemNo;
			var enrolleeCd = popBenObjArray[i].enrolleeCd;
			var enrolleeName = popBenObjArray[i].enrolleeName;
			
			var popBenDiv = new Element("div");
			popBenDiv.setAttribute("id", "rowPopBens"+itemNo+enrolleeCd);
			popBenDiv.setAttribute("name", "popBens");
			popBenDiv.setAttribute("item", itemNo);
			popBenDiv.setAttribute("groupedItemNo", enrolleeCd);
			popBenDiv.setAttribute("groupedItemTitle", enrolleeName);
			popBenDiv.setStyle("padding-left: 1px;");
			popBenDiv.addClassName("tableRow");

			popBenDivContent =  '<label style="text-left: left; margin-right:8px; margin-left:4px;"><input type="checkbox" id="popCheck" name="popCheck" checked="checked"/></label>' + 		
								'<label name="textG" id="num" style="text-align: left; width: 45%; height:23px; margin-right: 2px;">' + enrolleeCd + '</label>' +
		    					'<label name="textG" style="text-align: left; width: 45%; height:23px; margin-right: 2px;">' + enrolleeName + '</label>';

			popBenDiv.update(popBenDivContent);
			$("accidentPopBenListing").insert({bottom : popBenDiv});
		}
	}

	function preparePopBenObjArray(){
		$$("div[name='grpItem']").each(function (groupedItem){
			var popBenObj = new Object();
			var enrolleeCd = groupedItem.id;
			var enrolleeName = groupedItem.getAttribute("enrolleeName");
			var itemNo = groupedItem.getAttribute("item");
			
			popBenObj.enrolleeCd = enrolleeCd; 
			popBenObj.enrolleeName = enrolleeName;
			popBenObj.itemNo = itemNo;
			popBenObj.checkSw = "Y";
			popBenObjArray.push(popBenObj);
		});
	}
	
	function fillGroupedItemsList(){
		try{
			for (var x = 0; x < objGipiwGroupedItemsList.length; x++){
				var enrolleeCd = objGipiwGroupedItemsList[x].groupedItemNo;
				var enrolleeName = objGipiwGroupedItemsList[x].groupedItemTitle.truncate(13, "...");
				var principalCd = objGipiwGroupedItemsList[x].principalCd == null || objGipiwGroupedItemsList[x].principalCd == "" ? "---" : objGipiwGroupedItemsList[x].principalCd;			
				var plan = "";
				for (var i = 1; i < $("packBenCd").length; i++){
					if ($("packBenCd").options[i].value == objGipiwGroupedItemsList[x].packBenCd){
						plan = $("packBenCd").options[i].innerHTML.truncate(6, "...");
						break;
					} else {
						plan = "---";
					}
				}
				var paytTerms = "";
				for (var j = 1; j < $("paytTerms").length; j++){
					if ($("paytTerms").options[j].value == objGipiwGroupedItemsList[x].paytTerms){
						paytTerms = $("paytTerms").options[j].innerHTML.truncate(13, "...");
						break;
					} else {
						paytTerms = "---";
					}
				}
				var fromDate = objGipiwGroupedItemsList[x].fromDate == null || objGipiwGroupedItemsList[x].fromDate == "" ? "---" : objGipiwGroupedItemsList[x].fromDate;
				var toDate = objGipiwGroupedItemsList[x].toDate == null || objGipiwGroupedItemsList[x].toDate == "" ? "---" : objGipiwGroupedItemsList[x].toDate;
				var tsiAmt = objGipiwGroupedItemsList[x].tsiAmt == null ? "0" : objGipiwGroupedItemsList[x].tsiAmt;
				var premAmt = objGipiwGroupedItemsList[x].premAmt == null ? "0" : objGipiwGroupedItemsList[x].premAmt;
				var id = enrolleeCd;
				
				groupedItems = '<label style="text-align: left; width: 11%; margin-right: 2px;" name="textG">' + formatNumberDigits(enrolleeCd, 7) + '</label>' +
							   '<label style="text-align: left; width: 12%; margin-right: 2px;" name="textG2">' + enrolleeName + '</label>' +
							   '<label style="text-align: left; width: 12%; margin-right: 0px;" name="textG">' + principalCd + '</label>' +
							   '<label style="text-align: left; width: 5%; margin-right: 4px;" name="textG3">' + plan + '</label>' +
							   '<label style="text-align: left; width: 12%; margin-right: 2px;" name="textG2">' + paytTerms + '</label>' +
							   '<label style="text-align: left; width: 13%; margin-right: 3px;" name="textG">' + fromDate + '</label>' +
							   '<label style="text-align: left; width: 10%; margin-right: 2px;" name="textG">' + toDate + '</label>' +
							   '<label class="money" style="width: 9%; margin-right: 2px; text-align: right;" name="textG">' + formatCurrency(tsiAmt) + '</label>' +
							   '<label class="money" style="width: 13%; text-align: right;" name="textG">' + formatCurrency(premAmt) + '</label>';			   							
	
				var newDiv = new Element("div");
				newDiv.setAttribute("name", "grpItem");
				newDiv.setAttribute("id", enrolleeCd);
				newDiv.setAttribute("enrolleeName", enrolleeName);
				newDiv.setAttribute("item", objGipiwGroupedItemsList[x].itemNo);
				newDiv.addClassName("tableRow");
				newDiv.update(groupedItems);
				$("accidentGroupedItemsListing").insert({bottom : newDiv});

			}
		} catch (e){
			showErrorMessage("fillGroupedItemsList", e);
		}
	}

	function fillCoverageItems(){
		try {
			for (var i = 0; i < objGipiwCoverageItems.length; i++){
				if (objGipiwCoverageItems[i].itemNo == itemNo){
					var enrolleeName 	= objGipiwCoverageItems[i].groupedItemTitle;
					var perilName 		= objGipiwCoverageItems[i].perilName;
					var rate			= formatToNineDecimal(objGipiwCoverageItems[i].premRt);
					var tsiAmt			= objGipiwCoverageItems[i].tsiAmt == null ? "0" : objGipiwCoverageItems[i].tsiAmt;
					var premAmt			= objGipiwCoverageItems[i].premAmt == null ? "0" : objGipiwCoverageItems[i].premAmt;
					var noOfDays		= objGipiwCoverageItems[i].noOfDays == null ? "0" : objGipiwCoverageItems[i].noOfDays;
					var baseAmt			= objGipiwCoverageItems[i].baseAmt == null ? "0" : objGipiwCoverageItems[i].baseAmt;
		
					coverageItems		= '<label name="textCov" style="text-align: left; width: 13%; margin-right: 6px;">' + enrolleeName.truncate(13, "...") + '</label>' +
										  '<label name="textCov" style="text-align: left; width: 13%; margin-right: 6px;">' + perilName.truncate(13, "...") + '</label>' + 
										  '<label name="textCov" style="text-align: right; width: 10%; margin-right: 5px;" class="moneyRate">' + formatToNineDecimal(rate) + '</label>' +
										  '<label name="textCov" style="text-align: right; width: 15%; margin-right: 5px;" class="money">' + formatCurrency(tsiAmt) + '</label>' +
										  '<label name="textCov" style="text-align: right; width: 15%; margin-right: 5px;" class="money">' + formatCurrency(premAmt) + '</label>' +
										  '<label name="textCov" style="text-align: right; width: 10%; margin-right: 5px;">' + noOfDays + '</label>' +
										  '<label name="textCov" style="text-align: right; width: 15%; margin-right: 5px;" class="money">' + formatCurrency(baseAmt) + '</label>';
										  if (objGipiwCoverageItems[i].aggregateSw == 'Y') {
												coverageItems += '<img name="checkedImg" class="printCheck" src="'+checkImgSrc+'" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 10px;" />';
										  } else {
												coverageItems += '<span style="width: 3%; height: 10px; text-align: left; display: block; margin-left: 3px;"></span>';
										  };
										  coverageItems += '</label>';
		
					var covDiv = new Element("div");
					covDiv.setAttribute("id", objGipiwCoverageItems[i].perilCd);
					covDiv.setAttribute("name", "cov");
					covDiv.setAttribute("groupedItemNo", objGipiwCoverageItems[i].groupedItemNo);
					covDiv.setAttribute("item", objGipiwCoverageItems[i].itemNo);
					covDiv.setStyle("padding-left: 1px;");
					covDiv.addClassName("tableRow"); 
					covDiv.update(coverageItems);
					
					$("coverageListing").insert({bottom : covDiv});
				}
			}
		} catch (e){
			showErrorMessage("fillCoverageItems", e);
		}
	}

	function fillGroupedBenItems(){
		try {	
			for (var i = 0; i < objGipiwGroupedBenItems.length; i++){
				if (objGipiwGroupedBenItems[i].itemNo == itemNo){
					var beneficiaryName 	= objGipiwGroupedBenItems[i].beneficiaryName;
					var beneficiaryAddr 	= objGipiwGroupedBenItems[i].beneficiaryAddr == null ? "---" : objGipiwGroupedBenItems[i].beneficiaryAddr;
					var dateOfBirth			= objGipiwGroupedBenItems[i].dateOfBirth == null ? "---" : objGipiwGroupedBenItems[i].dateOfBirth;
					var age					= objGipiwGroupedBenItems[i].age == null ? "---" : objGipiwGroupedBenItems[i].age;
					var relation			= objGipiwGroupedBenItems[i].relation == null ? "---" : objGipiwGroupedBenItems[i].relation;
	
					groupedBen				= '<label name="textBen" style="width: 20%; margin-right: 10px; text-align: left;">' + beneficiaryName + '</label>' +
											  '<label name="textBen" style="width: 17%; margin-right: 10px; text-align: left;">' + beneficiaryAddr + '</label>' +
											  '<label name="textBen" style="width: 10%; margin-right: 10px; text-align: left;">' + dateOfBirth + '</label>' +										  
											  '<label name="textBen" style="width: 10%; margin-right: 10px; text-align: left;">' + age + '</label>' +
											  '<label name="textBen" style="width: 14%; margin-right: 10px; text-align: left;">' + relation + '</label>' +
											  '<label name="textBen" style="width: 20%; text-align: right;">';

					var benDiv = new Element("div");
					benDiv.setAttribute("id", objGipiwGroupedBenItems[i].beneficiaryNo);
					benDiv.setAttribute("name", "benefit");
					benDiv.setAttribute("groupedItemNo", objGipiwGroupedBenItems[i].groupedItemNo);
					benDiv.setStyle("padding-left: 1px;");
					benDiv.addClassName("tableRow");
					benDiv.update(groupedBen);
	
					$("bBeneficiaryListing").insert({bottom : benDiv});
				}
			}
		} catch (e){
			showErrorMessage("fillGroupedBenItems", e);
		}
	}

	function fillGroupedBenPerils(id){
		try {	 
			for (var i = 0; i < objGipiwGroupedBenPerils.length; i++){
				if (objGipiwGroupedBenPerils[i].itemNo == itemNo && objGipiwGroupedBenPerils[i].beneficiaryNo == getSelectedId("benefit") && objGipiwGroupedBenPerils[i].groupedItemNo == id){
					var perilName = objGipiwGroupedBenPerils[i].perilName;
					var tsiAmt	  = objGipiwGroupedBenPerils[i].tsiAmt == null ? "0" : objGipiwGroupedBenPerils[i].tsiAmt;
	
					perils		  = '<label name="textBenPeril" style="text-align: left; width: 49%; margin-right: 10px;">' + perilName + '</label>' +
									'<label name="textBenPeril" style="text-align: right; width: 49%; class="money">' + formatCurrency(tsiAmt) + '</label>';
	
					var perilDiv = new Element("div");
					perilDiv.setAttribute("name", "benPeril");
					perilDiv.setAttribute("id", objGipiwGroupedBenPerils[i].perilCd);
					perilDiv.setAttribute("groupedItemNo", objGipiwGroupedBenPerils[i].groupedItemNo);
					perilDiv.setAttribute("itemNo", objGipiwGroupedBenPerils[i].itemNo);
					perilDiv.setAttribute("beneficiaryNo", objGipiwGroupedBenPerils[i].beneficiaryNo);
					perilDiv.setStyle("padding-left:1px; margin:auto;");
					perilDiv.addClassName("tableRow");
					perilDiv.update(perils);
	
					$("benPerilListing").insert({bottom : perilDiv});

				}
			}
		} catch (e){
			showErrorMessage("fillGroupedBenPerils", e);
		}
	}
	
	/*************************************************************************/
	
	/*************************************************************************/
	/*					ADD CLASSES TO TABLES								 */
	/*************************************************************************/
	
	$$("div[name='grpItem']").each(function (groupedItem){
		if (groupedItem.getAttribute("item") != itemNo){
			groupedItem.remove();
		} 
		addClassToAddedTables(groupedItem, groupedItemFunctions, clearEnrolleeForm);
	});

	function groupedItemFunctions(id){
		fillEnrolleeInfo(id);
		fillEnrolleeCoverage(id);
		filterBeneficiaries(id);
		enableButtons();
	}
	
	function clearEnrolleeForm(){
		clearEnrolleeInfo();
		disableButtons();
		clearCoverage();
		clearBeneficiaryItems();
	}

	$$("div[name='cov']").each(function (coverage){
		addClassToAddedTables(coverage, coverageFunctions, clearCoverageForm);
	});

	function addClassToAddedTables(div, selectFunc, unselectFunc){
		var name = div.getAttribute("name");
		div.observe("mouseover", function(){
			div.addClassName("lightblue");
		});

		div.observe("mouseout", function(){
			div.removeClassName("lightblue");
		});

		div.observe("click",
				function(){
					addObserveClick(div, name, selectFunc, unselectFunc);
				});
	}

	function addClassToTableRows(tableId, selectFunc, unselectFunc){
		$$("div[name='" + tableId + "']").each(function (row){
			var name = row.getAttribute("name");
			row.observe("mouseover", function (){
				row.addClassName("lightblue");
			});

			row.observe("mouseout", function (){
				row.removeClassName("lightblue");
			});

			row.observe("click",
					function (){
						addObserveClick(row, name, selectFunc, unselectFunc);
					});
		});
	}

	function coverageFunctions(id){
		fillCoverageInfo(id);
		toggleCoverageButtons();
	}

	function addObserveClick(div, rowName, onSelectFunc, onUnselectFunc){
		div.toggleClassName("selectedRow");
		if (div.hasClassName("selectedRow")){
			$$("div[name='" + rowName + "']").each(function (row){
				if (div.id != row.getAttribute("id")){
					row.removeClassName("selectedRow");
				} 
			});
			onSelectFunc(getSelectedId("grpItem"));
		} else {
			onUnselectFunc();
		}
	}

	$$("div[name='benefit']").each(function (ben){
		addClassToAddedTables(ben, beneficiaryItemsFunctions, clearBeneficiaryItemsForm);
	});

	function beneficiaryItemsFunctions(id){
		fillBeneficiaryItemsForm(id);
		toggleBeneficiaryButtons();
		fillGroupedBenPerils(id);
		$$("div[name='benPeril']").each(function (benPeril){
			addClassToAddedTables(benPeril, fillBeneficiaryPerilsForm, clearBeneficiaryPerilsForm);
		});	
		checkTableIfEmpty2("benPeril", "benPerilTable");
		checkIfToResizeTable2("benPerilListing", "benPeril");
		assignSequenceNoForBenPerils();
	}

	function assignSequenceNoForBenPerils(){
		var seqNo = 1;
		$$("div[name='benPeril']").each(function (bp){
			bp.setAttribute("itemSeqNo", seqNo);
			seqNo++;
		});
	}

	fillPopBenDiv();
	
	/*************************************************************************/
	
	/*************************************************************************/
	/*					GROUPED ITEM LIST FUNCTIONS							 */
	/*************************************************************************/
	
	function fillEnrolleeInfo(id){
		var index = "";

		for (var a = 0; a < objGipiwGroupedItemsList.length; a++){
			var enrolleeCd = objGipiwGroupedItemsList[a].groupedItemNo;
			if (enrolleeCd == id && objGipiwGroupedItemsList[a].itemNo == itemNo){
				index = a;
			}
		}

		$("groupedItemNo").value 		= formatNumberDigits(objGipiwGroupedItemsList[index].groupedItemNo, 7);
		$("groupedItemTitle").value 	= objGipiwGroupedItemsList[index].groupedItemTitle;
		$("principalCd").value 			= objGipiwGroupedItemsList[index].principalCd;

		var inputSelect = ['packBenCd' , 'paytTerms', 'sex', 'civilStatus', 'positionCd',
		           		   'groupCd', 'controlTypeCd'];

		var compVar		= [objGipiwGroupedItemsList[index].packBenCd,
		           		   objGipiwGroupedItemsList[index].paytTerms,
		           		   objGipiwGroupedItemsList[index].sex,
		           		   objGipiwGroupedItemsList[index].civilStatus,
		           		   objGipiwGroupedItemsList[index].positionCd,
		           		   objGipiwGroupedItemsList[index].groupCd,
		           		   objGipiwGroupedItemsList[index].controlTypeCd];

		displaySelectInfo(inputSelect, compVar);

		$("fromDate").value 			= objGipiwGroupedItemsList[index].fromDate;
		$("toDate").value 				= objGipiwGroupedItemsList[index].toDate;
		$("dateOfBirth").value 			= objGipiwGroupedItemsList[index].dateOfBirth;
		$("age").value 					= objGipiwGroupedItemsList[index].age;
		$("controlCd").value			= objGipiwGroupedItemsList[index].controlCd;
		$("salary").value				= objGipiwGroupedItemsList[index].salary;
		$("salaryGrade").value			= objGipiwGroupedItemsList[index].salaryGrade;
		$("amountCovered").value 		= formatCurrency(objGipiwGroupedItemsList[index].amountCovered);
		/*
		$("includeTag").value 			= objGipiwGroupedItemsList[index].includeTag;
		$("remarks").value 				= objGipiwGroupedItemsList[index].remarks;
		$("lineCd").value 				= objGipiwGroupedItemsList[index].lineCd;
		$("sublineCd").value 			= objGipiwGroupedItemsList[index].sublineCd;
		$("deleteSw").value 			= objGipiwGroupedItemsList[index].deleteSw;
		$("annTsiAmt").value 			= objGipiwGroupedItemsList[index].annTsiAmt;
		$("annPremAmt").value 			= objGipiwGroupedItemsList[index].annPremAmt;
		$("tsiAmt").value 				= formatCurrency(objGipiwGroupedItemsList[index].tsiAmt == null ? 0 : objGipiwGroupedItemsList[index].tsiAmt);
		$("premAmt").value 				= formatCurrency(objGipiwGroupedItemsList[index].premAmt == null ? 0 : objGipiwGroupedItemsList[index].premAmt);*/
	}

	function displaySelectInfo(inputArray, compVarArray){
		for (var i = 0; i < inputArray.length; i++){
			for (var x = 0; x < $(inputArray[i]).length; x++){
				if ($(inputArray[i]).options[x].value == compVarArray[i]){
					$(inputArray[i]).options.selectedIndex = x;
					break;
				} else {
					$(inputArray[i]).options.selectedIndex = 0;
				}
			}
		}	
	}
	
	function clearEnrolleeInfo(){
		$("groupedItemNo").value 		= "";
		$("groupedItemTitle").value 	= "";
		$("principalCd").value			= "";
		$("fromDate").value 			= "";
		$("toDate").value 				= "";
		$("dateOfBirth").value 			= "";
		$("age").value 					= "";
		$("controlCd").value			= "";
		$("salary").value				= "";
		$("salaryGrade").value			= "";
		$("amountCovered").value		= "";
		$("includeTag").value 			= "";
		$("remarks").value 				= "";
		$("lineCd").value 				= "";
		$("sublineCd").value 			= "";
		$("deleteSw").value 			= "";
		$("annTsiAmt").value 			= "";
		$("annPremAmt").value 			= "";
		$("tsiAmt").value 				= "";
		$("premAmt").value 				= "";

		$("packBenCd").options.selectedIndex 	 = 0;
		$("paytTerms").options.selectedIndex 	 = 0;
		$("sex").options.selectedIndex		 	 = 0;
		$("civilStatus").options.selectedIndex	 = 0;
		$("positionCd").options.selectedIndex	 = 0;
		$("groupCd").options.selectedIndex		 = 0;
		$("controlTypeCd").options.selectedIndex = 0;
	}
	
	/*************************************************************************/
	
	/*************************************************************************/
	/*					COVERAGE FUNCTIONS									 */
	/*************************************************************************/

	function fillEnrolleeCoverage(id){
		$("coverageTable").show();
		$$("div[name='cov']").each(function (coverage){
			if (coverage.getAttribute("groupedItemNo") != id){
				coverage.hide();
			} else {
				coverage.show();
			}
		});
		checkIfToResizeTable2("coverageListing", "cov");
		checkTableIfEmpty2("cov", "coverageTable");
	}


	function fillCoverageInfo(id){
		for (var i = 0; i < objGipiwCoverageItems.length; i++){
			if (objGipiwCoverageItems[i].perilCd == getSelectedId("cov") && objGipiwCoverageItems[i].groupedItemNo == id){
				for (var j = 0; j < $("cPerilCd").length; j++){
					if (objGipiwCoverageItems[i].perilCd  == $("cPerilCd").options[j].value && objGipiwCoverageItems[i].itemNo == itemNo){
						$("cPerilCd").options.selectedIndex = j;
					}
				}
				$("cTsiAmt").value 		= formatCurrency(objGipiwCoverageItems[i].tsiAmt == "" || objGipiwCoverageItems[i].tsiAmt == null ? "0" : objGipiwCoverageItems[i].tsiAmt);
				$("acTsiAmt").value 	= formatCurrency(objGipiwCoverageItems[i].annTsiAmt == "" || objGipiwCoverageItems[i].annTsiAmt == null ? "0" :  objGipiwCoverageItems[i].annTsiAmt);
				$("cPremAmt").value		= formatCurrency(objGipiwCoverageItems[i].premAmt == "" || objGipiwCoverageItems[i].premAmt == null ? "0" :  objGipiwCoverageItems[i].premAmt);
				$("acPremAmt").value	= formatCurrency(objGipiwCoverageItems[i].annPremAmt == "" || objGipiwCoverageItems[i].annPremAmt == null ? "0" :  objGipiwCoverageItems[i].annPremAmt);
				$("cNoOfDays").value	= objGipiwCoverageItems[i].noOfDays == "" || objGipiwCoverageItems[i].noOfDays == null ? "0" :  objGipiwCoverageItems[i].noOfDays;
				$("cPremRt").value		= formatToNineDecimal(objGipiwCoverageItems[i].premRt == "" || objGipiwCoverageItems[i].premRt == null ? "0" :  objGipiwCoverageItems[i].premRt);
				$("cBaseAmt").value		= formatCurrency(objGipiwCoverageItems[i].baseAmt == "" || objGipiwCoverageItems[i].baseAmt == null ? "0" :  objGipiwCoverageItems[i].baseAmt);

				if (objGipiwCoverageItems[i].aggregateSw == "Y"){
					$("cAggregateSw").checked = true;
				} else {
					$("cAggregateSw").checked = false;
				}
			}
		}
	}

	function toggleCoverageButtons(){
		$("btnAddCoverage").value = "Update";
		enableButton("btnDeleteCoverage");
	}

	function clearCoverageForm(){
		$("cPerilCd").selectedIndex = 0;
		$("cTsiAmt").value 			= "";
		$("acTsiAmt").value 		= "";
		$("cPremAmt").value 		= "";
		$("acPremAmt").value 		= "";
		$("cNoOfDays").value 		= "";
		$("cPremRt").value		 	= "";
		$("cBaseAmt").value			= "";
		$("cAggregateSw").checked 	= false;

		$("btnAddCoverage").value = "Add";
		disableButton("btnDeleteCoverage");
		
	}

	function clearCoverage(){
		if ($$("div[name='cov']").length != 0){
			$$("div[name='cov']").each(function (coverage){
				coverage.hide();
			});
			checkTableIfEmpty2("cov", "coverageTable");
		}
	}
	
	/*************************************************************************/
	
	/*************************************************************************/
	/*  					BENEFICIARY ITEMS FUNCTIONS						 */
	/*************************************************************************/
	
	function filterBeneficiaries(groupedItemNo){
		$("bBenefeciaryTable").show();
		$$("div[name='benefit']").each(function (benefit){
			if (benefit.getAttribute("groupedItemNo") != groupedItemNo){
				benefit.hide();
			} else {
				benefit.show();
			}
		});
		checkIfToResizeTable2("bBeneficiaryListing", "benefit");
		checkTableIfEmpty2("benefit", "bBenefeciaryTable");
	}

	function fillBeneficiaryItemsForm(id){
		var index = 0;
		for (var i = 0; i < objGipiwGroupedBenItems.length; i++){
			if (objGipiwGroupedBenItems[i].beneficiaryNo == getSelectedId("benefit") && objGipiwGroupedBenItems[i].groupedItemNo == id){
				index = i;
			}
		}
		
		$("bBeneficiaryNo").value	= objGipiwGroupedBenItems[index].beneficiaryNo;
		$("bBeneficiaryName").value = objGipiwGroupedBenItems[index].beneficiaryName;
		$("bBeneficiaryAddr").value = objGipiwGroupedBenItems[index].beneficiaryAddr;
		$("bDateOfBirth").value		= objGipiwGroupedBenItems[index].dateOfBirth;
		$("bAge").value				= objGipiwGroupedBenItems[index].age;
		$("bRelation").value		= objGipiwGroupedBenItems[index].relation;

		var benInputSelect = ['bSex', 'bCivilStatus'];
		var benCompVar	   = [objGipiwGroupedBenItems[index].sex,
		              		  objGipiwGroupedBenItems[index].civilStatus];

		displaySelectInfo(benInputSelect, benCompVar);
	}

	function toggleBeneficiaryButtons(){
		$("btnAddBeneficiary").value = "Update";
		enableButton("btnDeleteBeneficiary");
	}

	function clearBeneficiaryItemsForm(){
		$("bBeneficiaryName").value 	= "";
		$("bBeneficiaryAddr").value 	= "";
		$("bDateOfBirth").value			= "";
		$("bAge").value					= "";
		$("bRelation").value			= "";

		$("bSex").selectedIndex			= 0;
		$("bCivilStatus").selectedIndex = 0;

		$("btnAddBeneficiary").value	= "Add";
		disableButton("btnDeleteBeneficiary");

		$$("div[name='benPeril']").each(function (benPeril){
			benPeril.hide();
		});	
		checkTableIfEmpty2("benPeril", "benPerilTable");
		checkIfToResizeTable2("benPerilListing", "benPeril");
	}

	function clearBeneficiaryItems(){
		if ($$("div[name='benefit']").length != 0){
			$$("div[name='benefit']").each(function (benItems){
				benItems.hide();
			});
		}
		checkTableIfEmpty2("benefit", "bBenefeciaryTable");
	}
	
	/*************************************************************************/
	
	/*************************************************************************/
	/*  					BENEFICIARY PERILS FUNCTIONS				     */
	/*************************************************************************/
	
	function fillBeneficiaryPerils(benId){
		var bPerilName = "";
		var bTsiAmt	   = "";
		 
		for (var i = 0; i < objGipiwGroupedBenPerils.length; i++){
			if (objGipiwGroupedBenPerils[i].beneficiaryNo == benId && formatNumberDigits(objGipiwGroupedBenPerils[i].groupedItemNo, 7) == getSelectedId("grpItem") && objGipiwGroupedBenPerils[i].itemNo == itemNo){
				bPerilName = objGipiwGroupedBenPerils[i].perilName;
				bTsiAmt	   = objGipiwGroupedBenPerils[i].tsiAmt;

				perils		  = '<label name="textBenPeril" style="text-align: left; width: 49%; margin-right: 10px;">' + bPerilName + '</label>' +
								'<label name="textBenPeril" style="text-align: right; width: 49%; class="money">' + bTsiAmt + '</label>';

				var perilDiv = new Element("div");
				perilDiv.setAttribute("name", "benPeril");
				perilDiv.setAttribute("id", objGipiwGroupedBenPerils[i].perilCd);
				perilDiv.setStyle("padding-left:1px; margin:auto;");
				perilDiv.addClassName("tableRow");
				perilDiv.update(perils);
				
				$("benPerilListing").insert({bottom : perilDiv});
			}
		}	
	}

	function filterBeneficiaryPerils(){
		$("benPerilTable").show();
		$$("div[name='benPeril']").each(function (benPeril){
			if (benPeril.getAttribute("beneficiaryno") == getSelectedId("benefit") && benPeril.getAttribute("itemno") == itemNo && benPeril.getAttribute("groupeditemno") == parseInt(getSelectedId("grpItem"))){
				benPeril.show();
			} else {
				benPeril.hide();
			}
		});
	}

	function clearBeneficiaryPerilsForm(){
		$("bpPerilCd").selectedIndex = 0;
		$("bpTsiAmt").value = "";

		$("btnAddBeneficiaryPerils").value = "Add";
		disableButton("btnDeleteBeneficiaryPerils");
	}

	function fillBeneficiaryPerilsForm(benPerilId){
		for (var x = 0; x < $("bpPerilCd").length; x++){
			if ($("bpPerilCd").options[x].value == benPerilId){
				$("bpPerilCd").selectedIndex = x;
			}
		}

		for (var i = 0; i < objGipiwGroupedBenPerils.length; i++){
			if (objGipiwGroupedBenPerils[i].perilCd == benPerilId){
				var benPerilTsiAmt = objGipiwGroupedBenPerils[i].tsiAmt == null ? "0" : objGipiwGroupedBenPerils[i].tsiAmt;
				$("bpTsiAmt").value = formatCurrency(benPerilTsiAmt);
			}
		}

		$("btnAddBeneficiaryPerils").value = "Update";
		enableButton("btnDeleteBeneficiaryPerils");
	}

	function clearBeneficiaryPerils(){
		$("benPerilTable").show();
		if ($$("div[name='benPeril']").length != 0){
			$$("div[name='benPeril']").each(function (benPerils){
				benPerils.show();
			});
			checkTableIfEmpty2("benPeril", "benPerilTable");
		}
	}

	/*************************************************************************/
	
	function initializeAccordion2()	{
		$$("label[name='gro2']").each(function (label)	{
			label.observe("click", function ()	{
				label.innerHTML = label.innerHTML == "Hide" ? "Show" : "Hide";
				var infoDiv = label.up("div", 1).next().readAttribute("id");
				Effect.toggle(infoDiv, "blind", {duration: .3});
				Effect.toggle("groupedItemsInformationInfo2", "blind", {duration: .3});
			});
		});

		$$("label[name='gro3']").each(function (label)	{
			label.observe("click", function ()	{
				if ($F("itemPerilExist") == "Y" && $F("itemPerilGroupedExist") != "Y"){
					showMessageBox("You cannot insert grouped item perils because there are existing item perils for this item. Please check the records in the item peril module");
					return false;
				} else{
					label.innerHTML = label.innerHTML == "Hide" ? "Show" : "Hide";
					var infoDiv = label.up("div", 1).next().readAttribute("id");
					Effect.toggle(infoDiv, "blind", {duration: .3});
				}		
			});
		});
	}

	/*************************************************************************/

	function enableButtons(){
		$("btnAddGroupedItems").value = "Update";
		enableButton("btnDeleteGroupedItems");
	}

	function disableButtons(){
		$("btnAddGroupedItems").value = "Add";
		disableButton("btnDeleteGroupedItems");
	}

	$("btnSave").observe("click", function(){
		if ($F("copiedItemNoTo") != ""){
			$("itemNo").value = $F("copiedItemNoTo");
			$("tempSave").value = "Y";
		}
		
		$("popBenDiv").hide();
		
		if ($("tempSave").value == ""){
			showMessageBox("No changes to save.", imgMessage.INFO);
			return false;
		}

		$$("div[name='grpItem']").each( function(a)	{
			ctr++;	
		});

		if (ctr < 2){
			showMessageBox("Minimun no. of Grouped Items is two(2).", imgMessage.ERROR);
			return false;
		} else if (($("newNoOfPerson").value == "" ? $("noOfPerson").value :$("newNoOfPerson").value) != ctr){
			showConfirmBox("Message", "Saving the changes will update the No. of Persons, do you want to continue ?",  
					"Yes", "No", onOkFunc, "");
		} else{
			$("newNoOfPerson").value = ctr;
			showSavedMessage();
		}	
	});

	function onOkFunc() {
		$("newNoOfPerson").value = ctr;
		$("noOfPerson").value = ctr;
		showSavedMessage();
	}	

	function showSavedMessage(){
		showMessageBox("SUCCESS", imgMessage.SUCCESS);
		closeGroupedItemsModal();
	}

	$("btnCancel").observe("click", function (){
		closeGroupedItemsModal();
		showItemInfo();
	});

	function clearObjects(objArray){
		for (var i = 0; i < objArray.lenght; i++){
			var obj = objArray[i];
			for (var j = 0; j < obj.lenght; j++){
				obj.pop(obj[j]);
			}
		}
	}

	function closeGroupedItemsModal(){
		/*
		if ($F("isSaved") == "Y"){
			Modalbox.hide();
			showItemInfo();
			window.scrollTo(0,0); 
		} else{
			Modalbox.hide();
		}*/
		Modalbox.hide();	
	}
	
	/*************************************************************************/
	/*  						GROUPED ITEM BUTTONS						 */
	/*************************************************************************/
	
	$("packBenCd").observe("change", function () {
		var exists = false;
		
		if ($F("groupedItemNo") == "") {
			showMessageBox("Enrollee Code must be entered.", imgMessage.ERROR);
			exists = true;
		} else if ($F("groupedItemTitle") == "") {
			showMessageBox("Enrollee Name must be entered.", imgMessage.ERROR);
			exists = true;
		} 
		$$("div[name='grpItem']").each( function(a)	{
			if (!a.hasClassName("selectedRow"))	{
				if (a.id == $F("groupedItemNo") && a.getAttribute("enrolleename") == $F("groupedItemTitle"))	{
					exists = true;
					showMessageBox("Record already exists!", imgMessage.ERROR);
				}
			}
		});

		if (!exists){
			showConfirmBox("Message", "Selecting/changing a plan will populate/overwrite perils for this grouped item. Would you like to continue?",  
					"Yes", "No", onOkFuncBen, onCancelFuncBen);
		} else{
			onCancelFuncPopBen();
		}
	});

	function onOkFuncBen(){
		var ctr = 0;
		$$("div[name='grpItem']").each( function(a)	{
			ctr++;	
		});
		if (ctr<2){
			$("newNoOfPerson").value = $("noOfPerson").value;
		} else{
			$("newNoOfPerson").value = ctr;
		}

		$("isFromOverwriteBen").value = "Y";
		$("overwriteBen").value = "Y";
		updateGroupedItem();
		showSavedMessage();
	}

	function onCancelFuncBen(){
		var p=0;
		$$("div[name='grpItem']").each(function(grp){
			if (grp.hasClassName("selectedRow")){
				var pbc = "";

				for (var i = 0; i < objGipiwGroupedItemsList.length; i++){
					if (objGipiwGroupedItemsList[i].groupedItemNo == grp.id){
						pbc = objGipiwGroupedItemsList[i].packBenCd;
					}
				}
				
				$("packBenCd").value = pbc;
				p=1;
			}	
		});	
		if (p==0){
			$("packBenCd").selectedIndex = 0;
		}	
	}
	
	$("btnAddGroupedItems").observe("click", function(){
		if ($F("groupedItemNo") == ""){
			showMessageBox("Enrollee code is required.", imgMessage.ERROR);
			return false;
		} else if ($F("groupedItemTitle") == ""){
			showMessageBox("Enrollee name is required.", imgMessage.ERROR);
			return false;
		}
		
		if ($("btnAddGroupedItems").value == "Add"){
			addGroupedItem();
		} else {
			updateGroupedItem();
		}

		$("tempSave").value = "Y";
		checkIfToResizeTable2("accidentGroupedItemsListing", "grpItem");
		checkTableIfEmpty2("grpItem", "accidentGroupedItemsTable");
	});

	$("btnDeleteGroupedItems").observe("click", function(){
		deleteGroupedItem();
		deleteDataFromChildTables(getSelectedId("grpItem"));
		$("tempSave").value = "Y";
		checkIfToResizeTable2("accidentGroupedItemsListing", "grpItem");
		checkTableIfEmpty2("grpItem", "accidentGroupedItemsTable");
	});

	function deleteDataFromChildTables(grpItemId){
		deleteGrpItemCoverageChild(grpItemId);
		deleteGrpItemBenefitItemChild(grpItemId);
	}

	function deleteGrpItemCoverageChild(grpItemId){
		for (var i = 0; i < objGipiwCoverageItems.length; i++){
			if (grpItemId == objGipiwCoverageItems[i].groupedItemNo && itemNo == objGipiwCoverageItems[i].itemNo){
				addDeletedJSONObject3(grpItemId, objGipiwCoverageItems, objGipiwCoverageItems[i], "perilCd", objGipiwCoverageItems[i].perilCd);
			}
		}
	}

	function deleteGrpItemBenefitItemChild(grpItemId){
		for (var i = 0; i < objGipiwGroupedBenItems.length; i++){
			if (grpItemId == objGipiwGroupedBenItems[i].groupedItemNo && itemNo == objGipiwCoverageItems[i].itemNo){
				addDeletedJSONObject3(grpItemId, objGipiwGroupedBenItems, objGipiwGroupedBenItems[i], "beneficiaryNo", objGipiwGroupedBenItems[i].beneficiaryNo);
			}
		}
	}

	function addDeletedJSONObject3(groupedItemId, obj, delObj, keyProperty, keyValue){
		delObj.recordStatus = -1;
		var removed = false;
		for (var i=0; i<obj.length; i++) {
			var objRef = obj[i];
			if(obj[i].groupedItemNo == groupedItemId && obj[i].itemNo == delObj.itemNo && objRef[keyProperty] == keyValue){			
				//obj.splice(i, 1);
				removed = true;
			}
		}
		
		if(!removed){
			obj.push(delObj);
		}

	}

	function addGroupedItem(){
		var groupedItem = new Object();

		groupedItem.itemNo				= itemNo;
		groupedItem.parId				= $F("parId");
		groupedItem.groupedItemNo		= $F("groupedItemNo");
		groupedItem.groupedItemTitle	= $F("groupedItemTitle");
		groupedItem.principalCd			= $F("principalCd");
		groupedItem.packBenCd			= $F("packBenCd");
		groupedItem.packageCd			= changeSingleAndDoubleQuotes2($("packBenCd").options[$("packBenCd").selectedIndex].text);
		groupedItem.paytTerms			= $F("paytTerms");
		groupedItem.paytTermsDesc		= changeSingleAndDoubleQuotes2($("paytTerms").options[$("paytTerms").selectedIndex].text);
		groupedItem.fromDate			= $F("fromDate");
		groupedItem.toDate				= $F("toDate");
		groupedItem.sex					= $F("sex");
		groupedItem.dateOfBirth			= $F("dateOfBirth");
		groupedItem.age					= $F("age");
		groupedItem.civilStatus			= $F("civilStatus");
		groupedItem.positionCd			= $F("positionCd");
		groupedItem.groupCd				= $F("groupCd");
		groupedItem.groupDesc			= changeSingleAndDoubleQuotes2($("groupCd").options[$("groupCd").selectedIndex].text);
		groupedItem.controlTypeCd		= $F("controlTypeCd");
		groupedItem.controlCd			= $F("controlCd");
		groupedItem.salary				= $F("salary");
		groupedItem.salaryGrade			= $F("salaryGrade");
		groupedItem.amountCovered		= $F("amountCovered");
		groupedItem.includeTag			= $F("includeTag") == "" ? "Y" : $F("includeTag");
		groupedItem.remarks				= $F("remarks");
		groupedItem.lineCd				= $F("lineCd") == "" ? $F("globalLineCd") : $F("lineCd");
		groupedItem.sublineCd			= $F("sublineCd") == "" ? $F("globalSublineCd") : $F("sublineCd");
		groupedItem.deleteSw			= $F("deleteSw");
		groupedItem.annTsiAmt			= $F("annTsiAmt");
		groupedItem.annPremAmt			= $F("annPremAmt");
		groupedItem.tsiAmt				= $F("tsiAmt");
		groupedItem.premAmt				= $F("premAmt");
		groupedItem.overwriteBen		= $F("overwriteBen");

		addNewJSONObject(objGipiwGroupedItemsList, groupedItem);

		updateGroupedItemsTable(groupedItem, "");
	}

	function updateGroupedItem(){
		var groupedItemNo = getSelectedId("grpItem");
		
		for (var i = 0; i < objGipiwGroupedItemsList.length; i++){
			if (objGipiwGroupedItemsList[i].groupedItemNo == groupedItemNo && objGipiwGroupedItemsList[i].itemNo == itemNo){
				objGipiwGroupedItemsList[i].itemNo				= itemNo;
				objGipiwGroupedItemsList[i].parId				= $F("parId");
				objGipiwGroupedItemsList[i].groupedItemNo		= $F("groupedItemNo");
				objGipiwGroupedItemsList[i].groupedItemTitle	= $F("groupedItemTitle");
				objGipiwGroupedItemsList[i].principalCd			= $F("principalCd");
				objGipiwGroupedItemsList[i].packBenCd			= $F("packBenCd");
				objGipiwGroupedItemsList[i].packageCd			= changeSingleAndDoubleQuotes2($("packBenCd").options[$("packBenCd").selectedIndex].text);
				objGipiwGroupedItemsList[i].paytTerms			= $F("paytTerms");
				objGipiwGroupedItemsList[i].paytTermsDesc		= changeSingleAndDoubleQuotes2($("paytTerms").options[$("paytTerms").selectedIndex].text);
				objGipiwGroupedItemsList[i].fromDate			= $F("fromDate");
				objGipiwGroupedItemsList[i].toDate				= $F("toDate");
				objGipiwGroupedItemsList[i].sex					= $F("sex");
				objGipiwGroupedItemsList[i].dateOfBirth			= $F("dateOfBirth");
				objGipiwGroupedItemsList[i].age					= $F("age");
				objGipiwGroupedItemsList[i].civilStatus			= $F("civilStatus");
				objGipiwGroupedItemsList[i].positionCd			= $F("positionCd");
				objGipiwGroupedItemsList[i].groupCd				= $F("groupCd");
				objGipiwGroupedItemsList[i].groupDesc			= changeSingleAndDoubleQuotes2($("groupCd").options[$("groupCd").selectedIndex].text);
				objGipiwGroupedItemsList[i].controlTypeCd		= $F("controlTypeCd");
				objGipiwGroupedItemsList[i].controlCd			= $F("controlCd");
				objGipiwGroupedItemsList[i].salary				= $F("salary");
				objGipiwGroupedItemsList[i].salaryGrade			= $F("salaryGrade");
				objGipiwGroupedItemsList[i].amountCovered		= $F("amountCovered");
				objGipiwGroupedItemsList[i].includeTag			= $F("includeTag") == "" ? "Y" : $F("includeTag");
				objGipiwGroupedItemsList[i].remarks				= $F("remarks");
				objGipiwGroupedItemsList[i].lineCd				= $F("lineCd") == "" ? $F("globalLineCd") : $F("lineCd");
				objGipiwGroupedItemsList[i].sublineCd			= $F("sublineCd") == "" ? $F("globalSublineCd") : $F("sublineCd");
				objGipiwGroupedItemsList[i].deleteSw			= $F("deleteSw");
				objGipiwGroupedItemsList[i].annTsiAmt			= $F("annTsiAmt");
				objGipiwGroupedItemsList[i].annPremAmt			= $F("annPremAmt");
				objGipiwGroupedItemsList[i].tsiAmt				= $F("tsiAmt");
				objGipiwGroupedItemsList[i].premAmt				= $F("premAmt");
				objGipiwGroupedItemsList[i].overwriteBen		= $F("overwriteBen");
				
				updateTable(groupedItemNo, "grpItem", "id", groupedItemNo, objGipiwGroupedItemsList[i], updateGroupedItemsTable);
				//updateGroupedItemsTable(objGipiwGroupedItemsList[i]);
				addModifiedJSONObject2(objGipiwGroupedItemsList, objGipiwGroupedItemsList[i]);
				clearEnrolleeForm();
				removeSelectedClass(groupedItemNo, "grpItem");
				break;
			}
			
		}
		
	}

	function updateTable(idKey, tableRow, propertyKey, propertyValue, obj, updateTableFunc){
		$$("div[name='" + tableRow + "']").each(function (row){
			if(formatNumberDigits(row.id, 7) == formatNumberDigits(idKey, 7) && formatNumberDigits(row.getAttribute(propertyKey),7) == formatNumberDigits(propertyValue,7)){
				updateTableFunc(obj, row);
				row.remove();
			}
		});
	}

	function removeSelectedClass(rowId, rowName){
		$$("div[name='" + rowName + "']").each(function (row){
			if (row.id == rowId){
				row.removeClassName("selectedRow");
			}
		});
	}

	function addModifiedJSONObject2(objArray, editedObj) {
		editedObj.recordStatus = 1;
		for (var i=0; i<objArray.length; i++) {
			if(objArray[i].itemNo == editedObj.itemNo && objArray[i].groupedItemNo == editedObj.groupedItemNo){
				objArray.splice(i, 1);
			}
		}
		objArray.push(editedObj);
	}

	function updateGroupedItemsTable(objItem, row){
		$("accidentGroupedItemsTable").show();
		
		var id = "";
		var enrolleeCd = objItem.groupedItemNo;
		var enrolleeName = objItem.groupedItemTitle.truncate(13, "...");
		var principalCd = objItem.principalCd == null || objItem.principalCd == "" ? "---" : objItem.principalCd;			
		var plan = "---";
		for (var i = 1; i < $("packBenCd").length; i++){
			if ($("packBenCd").options[i].value == objItem.packBenCd){
				plan = $("packBenCd").options[i].innerHTML.truncate(6, "...");
			}
		}
		var paytTerms = "---";
		for (var j = 1; j < $("paytTerms").length; j++){
			if ($("paytTerms").options[j].value == objItem.paytTerms){
				paytTerms = $("paytTerms").options[j].innerHTML.truncate(13, "...");
			} 
		}
		var fromDate = objItem.fromDate == null || objItem.fromDate == "" ? "---" : objItem.fromDate;
		var toDate = objItem.toDate == null || objItem.toDate == "" ? "---" : objItem.toDate;
		var tsiAmt = objItem.tsiAmt == null || objItem.tsiAmt == "" ? "0" : objItem.tsiAmt;
		var premAmt = objItem.premAmt == null || objItem.premAmt == "" ? "0" : objItem.premAmt;
		var id = enrolleeCd;

		groupedItems = '<label style="text-align: left; width: 11%; margin-right: 2px;" name="textG">' + formatNumberDigits(enrolleeCd, 7) + '</label>' +
		   '<label style="text-align: left; width: 12%; margin-right: 2px;" name="textG2">' + enrolleeName + '</label>' +
		   '<label style="text-align: left; width: 12%; margin-right: 0px;" name="textG">' + principalCd + '</label>' +
		   '<label style="text-align: left; width: 5%; margin-right: 4px;" name="textG3">' + plan + '</label>' +
		   '<label style="text-align: left; width: 12%; margin-right: 2px;" name="textG2">' + paytTerms + '</label>' +
		   '<label style="text-align: left; width: 13%; margin-right: 3px;" name="textG">' + fromDate + '</label>' +
		   '<label style="text-align: left; width: 10%; margin-right: 2px;" name="textG">' + toDate + '</label>' +
		   '<label class="money" style="width: 9%; margin-right: 2px; text-align: right;" name="textG">' + formatCurrency(tsiAmt) + '</label>' +
		   '<label class="money" style="width: 13%; text-align: right;" name="textG">' + formatCurrency(premAmt) + '</label>';			   							

		var newDiv = new Element("div");
		newDiv.setAttribute("name", "grpItem");
		newDiv.setAttribute("id", enrolleeCd);
		newDiv.setAttribute("enrolleeName", enrolleeName);
		newDiv.setAttribute("item", objItem.itemNo);
		newDiv.addClassName("tableRow");
		newDiv.update(groupedItems);

		if ($F("btnAddGroupedItems") == "Add"){
			$("accidentGroupedItemsListing").insert({bottom : newDiv});
		} else {
			row.insert({after : newDiv});
		}

		clearEnrolleeForm();
		addClassToAddedTables(newDiv, groupedItemFunctions, clearEnrolleeForm);	

	}

	function getSelectedId(tableRow){
		var id = "";
		
		$$("div[name='" + tableRow + "']").each(function (row){
			if (row.hasClassName("selectedRow")){
				id = row.id;
			}
		});

		return id;
	}

	function getGroupedItemNo(tableRow){
		var groupedItemNo = "";

		$$("div[name='" + tableRow + "']").each(function (row){
			if (row.hasClassName("selectedRow")){
				groupedItemNo = row.getAttribute("groupedItemNo");
			}
		});

		return groupedItemNo;
	}

	function deleteGroupedItem(){
		$$("div[name='grpItem']").each(function (giRow){
			if (giRow.hasClassName("selectedRow")){
				Effect.Fade(giRow, {
					duration : .5,
					afterFinish : function (){
						giRow.remove();
						addDeletedJSONObject3(giRow.id, objGipiwGroupedItemsList, prepareDeletedObject(giRow.id), "groupedItemNo", giRow.id);
						//addDeletedJSONObject2(objGipiwGroupedItemsList, prepareDeletedObject(giRow.id), "groupedItemNo");
						clearEnrolleeForm();
					}
				});
			}
		});
	}	

	function prepareDeletedObject(enrolleeId){
		var deleteObj = new Object();
		for (var i = 0; i < objGipiwGroupedItemsList.length; i++){
			if (objGipiwGroupedItemsList[i].groupedItemNo == enrolleeId){
				deleteObj = objGipiwGroupedItemsList[i];
			}
		}
		return deleteObj;
	}

	$("btnAddCoverage").observe("click", function() {
		if (checkGroupedItemNoExist()){
			addCoverage();
		} else{
			return false;
		}

		$("tempSave").value = "Y";		
	});

	function addCoverage(){
		var cParId = $F("parId");
		var cItemNo = $F("itemNo");
		var cPerilCd = $F("cPerilCd");
		var cPremRt = $F("cPremRt");
		var cTsiAmt = $F("cTsiAmt");
		var cPremAmt = $F("cPremAmt");
		var cNoOfDays = $F("cNoOfDays");
		var cBaseAmt = $F("cBaseAmt");
		var cAggregateSw = $("cAggregateSw").checked==true?'Y':'N';
		var cAnnPremAmt = $F("cAnnPremAmt");
		var cAnnTsiAmt = $F("cAnnTsiAmt");
		var cGroupedItemNo = getSelectedRowAttrValue("grpItem","id");
		var cLineCd = ($F("cLineCd") == "" ? $F("globalLineCd") :$F("cLineCd")); 
		var cRecFlag = ($F("cRecFlag") == "" ? "C" :$F("cRecFlag"));
		var cRiCommRt = $F("cRiCommRt");
		var cRiCommAmt = $F("cRiCommAmt");
		var cPerilName = changeSingleAndDoubleQuotes2($("cPerilCd").options[$("cPerilCd").selectedIndex].text);
		var cEnrolleeName = changeSingleAndDoubleQuotes2(getSelectedRowAttrValue("grpItem","enrolleeName"));
		var cWcSw = $F("cWcSw");
		var cPerilType = $F("cPerilType");	

		var sumTsiAmt = parseFloat($F('amountCovered').replace(/,/g, "")) + parseFloat($F('totalTsiAmtPerItem').replace(/,/g, "")) + parseFloat($F("cTsiAmt").replace(/,/g, ""));
		var sumPremAmt = parseFloat($F('premAmt').replace(/,/g, "")) + parseFloat($F('totalPremAmtPerItem').replace(/,/g, "")) + parseFloat($F("cPremAmt").replace(/,/g, ""));
		var latestTsi = 0;
		var latestPrem = 0;

		$$("div[name='cov']").each(function(row){
			if (row.hasClassName("selectedRow"))	{
				var covTsi	= 0;
				var covPrem = 0;

				for (var i = 0; i < objGipiwCoverageItems.length; i++){
					if (row.id == objGipiwCoverageItems[i].perilType){
						covTsi = objGipiwCoverageItems[i].tsiAmt;
						covPrem = objGipiwCoverageItems[i].premAmt;
					}
				}
				
				latestTsi = parseFloat($F('amountCovered').replace(/,/g, "")) - parseFloat(covTsi);
				latestPrem = parseFloat($F('premAmt').replace(/,/g, "")) - parseFloat(covPrem);
			}
		});
		
		var sumTsiAmt2 = parseFloat($F('totalTsiAmtPerItem').replace(/,/g, "")) + parseFloat(latestTsi) + parseFloat($F("cTsiAmt").replace(/,/g, ""));
		var sumPremAmt2 = parseFloat($F('totalPremAmtPerItem').replace(/,/g, "")) + parseFloat(latestPrem) + parseFloat($F("cPremAmt").replace(/,/g, ""));
		
		var exists = false;
		
		if (cPerilCd == "") {
			showMessageBox("Peril Name must be entered.", imgMessage.ERROR);
			exists = true;
		} else if (cTsiAmt == "") {
			showMessageBox("TSI Amount must be entered", imgMessage.ERROR);
			exists = true;
		} else if (cPremAmt == "") {
			showMessageBox("Premium Amount must be entered", imgMessage.ERROR);
			exists = true;
		} else if (cPremRt == "") {
			showMessageBox("Peril Rate must be entered", imgMessage.ERROR);
			exists = true;
		} else if (parseFloat($F('cTsiAmt').replace(/,/g, "")) < -99999999999999.99) {
			showMessageBox("Entered TSI Amount is invalid. Valid value is from -99,999,999,999,999.99 - 99,999,999,999,999.99.", imgMessage.ERROR);
			exists = true;
		} else if (parseFloat($F('cTsiAmt').replace(/,/g, "")) >  99999999999999.99){
			showMessageBox("Entered TSI Amount is invalid. Valid value is from -99,999,999,999,999.99 - 99,999,999,999,999.99.", imgMessage.ERROR);
			exists = true;
		} else if (parseFloat($F('cPremAmt').replace(/,/g, "")) < -9999999999.99) {
			showMessageBox("Entered Premium Amount is invalid. Valid value is from -9,999,999,999.99 - 9,999,999,999.99.", imgMessage.ERROR);
			exists = true;
		} else if (parseFloat($F('cPremAmt').replace(/,/g, "")) >  9999999999.99){
			showMessageBox("Entered Premium Amount is invalid. Valid value is from -9,999,999,999.99 - 9,999,999,999.99.", imgMessage.ERROR);
			exists = true;
		} else if (parseFloat(sumTsiAmt) < -99999999999999.99) {
			if ($F("btnAddCoverage") != "Update"){
				showMessageBox("Adding this TSI Amount will exceed the maximum Total TSI Amount for this PAR. Total TSI Amount value must range from -99,999,999,999,999.99 - 99,999,999,999,999.99.", imgMessage.ERROR);
				exists = true;
			} else{
				if (parseFloat(sumTsiAmt2) < -99999999999999.99) {
					showMessageBox("Adding this TSI Amount will exceed the maximum Total TSI Amount for this PAR. Total TSI Amount value must range from -99,999,999,999,999.99 - 99,999,999,999,999.99.", imgMessage.ERROR);
					exists = true;
				}	
			}	
		} else if (parseFloat(sumTsiAmt) >  99999999999999.99){
			if ($F("btnAddCoverage") != "Update"){
				showMessageBox("Adding this TSI Amount will exceed the maximum Total TSI Amount for this PAR. Total TSI Amount value must range from -99,999,999,999,999.99 - 99,999,999,999,999.99.", imgMessage.ERROR);
				exists = true;
			} else{
				if (parseFloat(sumTsiAmt2) >  99999999999999.99){
					showMessageBox("Adding this TSI Amount will exceed the maximum Total TSI Amount for this PAR. Total TSI Amount value must range from -99,999,999,999,999.99 - 99,999,999,999,999.99.", imgMessage.ERROR);
					exists = true;
				}	
			}
		} else if (parseFloat(sumPremAmt) < -9999999999.99) {
			if ($F("btnAddCoverage") != "Update"){
				showMessageBox("Adding this Premium Amount will exceed the maximum Total Premium Amount for this PAR. Total Premium Amount value must range from -9,999,999,999.99 - 9,999,999,999.99.", imgMessage.ERROR);
				exists = true;
			} else{
				if (parseFloat(sumPremAmt2) < -9999999999.99) {
					showMessageBox("Adding this Premium Amount will exceed the maximum Total Premium Amount for this PAR. Total Premium Amount value must range from -9,999,999,999.99 - 9,999,999,999.99.", imgMessage.ERROR);
					exists = true;
				}	
			}	
		} else if (parseFloat(sumPremAmt) >  9999999999.99){
			if ($F("btnAddCoverage") != "Update"){
				showMessageBox("Adding this Premium Amount will exceed the maximum Total Premium Amount for this PAR. Total Premium Amount value must range from -9,999,999,999.99 - 9,999,999,999.99.", imgMessage.ERROR);
				exists = true;
			} else{
				if (parseFloat(sumPremAmt2) >  9999999999.99){
					showMessageBox("Adding this Premium Amount will exceed the maximum Total Premium Amount for this PAR. Total Premium Amount value must range from -9,999,999,999.99 - 9,999,999,999.99.", imgMessage.ERROR);
					exists = true;
				}	
			}
		}

		if (!exists){
			if ($F("btnAddCoverage") == "Add Peril" || $F("btnAddCoverage") == "Add"){
				if(!checkIfCoverageExists(cGroupedItemNo)){
					var covObject = new Object();
	
					covObject.parId 			= cParId;
					covObject.itemNo 			= cItemNo;
					covObject.perilCd			= cPerilCd;
					covObject.premRt			= cPremRt;
					covObject.tsiAmt			= cTsiAmt;
					covObject.premAmt			= cPremAmt;
					covObject.noOfDays			= cNoOfDays;
					covObject.baseAmt			= cBaseAmt;
					covObject.aggregateSw		= cAggregateSw;
					covObject.annTsiAmt			= cAnnTsiAmt;
					covObject.annPremAmt		= cAnnPremAmt;
					covObject.groupedItemNo		= cGroupedItemNo;
					covObject.lineCd			= cLineCd;
					covObject.recFlag			= cRecFlag;
					covObject.riCommRate		= cRiCommRt;
					covObject.riCommAmt			= cRiCommAmt;
					covObject.perilName			= cPerilName;
					covObject.groupedItemTitle 	= cEnrolleeName;
					covObject.wcSw				= cWcSw;
					covObject.perilType			= cPerilType;
	
					addNewJSONObject(objGipiwCoverageItems, covObject);
					updateCoverageItemsTable(covObject);
				}
			} else if ($F("btnAddCoverage") == "Update") {
				updateJSONCoverage();
			}
		}
	}

	function updateJSONCoverage(){
		var covPerilCd = getSelectedId("cov");
		var covGrpItemNo = getGroupedItemNo("cov");
		var itemNo = $(covPerilCd).getAttribute("item");

		for (var i = 0; i < objGipiwCoverageItems.length; i++){
			if (objGipiwCoverageItems[i].perilCd == covPerilCd && objGipiwCoverageItems[i].groupedItemNo == covGrpItemNo && objGipiwCoverageItems[i].itemNo == itemNo){
				objGipiwCoverageItems[i].parId 			= $F("parId");
				objGipiwCoverageItems[i].itemNo 		= $F("itemNo");
				objGipiwCoverageItems[i].perilCd 		= $F("cPerilCd");
				objGipiwCoverageItems[i].premRt 		= $F("cPremRt");
				objGipiwCoverageItems[i].tsiAmt 		= $F("cTsiAmt");
				objGipiwCoverageItems[i].premAmt 		= $F("cPremAmt");
				objGipiwCoverageItems[i].noOfDays 		= $F("cNoOfDays");
				objGipiwCoverageItems[i].baseAmt 		= $F("cBaseAmt");
				objGipiwCoverageItems[i].aggregateSw 	= $("cAggregateSw").checked==true?'Y':'N';
				objGipiwCoverageItems[i].annPremAmt 	= $F("cAnnPremAmt");
				objGipiwCoverageItems[i].annTsiAmt 		= $F("cAnnTsiAmt");

				updateTable(covPerilCd, "cov", "groupedItemNo", covGrpItemNo.replace(/^0+/, ''), objGipiwCoverageItems[i], updateCoverageItemsTable);
				//updateCoverageItemsTable(objGipiwCoverageItems[i]);
				addModifiedJSONObject3(objGipiwCoverageItems, objGipiwCoverageItems[i]);
				removeSelectedClass(covPerilCd, "cov");
				clearCoverageForm();
				break;
			}
		}
	}

	function updateCoverageItemsTable(obj, row){
		$("coverageTable").show();
		var numOfDays = obj.noOfDays == null || obj.noOfDays == "" ? "0" : obj.noOfDays;
		var baseAmount	= obj.baseAmt == null || obj.baseAmt == "" ? "0" : obj.baseAmt;
		newCoverageItems		= '<label name="textCov" style="text-align: left; width: 13%; margin-right: 6px;">' + obj.groupedItemTitle.truncate(13, "...") + '</label>' +
								  '<label name="textCov" style="text-align: left; width: 13%; margin-right: 6px;">' + obj.perilName.truncate(13, "...") + '</label>' +
								  '<label name="textCov" style="text-align: right; width: 10%; margin-right: 5px; class="moneyRate">' + formatToNineDecimal(obj.premRt) + '</label>' +
								  '<label name="textCov" style="text-align: right; width: 15%; margin-right: 5px;" class="money">' + formatCurrency(obj.tsiAmt) + '</label>' +
								  '<label name="textCov" style="text-align: right; width: 15%; margin-right: 5px;" class="money">' + formatCurrency(obj.premAmt) + '</label>' +
								  '<label name="textCov" style="text-align: right; width: 10%; margin-right: 5px;">' + numOfDays + '</label>' +
								  '<label name="textCov" style="text-align: right; width: 15%; margin-right: 5px;" class="money">' + formatCurrency(baseAmount) + '</label>';
								  if (obj.aggregateSw == 'Y') {
										newCoverageItems += '<img name="checkedImg" class="printCheck" src="'+checkImgSrc+'" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 10px;" />';
								  } else {
										newCoverageItems += '<span style="width: 3%; height: 10px; text-align: left; display: block; margin-left: 3px;"></span>';
								  };
								  newCoverageItems += '</label>'; 

		var covDiv = new Element("div");
		covDiv.setAttribute("id", obj.perilCd);
		covDiv.setAttribute("name", "cov");
		covDiv.setAttribute("groupedItemNo", obj.groupedItemNo);
		covDiv.setAttribute("item", obj.itemNo);
		covDiv.setStyle("padding-left: 1px;");
		covDiv.addClassName("tableRow"); 
		covDiv.update(newCoverageItems);

		if ($F("btnAddCoverage") == "Add Peril" || $F("btnAddCoverage") == "Add"){
			$("coverageListing").insert({bottom : covDiv});
		} else {
			row.insert({after : covDiv});
		}
		
		checkIfToResizeTable2("coverageListing", "cov");
		addClassToAddedTables(covDiv, coverageFunctions, clearCoverageForm);
		clearCoverageForm();
	}

	function addModifiedJSONObject3(objArray, editedObj){
		editedObj.recordStatus = 1;
		for (var i=0; i<objArray.length; i++) {
			if(objArray[i].itemNo == editedObj.itemNo && objArray[i].groupedItemNo == editedObj.groupedItemNo && objArray[i].perilCd == editedObj.perilCd){
				objArray.splice(i, 1);
			}
		}
		objArray.push(editedObj);
	}

	function checkIfCoverageExists(cGroupedItemNo){
		var exists = false;
		
		$$("div[name='cov']").each(function (cov){
			if (cov.id == $F("cPerilCd") && $F("btnAddCoverage") != "Update" && cov.getAttribute("groupedItemNo") == cGroupedItemNo){
				exists = true;
				showMessageBox("Record already exists!", imgMessage.ERROR);
			}
		});

		return exists;
	}

	/**Add beneficiary**/
	
	$("btnAddBeneficiary").observe("click", function() {
		$("popBenDiv").hide();
		if (checkGroupedItemNoExist()){
			addBeneficiary();
		} else{
			return false;
		}		

		$("tempSave").value = "Y";
	});

	function addBeneficiary(){
		try {
			$("bBeneficiaryNo").value = generateBeneficiarySeqNo();
			
			var bParId = $F("parId");
			var bItemNo = $F("itemNo");
			var bBeneficiaryNo = $("bBeneficiaryNo").value;
			var bBeneficiaryName = changeSingleAndDoubleQuotes2($("bBeneficiaryName").value);
			var bBeneficiaryAddr = changeSingleAndDoubleQuotes2($("bBeneficiaryAddr").value);
			var bBeneficiaryDateOfBirth = $("bDateOfBirth").value;
			var bBeneficiaryAge = $("bAge").value;
			var bBeneficiaryRelation = changeSingleAndDoubleQuotes2($("bRelation").value);
			var bBeneficiaryCivilStatus = $("bCivilStatus").value;
			var bGroupedItemNo = getSelectedRowAttrValue("grpItem","id");
			var bSex = $("bSex").value;
			var bTsiAmtTotal = "";
			var exists = false;

			if (bBeneficiaryName == ""){
				showMessageBox("Beneficiary name must be entered.", imgMessage.ERROR);
				exists = true;
			}

			$$("div[name='benefit']").each( function(a)	{
				if (a.id == bBeneficiaryNo && a.getAttribute("groupedItemNo") == bGroupedItemNo && $F("btnAddBeneficiary") != "Update")	{
					exists = true;
					showMessageBox("Record already exists!", imgMessage.ERROR);
				}	
			});

			hideNotice("");
			$("bBenefeciaryTable").show();

			if (!exists){
				if ($("btnAddBeneficiary").value == "Add"){
					var benItemObj = new Object();
		
					benItemObj.parId 			= bParId;
					benItemObj.itemNo 			= bItemNo;
					benItemObj.beneficiaryNo 	= bBeneficiaryNo;
					benItemObj.beneficiaryName	= bBeneficiaryName;
					benItemObj.beneficiaryAddr	= bBeneficiaryAddr;
					benItemObj.dateOfBirth		= bBeneficiaryDateOfBirth;
					benItemObj.age				= bBeneficiaryAge;
					benItemObj.relation			= bBeneficiaryRelation;
					benItemObj.civilStatus		= bBeneficiaryCivilStatus;
					benItemObj.groupedItemNo	= bGroupedItemNo;
					benItemObj.sex				= bSex;
		
					addNewJSONObject(objGipiwGroupedBenItems, benItemObj);
					addBeneficiaryInTable(benItemObj);
				} else if($("btnAddBeneficiary").value == "Update"){
					var benId = getSelectedId("benefit");
					var groupedItemNo = getGroupedItemNo("benefit");
					
					for (var i = 0; i < objGipiwGroupedBenItems.length; i++){
						if (objGipiwGroupedBenItems[i].groupedItemNo == bGroupedItemNo && objGipiwGroupedBenItems[i].beneficiaryNo == benId){
							objGipiwGroupedBenItems[i].parId 			= bParId;
							objGipiwGroupedBenItems[i].itemNo 			= bItemNo;
							objGipiwGroupedBenItems[i].beneficiaryNo 	= bBeneficiaryNo;
							objGipiwGroupedBenItems[i].beneficiaryName	= bBeneficiaryName;
							objGipiwGroupedBenItems[i].beneficiaryAddr	= bBeneficiaryAddr;
							objGipiwGroupedBenItems[i].dateOfBirth		= bBeneficiaryDateOfBirth;
							objGipiwGroupedBenItems[i].age				= bBeneficiaryAge;
							objGipiwGroupedBenItems[i].relation			= bBeneficiaryRelation;
							objGipiwGroupedBenItems[i].civilStatus		= bBeneficiaryCivilStatus;
							objGipiwGroupedBenItems[i].groupedItemNo	= bGroupedItemNo;
							objGipiwGroupedBenItems[i].sex				= bSex;
	
							updateTable(benId, "benefit", "groupedItemNo", groupedItemNo.replace(/^0+/, ''), objGipiwGroupedBenItems[i], addBeneficiaryInTable);
							//addBeneficiaryInTable(objGipiwGroupedBenItems[i]);
							addModifiedJSONObjectForBen(objGipiwGroupedBenItems, objGipiwGroupedBenItems[i]);
							removeSelectedClass(benId, "benefit");
							clearBeneficiaryItemsForm();
							break;
						}
					}
	
				}
			}
			
		} catch (e){
			showErrorMessage("addBeneficiary", e);
		}
	}

	function addModifiedJSONObjectForBen(objArray, editedObj){
		editedObj.recordStatus = 1;
		for (var i=0; i<objArray.length; i++) {
			if(objArray[i].itemNo == editedObj.itemNo && formatNumberDigits(objArray[i].groupedItemNo, 7) == editedObj.groupedItemNo && objArray[i].beneficiaryNo == editedObj.beneficiaryNo){
				objArray.splice(i, 1);
			}
		}
		objArray.push(editedObj);
	}

	function addBeneficiaryInTable(benObj, row){
		var beneficiaryName = benObj.beneficiaryName;
		var beneficiaryAddr = returnTableColumn(benObj.beneficiaryAddr);
		var dateOfBirth		= returnTableColumn(benObj.dateOfBirth);
		var age				= returnTableColumn(benObj.age);
		var relation		= returnTableColumn(benObj.relation);

		addedBen	= '<label name="textBen" style="width: 20%; margin-right: 10px; text-align: left;">' + beneficiaryName + '</label>' +
		 			  '<label name="textBen" style="width: 17%; margin-right: 10px; text-align: left;">' + beneficiaryAddr + '</label>' +
		  			  '<label name="textBen" style="width: 10%; margin-right: 10px; text-align: left;">' + dateOfBirth + '</label>' +										  
		  			  '<label name="textBen" style="width: 10%; margin-right: 10px; text-align: left;">' + age + '</label>' +
		  			  '<label name="textBen" style="width: 14%; margin-right: 10px; text-align: left;">' + relation + '</label>' +
		  			  '<label name="textBen" style="width: 20%; text-align: right;">';

		var addedBenDiv = new Element("div");
		addedBenDiv.setAttribute("id", benObj.beneficiaryNo);
		addedBenDiv.setAttribute("name", "benefit");
		addedBenDiv.setAttribute("groupedItemNo", parseInt(benObj.groupedItemNo));
		addedBenDiv.setStyle("padding-left: 1px;");
		addedBenDiv.addClassName("tableRow");
		addedBenDiv.update(addedBen);

		if ($("btnAddBeneficiary").value == "Add"){
			$("bBeneficiaryListing").insert({bottom : addedBenDiv});
		} else {
			row.insert({after : addedBenDiv});
		}
		
		checkIfToResizeTable2("bBeneficiaryListing", "benefit");
		addClassToAddedTables(addedBenDiv, beneficiaryItemsFunctions, clearBeneficiaryItemsForm);
		clearBeneficiaryItemsForm();
	}

	function returnTableColumn(item){
		var columnItem = "";

		if (item == "" || item == null){
			columnItem = "---";
		} else {
			columnItem = item;
		}
		
		return columnItem.truncate(13, "...");	
	}

	function generateBeneficiarySeqNo(){
		var benTableSize = $$("div[name='benefit']").size();
		var getItemNo = 0;
		if (benTableSize > 0){
			for (var i = 0; i < objGipiwGroupedBenItems.length; i++){
				if (objGipiwGroupedBenItems[i].groupedItemNo == parseInt($F("groupedItemNo"))){
					getItemNo = getItemNo + " " + objGipiwGroupedBenItems[i].beneficiaryNo;
				}
			}
		}

		$("nextItemNoBen2").value = (getItemNo == "" ? "0 ": getItemNo);
		var newItemNo = sortNumbers($("nextItemNoBen2").value).last();
		return parseInt(newItemNo)+1;
	}

	$("btnDeleteBeneficiary").observe("click", function() {
		$("popBenDiv").hide();
		deleteBeneficiaryItems();
		$("tempSave").value = "Y";
	});

	function deleteBeneficiaryItems(){
		$$("div[name='benefit']").each(function (a){
			if (a.hasClassName("selectedRow")){
				Effect.Fade(a, {
					duration: .5,
					afterFinish: function (){
						a.remove();
						addDeletedJSONObject(objGipiwGroupedBenItems, prepareDeletedBenItemObj(a));
						deleteChildBeneficiaryPeril(a.id);					
						checkIfToResizeTable2("bBeneficiaryListing", "benefit");
						checkTableIfEmpty2("benefit", "bBenefeciaryTable");
						clearBeneficiaryItemsForm();
					}
				});
			}
		});
	}

	function deleteChildBeneficiaryPeril(benId){
		for (var i = 0; i < objGipiwGroupedBenPerils.length; i++){
			var groupedItemNo = getSelectedId("grpItem");
			if (objGipiwGroupedBenPerils[i].groupedItemNo == groupedItemNo &&
				objGipiwGroupedBenPerils[i].beneficiaryNo == benId){
				var id = objGipiwGroupedBenPerils[i].perilCd;
				addDeletedJSONObject(objGipiwGroupedBenPerils, prepareDeletedBenPeril(id, groupedItemNo, benId));
			}
		}
	}

	function prepareDeletedBenItemObj(benRow){
		var deleteBenObj = new Object();

		for (var i = 0; i < objGipiwGroupedBenItems.length; i++){
			if (objGipiwGroupedBenItems[i].beneficiaryNo == benRow.id && objGipiwGroupedBenItems[i].groupedItemNo == benRow.groupedItemNo){
				deleteBenObj = objGipiwGroupedBenItems[i];
			}
		}

		return deleteBenObj;
	}

	/**Add beneficiary peril**/
	
	$("btnAddBeneficiaryPerils").observe("click", function (){
		var benPerilObj = generateBenPerilObject();
		if (benPerilObj == null){
			clearBeneficiaryPerilsForm();
		} else {
			if ($("btnAddBeneficiaryPerils").value == "Add" || $("btnAddBeneficiaryPerils").value == "Add Peril"){
				addBeneficiaryPerils(benPerilObj);
			} else if ($("btnAddBeneficiaryPerils").value == "Update"){
				updateBeneficiaryPerils(benPerilObj);
			}
		}
	});

	function generateBenPerilObject(){
		try	{
			var bpParId = $F("parId");
			var bpItemNo = $F("itemNo");
			var bpPerilCd = $F("bpPerilCd");
			var bpTsiAmt = $F("bpTsiAmt");
			var bpGroupedItemNo = parseInt(getSelectedRowAttrValue("grpItem","id"));
			var bpBeneficiaryNo = getSelectedId("benefit")
			var bpLineCd = ($F("bpLineCd") == "" ? $F("globalLineCd") :$F("bpLineCd")); 
			var bpRecFlag = ($F("bpRecFlag") == "" ? "C" :$F("bpRecFlag"));
			var bpPremRt = $F("bpPremRt");
			var bpPremAmt = $F("bpPremAmt");
			var bpAnnTsiAmt = $F("bpAnnTsiAmt");
			var bpAnnPremAmt = $F("bpAnnPremAmt");
			var bpPerilName = changeSingleAndDoubleQuotes2($("bpPerilCd").options[$("bpPerilCd").selectedIndex].text);
			var exists = false;

			generateSeqNoForPeril();
			
			if (bpPerilCd == "") {
				showMessageBox("Peril Name must be entered.", imgMessage.ERROR);
				exists = true;
			} else if (bpBeneficiaryNo == ""){
				showMessageBox("Please select a Beneficiary Item first.", imgMessage.ERROR);
				exists = true;
			} else if (parseFloat($F('bpTsiAmt').replace(/,/g, "")) < -99999999999999.99) {
				showMessageBox("Entered TSI Amount is invalid. Valid value is from -99,999,999,999,999.99 - 99,999,999,999,999.99.", imgMessage.ERROR);
				exists = true;
			} else if (parseFloat($F('bpTsiAmt').replace(/,/g, "")) >  99999999999999.99){
				showMessageBox("Entered TSI Amount is invalid. Valid value is from -99,999,999,999,999.99 - 99,999,999,999,999.99.", imgMessage.ERROR);
				exists = true;
			}

			if (!exists){
				var benPerilObj = new Object();
	
				benPerilObj.parId 			= bpParId;
				benPerilObj.itemNo 			= bpItemNo;
				benPerilObj.perilCd 		= bpPerilCd;
				benPerilObj.tsiAmt			= bpTsiAmt;
				benPerilObj.groupedItemNo 	= bpGroupedItemNo;
				benPerilObj.beneficiaryNo	= bpBeneficiaryNo;
				benPerilObj.lineCd			= bpLineCd;
				benPerilObj.recFlag			= bpRecFlag;
				benPerilObj.premRt			= bpPremRt;
				benPerilObj.premAmt			= bpPremAmt;
				benPerilObj.annTsiAmt		= bpAnnTsiAmt;
				benPerilObj.annPremAmt		= bpAnnPremAmt;
				benPerilObj.perilName		= bpPerilName;
	
				return benPerilObj;
			}
			
		} catch (e)	{
			showErrorMessage("generateBenPerilObject", e);
		}
	}

	function generateBenPerilRow(bpObj){
		var perilName = bpObj.perilName;
		var tsiAmt	  = bpObj.tsiAmt == "" ? "0" : bpObj.tsiAmt;

		perils		  = '<label name="textBenPeril" style="text-align: left; width: 49%; margin-right: 10px;">' + perilName + '</label>' +
						'<label name="textBenPeril" style="text-align: right; width: 49%; class="money">' + formatCurrency(tsiAmt) + '</label>';

		var perilDiv = new Element("div");
		perilDiv.setAttribute("name", "benPeril");
		perilDiv.setAttribute("id", bpObj.perilCd);
		perilDiv.setAttribute("groupedItemNo", bpObj.groupedItemNo);
		perilDiv.setAttribute("itemNo", bpObj.itemNo);
		perilDiv.setAttribute("beneficiaryNo", bpObj.beneficiaryNo);
		perilDiv.setStyle("padding-left:1px; margin:auto;");
		perilDiv.addClassName("tableRow");
		perilDiv.update(perils);

		return perilDiv;
	}
	
	function addBeneficiaryPerils(bpObj){
		var benPeril = generateBenPerilRow(bpObj);
		addNewJSONObject(objGipiwGroupedBenPerils, bpObj);
		$("benPerilListing").insert({bottom : benPeril});
		checkTableIfEmpty2("benPeril", "benPerilTable");
		checkIfToResizeTable2("benPerilListing", "benPeril");
		assignSequenceNoForBenPerils();
		clearBeneficiaryPerilsForm();
		addClassToAddedTables(benPeril, fillBeneficiaryPerilsForm, clearBeneficiaryPerilsForm);
		$("tempSave").value = "Y";
	}

	function updateBeneficiaryPerils(bpObj){
		var updatedObj = updateObjectItem(bpObj);
		var compArray = ['itemNo', 'beneficiaryNo', 'groupedItemNo', 'perilCd'];
		addModifiedJSONObjectGeneric(objGipiwGroupedBenPerils, updatedObj, compArray);
		updateTableBenPeril(bpObj);
		checkTableIfEmpty2("benPeril", "benPerilTable");
		checkIfToResizeTable2("benPerilListing", "benPeril");
		clearBeneficiaryPerilsForm();
		$("tempSave").value = "Y";
	}

	function updateTableBenPeril(bpObj){
		var newRow = generateBenPerilRow(bpObj);
		$$("div[name='benPeril']").each(function (row){
			if (row.id == newRow.id && row.getAttribute("beneficiaryNo") == newRow.getAttribute("beneficiaryNo") &&
			    row.getAttribute("groupedItemNo") == row.getAttribute("groupedItemNo") && row.getAttribute("perilCd") == newRow.getAttribute("perilCd")){
				row.insert({after : newRow});
				addClassToAddedTables(newRow, fillBeneficiaryPerilsForm, clearBeneficiaryPerilsForm);
				row.remove();
			}
		});
	}

	function addModifiedJSONObjectGeneric(oldObj, newObj, entArray){
		var matchedEntities = 0;
		var index = 0;
		newObj.recordStatus = 1;
		for (var i = 0; i < oldObj.length; i++){
			for (var j = 0; j < entArray.length; j++){
				var entity = entArray[j];
				if (oldObj[entity] == newObj[entity]){
					matchedEntities++;
				}
			}
			if (matchedEntities == entArray.length){
				index = i;
			}
		}
		oldObj.splice(index, 1);
		oldObj.push(newObj);
	}

	function updateObjectItem(bpObj){
		var index = 0;
		var entityArray = ['parId', 'itemNo', 'tsiAmt', 'lineCd', 'recFlag',
		           		   'premRt', 'premAmt', 'annTsiAmt', 'annPremAmt', 'perilName'];
		for (var i = 0; i < objGipiwGroupedBenPerils.length; i++){
			if (objGipiwGroupedBenPerils[i].itemNo == itemNo &&
				objGipiwGroupedBenPerils[i].beneficiaryNo == bpObj.beneficiaryNo &&
				objGipiwGroupedBenPerils[i].groupedItemNo == bpObj.groupedItemNo &&
				objGipiwGroupedBenPerils[i].perilCd == bpObj.perilCd){
				var perilObj = objGipiwGroupedBenPerils[i];
				for (var x = 0; x < entityArray.length; x++){
					var entity = entityArray[x];
					perilObj[entity] = bpObj[entity];
				}
				index = i;
			}
		}
		var updatedItem = objGipiwGroupedBenPerils[index];

		return updatedItem;
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

	$("btnDeleteBeneficiaryPerils").observe("click", function (){
		$$("div[name='benPeril']").each(function (bp){
			if (bp.hasClassName("selectedRow")){
				Effect.Fade(bp, {
					duration : .5,
					afterFinish : function (){
						bp.remove();
						addDeletedJSONObject(objGipiwGroupedBenPerils, prepareDeletedBenPeril(bp.id, parseInt(bp.getAttribute("groupeditemno")), bp.getAttribute("beneficiaryno")));
						clearBeneficiaryPerilsForm();
					}
				});
			}
		});
		$("tempSave").value = "Y";
	});

	function prepareDeletedBenPeril(bpId, groupedItemNo, benNo){
		var deleteBenPerilObj = new Object();
		
		for (var i = 0; i < objGipiwGroupedBenPerils.length; i++){	
			if (objGipiwGroupedBenPerils[i].beneficiaryNo == benNo && objGipiwGroupedBenPerils[i].groupedItemNo == groupedItemNo && objGipiwGroupedBenPerils[i].itemNo == itemNo && objGipiwGroupedBenPerils[i].perilCd == bpId){
				deleteBenPerilObj = objGipiwGroupedBenPerils[i];
			}
		}

		return deleteBenPerilObj;
	}

	/***************************************************************/
	
	function prepareTables(){
		var tblNameArray 		= ['coverageTable', 'bBenefeciaryTable', 'benPerilTable'];
		var tblrowNameArray 	= ['cov', 'benefit', 'benPeril'];
		var tblrowlistNameArray = ['coverageListing', 'bBeneficiaryListing', 'benPerilListing'];
		
		for (var i = 0; i < tblNameArray.length; i++){
			checkTableIfEmpty2(tblrowNameArray[i], tblNameArray[i]);
			checkIfToResizeTable2(tblrowlistNameArray[i], tblrowNameArray[i]);	
		}
	}

	/***************************************************************/
	
	function initializeAllGroupedItems(){
		fillGroupedItemsList();
		fillCoverageItems();
		fillGroupedBenItems();

		clearCoverage();
		clearBeneficiaryItems();
		clearBeneficiaryPerils();

		disableButtons();

		prepareTables();

		/*
		if($F("accidentPackBenCd") != ""){
			enableButton("btnPopulateBenefits"); 
		} else{
			disableButton("btnPopulateBenefits"); 
		}*/	
	}	

	/***************************************************************/
	/*				FOR RETRIEVE GROUPED ITEMS					   */
	/***************************************************************/
	
	$("btnOkPopRetGrpItems").observe("click", function () {
		var count = 0;
		$$("div[name='popRetGrpItems']").each(function (row){
			if ($("popRetCheck").checked == true){
				count++;
			}
		});

		if (count == 0){
			showMessageBox("Please select a grouped item.");
		} else { 
			insertRetrievedGroupedItems();
			$("popGrpItems").hide();
		}
		groupedItemNo = "";
	});

	function insertRetrievedGroupedItems(){
		$$("div[name='popRetGrpItems']").each(function (row){
			if ($("popRetCheck").checked == true){
				filterRetGroupedItems(row.id);
				row.remove();
			} else {
				removeFromGrpItemsParams(row.id);
			}
		});	
	}

	function removeFromGrpItemsParams(grpItem){
		for (var i = 0; i < objRetGroupedItemsParams.length; i++){
			if (objRetGroupedItemsParams[i].groupedItemNo == grpItem &&
				objRetGroupedItemsParams[i].itemNo == itemNo){
				objRetGroupedItemsParams.splice(i, 1);
			}
		}
	}

	function filterRetGroupedItems(groupedItemNo){
		for (var i = 0; i < objRetGipiwGroupedItems.length; i++){
			if (objRetGipiwGroupedItems[i].groupedItemNo == groupedItemNo &&
				objRetGipiwGroupedItems[i].itemNo == itemNo){
				objRetGipiwGroupedItems[i].inserted = "Y";
				objGipiwGroupedItemsList.push(objRetGipiwGroupedItems[i]);
				updateGroupedItemsTable(objRetGipiwGroupedItems[i], "");
			}
		}

		for (var j = 0; j < objRetGipiwCoverageItems.length; j++){
			if (objRetGipiwCoverageItems[j] != null){
				if (objRetGipiwCoverageItems[j].groupedItemNo == groupedItemNo &&
					objRetGipiwCoverageItems[j].itemNo == itemNo){
					objGipiwCoverageItems.push(objRetGipiwCoverageItems[j]);
					updateCoverageItemsTable(objRetGipiwCoverageItems[j], "");
				}
			}
		}

		for (var k = 0; k < objRetGipiwGroupedBenItems.length; k++){
			if (objRetGipiwGroupedBenItems[k] != null){
				if (objRetGipiwGroupedBenItems[k].groupedItemNo == groupedItemNo &&
					objRetGipiwGroupedBenItems[k].itemNo == itemNo){
					objGipiwGroupedBenItems.push(objGipiwGroupedBenItems[k]);
					addBeneficiaryInTable(objGipiwGroupedBenItems[k]);
				}
			}
		}

		showMessageBox('Grouped Items Retrieval Finished Successfully');

	}

	$("btnCancelPopRetGrpItems").observe("click", function () {
		$("popGrpItems").hide();
	});
	
	/***************************************************************/
	
	checkTableItemInfoAdditionalModal("accidentPopBenTable","accidentPopBenListing","popBens","item",$F("itemNo"));
	checkIfToResizeTable2("accidentGroupedItemsListing", "grpItem");
	checkTableIfEmpty2("grpItem", "accidentGroupedItemsTable");
</script>