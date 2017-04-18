<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="policyDiscountSurchargeSectionDiv" class="sectionDiv" style="border: none;">
	 <div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label>Discount/Surcharge</label>
				<span class="refreshers" style="margin-top: 0;">
					<label id="showBillTax" name="gro" style="margin-left: 5px">Hide</label>
				</span>
				<input type="hidden" id="policyId" name="policyId"/> 
			</div>
	</div> 
	<div id="policyBillDiscountSurcharge"  class="sectionDiv" style="border: none;">
		<div id="policyDiscountSurchargeDiv" class="sectionDiv" style="border: none;">
		 	
	 		<div id="policyBillDiscountDetails" name="policyBillDiscountDetails" class="sectionDiv" style="border: none;">	 
					<div id="tabComponentsDiscountDiv" class="tabComponents2" style="border: none; align:center; width:100%">
						<ul>
							<li class="tab2 selectedTab2" style="width:20%" id="polDis" name="polDis"><a id="polDiscountSurcharge">Policy Discount/Surcharge</a></li>
							<li class="tab2" style="width:20%" id="itemDis" name="itemDis"><a id="itemDiscountSurcharge">Item Discount/Surcharge</a></li>
							<li class="tab2" style="width:20%" id="perilDis" name="perilDis"><a id="perilDiscountSurcharge">Peril Discount/Surcharge</a></li>			
						</ul>			
					</div> 
					<div class="tabBorderBottom2"></div>
						<div id="polDiscountDiv" name="polDiscountDiv" style="border: none; width: 100%; float: left;"></div>
						<div id="itemDiscountDiv" name="itemDiscountDiv" style="border: none; width: 100%; float: left;"></div>
						<div id="perilDiscountDiv" name="perilDiscountDiv" style="border: none; width: 100%; float: left;"></div>
					</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript"> 
    initializeAccordion();
    initializeTabs();
	
	 new Ajax.Updater("polDiscountDiv","GIPIPolbasicController?action=showPolicyDiscountTab",{
		method:"get",
		evalScripts: true,
		parameters:{
			policyId : $F("hidPolicyId")
		}
	});
		
	$("itemDiscountSurcharge").observe("click", function () {
		if($("itemDiscountSurchargeTabDiv") == null){
		new Ajax.Updater("itemDiscountDiv","GIPIPolbasicController?action=showItemDiscountTab",{
			method:"get",
			evalScripts: true,
			parameters:{
				policyId : $F("hidPolicyId")
			}
		});
		}
		$("polDiscountDiv").hide();
		$("itemDiscountDiv").show();
		$("perilDiscountDiv").hide();
		});
	
	$("perilDiscountSurcharge").observe("click", function () {
		if($("perilDiscountSurchargeTabDiv") == null){
			new Ajax.Updater("perilDiscountDiv","GIPIPolbasicController?action=showPerilDiscountTab",{
				method:"get",
				evalScripts: true,
				asynchronous: false,
				parameters:{
					policyId : $F("hidPolicyId")
				}
			});
		}
			$("polDiscountDiv").hide();
			$("itemDiscountDiv").hide();
			$("perilDiscountDiv").show();
			
		});
	
	$("polDiscountSurcharge").observe("click", function () {
		if($("policyDiscountSurchargeTabDiv") == null){
			new Ajax.Updater("polDiscountDiv","GIPIPolbasicController?action=showPolicyDiscountTab",{
				method:"get",
				evalScripts: true,
				parameters:{
					policyId : $F("hidPolicyId")
				}
			});
		}
			$("polDiscountDiv").show();
			$("itemDiscountDiv").hide();
			$("perilDiscountDiv").hide();
			
		});
	
</script>