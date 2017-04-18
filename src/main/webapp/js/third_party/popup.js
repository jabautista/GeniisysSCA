if(!window.Overlay)
	var Popup = new Object();

Popup.Methods = {
	initialized: false,
	options: {
		title: "ModalBox Window", // Title of the ModalBox window
		overlayClose: true, // Close modal box by clicking on overlay
		width: 500, // Default width in px
		height: 90, // Default height in px
		overlayOpacity: .65, // Default overlay opacity
		overlayDuration: .25, // Default overlay fade in/out duration in seconds
		slideDownDuration: .5, // Default Modalbox appear slide down effect in seconds
		slideUpDuration: .5, // Default Modalbox hiding slide up effect in seconds
		resizeDuration: .25, // Default resize duration seconds
		inactiveFade: true, // Fades MB window on inactive state
		transitions: true, // Toggles transition effects. Transitions are enabled by default
		loadingString: "Please wait. Loading...", // Default loading string message
		closeString: "Close window", // Default title attribute for close window link
		closeValue: "&times;", // Default string for close link in the header
		params: {},
		method: 'get', // Default Ajax request method
		autoFocusing: true, // Toggles auto-focusing for form elements. Disable for long text pages.
		aspnet: false, // Should be use then using with ASP.NET costrols. Then true Modalbox window will be injected into the first form element.
		asynchronous : true
	},
	
	show: function(content, options) {
		if(!this.initialized) this._init(options); // Check for is already initialized
		
		this.content = content;
		this.setOptions(options);
		
		if(this.options.title) // Updating title of the MB
			$(this.MBcaption).update(this.options.title);
		else { // If title isn't given, the header will not displayed
			$(this.MBheader).hide();
			$(this.MBcaption).hide();
		}
		
		if(this.MBwindow.style.display == "none") { // First modal box appearing
			this._appear();
			this.event("onShow"); // Passing onShow callback
		}
		else { // If MB already on the screen, update it
			this._update();
			this.event("onUpdate"); // Passing onUpdate callback
		} 
	}
};