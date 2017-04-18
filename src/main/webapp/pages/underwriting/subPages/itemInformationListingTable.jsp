<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="outerDiv">
		<label id="">Item Information</label> 
		<span class="refreshers" style="margin-top: 0;">
			<label name="gro" style="margin-left: 5px;">Hide</label>
		</span>
	</div>
</div>
<div class="sectionDiv" id="itemInfoDiv">
	<div id="itemInformationDiv" style="width: 100%;">
		<div id="searchResultParItem" align="center" style="margin: 10px;">
			<div style="width: 100%;" id="itemTable" name="itemTable">
				<div class="tableHeader">
					<label style="width: 5%; text-align: right; margin-right: 10px;">No.</label>
					<label style="width: 15%; text-align: left;">Item Title</label>
					<label style="width: 15%; text-align: left;">Description 1</label>
					<label style="width: 15%; text-align: left;">Description 2</label>
					<label style="width: 15%; text-align: left;">Currency</label>
					<label style="width: 15%; text-align: right; margin-right: 10px;">Rate</label>
					<label style="text-align: left;">Coverage</label>
				</div>
				<div>
					<input type="hidden" id="parSublineCd" name="parSublineCd" value="${wPolBasic.sublineCd}"/>
					<input type="hidden" id="parLineCd" name="parLineCd" value="${wPolBasic.lineCd}"/>
					<input type="hidden" id="parId" name="parId" value="${parId}"/>
					<input type="hidden" id="wItemParCount" name="wItemParCount" value="${wItemParCount}" />
				</div>
				<div id="itemMainDiv" class="tableContainer">
					<c:forEach var="item" items="${parItemInfo}" varStatus="ctr">
						<div id="row${item.itemNo}" name="row" class="tableRow" style="height: 20px; border-bottom: 1px solid #E0E0E0; padding-top: 10px;">
							<label name="text" style="width: 5%; text-align: right; margin-right: 10px;">${item.itemNo}<c:if test="${empty item.itemNo}">---</c:if></label>
							<label name="text" style="width: 15%; text-align: left;">${item.itemTitle}<c:if test="${empty item.itemTitle}">---</c:if></label>
			   				<label name="text" style="width: 15%; text-align: left;">${item.itemDesc}<c:if test="${empty item.itemDesc}">---</c:if></label>
							<label name="text" style="width: 15%; text-align: left;">${item.itemDesc2}<c:if test="${empty item.itemDesc2}">---</c:if></label>
							<label name="text" style="width: 15%; text-align: left;">${item.currencyDesc}<c:if test="${empty item.currencyDesc}">---</c:if></label>
							<label name="text" style="width: 15%; text-align: right; margin-right: 10px;" class="moneyRate">${item.currencyRate}<c:if test="${empty item.currencyRate}">---</c:if></label>
							<label name="text" style="text-align: left;">${item.coverageDesc}<c:if test="${empty item.coverageDesc}">---</c:if></label>
							<input type="hidden" id="masterItemNo${item.itemNo}" 		name="masterItemNo${item.itemNo}" 		value="${item.itemNo}"/>
							<input type="hidden" id="masterPackLineCd${item.itemNo}" 	name="masterPackLineCd${item.itemNo}" 	value="${item.packLineCd}"/>
							<input type="hidden" id="masterPackSublineCd${item.itemNo}" name="masterPackSublineCd${item.itemNo}" value="${item.packSublineCd}"/>
							<input type="hidden" id="masterTsiAmt${item.itemNo}" 		name="masterTsiAmt${item.itemNo}" 		value="${item.tsiAmt}"/>
							<input type="hidden" id="masterPremAmt${item.itemNo}" 		name="masterPremAmt${item.itemNo}" 		value="${item.premAmt}"/>
							<input type="hidden" id="masterAnnPremAmt${item.itemNo}" 	name="masterAnnPremAmt${item.itemNo}" 	value="${item.annPremAmt}"/>
							<input type="hidden" id="masterAnnTsiAmt${item.itemNo}" 	name="masterAnnTsiAmt${item.itemNo}" 	value="${item.annTsiAmt}"/>
							<input type="hidden" id="masterFromDate${item.itemNo}" 		name="masterFromDate${item.itemNo}" 	value="${item.fromDate}"/>
							<input type="hidden" id="masterToDate${item.itemNo}" 		name="masterToDate${item.itemNo}" 		value="${item.toDate}"/>
							<input type="hidden" id="masterChangedTag${item.itemNo}" 	name="masterChangedTag${item.itemNo}" 	value="${item.changedTag}"/>
							<input type="hidden" id="masterProrateFlag${item.itemNo}" 	name="masterProrateFlag${item.itemNo}" 	value="${item.prorateFlag}"/>
							<input type="hidden" id="masterCompSw${item.itemNo}" 		name="masterCompSw${item.itemNo}" 		value="${item.compSw}"/>
							<input type="hidden" id="masterShortRtPercent${item.itemNo}" name="masterShortRtPercent${item.itemNo}" value="${item.shortRtPercent}"/>
							<input type="hidden" id="masterPackBenCd${item.itemNo}" 	name="masterPackBenCd${item.itemNo}" 	value="${item.packBenCd}"/>
							<input type="hidden" id="masterCurrencyDesc${item.itemNo}"  name="masterCurrencyDesc${item.itemNo}" value="${item.currencyDesc}"/>
							<input type="hidden" id="masterCoverageDesc${item.itemNo}"  name="masterCoverageDesc${item.itemNo}" value="${item.coverageDesc}"/>
							<input type="hidden" id="masterPackageCd${item.itemNo}"		name="masterPackageCd${item.itemNo}"	value="${item.packageCd}"/>
							<input type="hidden" id="discDeleted${item.itemNo}"			name="discDeleted"						value="N"/>
						    <input type="hidden" id="itemNumber" 						name="itemNumber" 						value="${item.itemNo}" />
						</div>
					</c:forEach>
				</div>
			</div>
		</div>
		<div id="selectedItemDiv" name="selectedItemDiv">
			<input type="hidden" name="itemNo" id="itemNo" value="${itemNo}">
			<input type="hidden" name="wItemPeril" id="wItemPeril" value="${wItemPeril}"/> 
			<input type="hidden" name="itemPackLineCd" id="itemPackLineCd"/>
			<input type="hidden" name="itemPackSublineCd" id="itemPackSublineCd"/>
			<input type="hidden" name="prorateFlag" id="prorateFlag"/>
			<input type="hidden" name="shortRtPercent" id="shortRtPercent"/>
		</div>
		
		<div style="padding: 5px;">
			<input type="button" id="btnShowPerils" name="btnShowPerils" value="Show Perils" class="disabledButton"/>
		</div>
	</div>
</div>
	
<script type="text/javaScript">

initializeAccordion();
addStyleToInputs();
initializeAll();
initializeAllMoneyFields();

$$("label[name='text']").each(function (label)	{
	if ((label.innerHTML).length > 15)	{
		label.update((label.innerHTML).truncate(15, "..."));
	}
});

$$("div[name='row']").each(function (div)	{
	if ((div.down("label", 1).innerHTML).length > 30)	{
		div.down("label", 1).update((div.down("label", 1).innerHTML).truncate(30, "..."));
	}
});

//initializeTable("tableContainer", "row", "", "");

$$("div[name='row']").each(
		function (row)	{
			row.observe("mouseover", function ()	{
				row.addClassName("lightblue");
			});
			
			row.observe("mouseout", function ()	{
				row.removeClassName("lightblue");
			});

			row.observe("click", function ()	{
				row.toggleClassName("selectedRow");
				if (row.hasClassName("selectedRow"))	{
					try {
						$$("div[name='row']").each(function (r)	{
							if (row.getAttribute("id") != r.getAttribute("id"))	{
								r.removeClassName("selectedRow");
							}
						});

						
						var itemNo			= row.down("input", 0).value;
						var packLineCd		= row.down("input", 1).value;
						var	packSublineCd 	= row.down("input", 2).value;
						var parId			= $("parId").value;
						var sublineCd		= $("parSublineCd").value;
						var prorateFlag		= row.down("input", 10).value;
						var shortRtPercent	= row.down("input", 12).value;
						
						$("itemNo").value 				= itemNo;
						$("itemPackLineCd").value 		= packLineCd;
						$("itemPackSublineCd").value 	= packSublineCd;
						$("prorateFlag").value 			= prorateFlag;
						$("shortRtPercent").value		= shortRtPercent;

						hideAllPerilDivs();
						clearItemPerilFields();

						if ($("itemPerilMotherDiv"+itemNo) != null) {
							$("itemPerilMotherDiv"+itemNo).show();
						}
						
						//$("ctv").checked			= row.down("input", 32).value == 'Y' ? true : false;

						$("btnShowPerils").value = "Show Perils";
						
						/*$("btnShowPerils").removeClassName("disabledButton");
						$("btnShowPerils").addClassName("button");
						$("btnShowPerils").enable();

						$("btnAddItemPeril").removeClassName("disabledButton");
						$("btnAddItemPeril").addClassName("button");
						$("btnAddItemPeril").enable();*/
						enableButton("btnShowPerils");
						enableButton("btnAddItemPeril");
						
					} catch (e){
						showErrorMessage("itemInformationListingTable.jsp - click", e);
					}
				}
				else {
					hideAllPerilDivs();
					clearItemPerilFields();
					clearItemFields();
					/*$$("div[name='perilInformationDiv']").each(function (perilDiv)	{
						perilDiv.hide();
					});*/

					new Effect.toggle("perilInformationDiv", "blind", {duration: .2});
					/*if ($("btnShowPerils").value == "Hide Perils"){
						$("btnShowPerils").value == "Show Perils";
					};*/

					//$("btnShowPerils").value == "Show Perils";
					/*$("btnShowPerils").removeClassName("button");
					$("btnShowPerils").addClassName("disabledButton");
					$("btnShowPerils").disable();*/
					disableButton("btnShowPerils");

					$("btnAddItemPeril").value = "Add";

					disableButton("btnAddItemPeril");
					
					/*$("btnAddItemPeril").removeClassName("button");
					$("btnAddItemPeril").addClassName("disabledButton");
					$("btnAddItemPeril").disable();*/

			}});
		}
	);

function hideAllPerilDivs()	{
	$$("div[name='itemPerilMotherDiv']").each(function (perilDiv)	{
		perilDiv.hide();
	}); 
}

function clearItemFields(){
	$("itemNo").value 				= "";
	$("itemPackLineCd").value 		= "";
	$("itemPackSublineCd").value 	= "";
	$("prorateFlag").value 			= "";
	$("shortRtPercent").value		= "";
}

function clearItemPerilFields(){
	$("perilCd").value 				= "";
	$("perilRate").value 		    = 0;
	$("tsiAmt").value				= 0;
	$("premiumAmt").value			= 0;
	$("compRem").value				= "";

	$("btnAddItemPeril").value = "Add";
	/*$("btnDeletePeril").removeClassName("button");
	$("btnDeletePeril").addClassName("disabledButton");
	$("btnDeletePeril").disable();*/
	disableButton("btnDeletePeril");
}

$("btnShowPerils").observe("click", function (){
	new Effect.toggle("perilInformationDiv", "blind", {duration: .2});
	$("btnShowPerils").value = $("btnShowPerils").value == "Hide Perils" ? "Show Perils" : "Hide Perils";
	/*if ($("btnShowPerils").value == "Show Perils"){
		$$("div[name='perilInformationDiv']").each(function (perilDiv)	{
			perilDiv.show();
		});
		$("btnShowPerils").value = "Hide Perils";
	}
	else if ($("btnShowPerils").value == "Hide Perils"){
		$$("div[name='perilInformationDiv']").each(function (perilDiv)	{
			perilDiv.hide();
		});
		//$("btnShowPerils").value = "Show Perils";
	}*/
});

function showPerilDiv(){
	new Effect.toggle("perilInformationDiv", "blind", {duration: .2});
}

</script>