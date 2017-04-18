/*
 * Created by	: Andrew
 * Date			: 10.12.2010
 * Description	: Initializes the behavior of tab components
 */
function initializeTabs() {	
	$$("div.tabComponents1 a").each(function(a){
		a.observe("mouseover", function(){
			a.up("li").addClassName("tabHover1");
		});
		
		a.observe("mouseout", function(){
			a.up("li").removeClassName("tabHover1");
		});
		
		a.observe("click", function() {
			if (changeTag == 1) return; //added by Nok 02.24.2011
			a.up("li").addClassName("selectedTab1");
			if (a.up("li").hasClassName("selectedTab1")){
				$$("div.tabComponents1 a").each(function(b){
					if(a.id != b.id) {
						b.up("li").removeClassName("selectedTab1");						
					}
				});
			} 
		});		
	 });
		
	$$("div.tabComponents2 a").each(function(a){
		a.observe("mouseover", function(){
			a.up("li").addClassName("tabHover2");
		});
		
		a.observe("mouseout", function(){
			a.up("li").removeClassName("tabHover2");
		});
		
		a.observe("click", function(){
			if (changeTag == 1) return; //added by Nok 02.24.2011
			a.up("li").addClassName("selectedTab2");
			if (a.up("li").hasClassName("selectedTab2")){
				$$("div.tabComponents2 a").each(function(b){
					if(a.id != b.id) {
						b.up("li").removeClassName("selectedTab2");						
					}
				});
			}
		}); 
	 }); 
}