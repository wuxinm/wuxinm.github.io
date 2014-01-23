var i = true;
var open = false;
$(document).ready(function(){
    $("#navButton").click(function(){
    	if (i) {
    		$(".nav-menu-trigger").addClass("nav-menu-open-trigger");	
    		$(".nav-menu").addClass("nav-menu-open");
    	}
    	else {
    		$(".nav-menu-trigger").removeClass("nav-menu-open-trigger");
    		$(".nav-menu").removeClass("nav-menu-open");
    	};
    	i = !i;
    });

    $("#sns-button").click(function(){
    	if(!open){
    		this.innerHTML = "CLOSE";
    		$(".sns-wrapper").addClass("opened-nav");
    	}
    	else{
    		this.innerHTML = "SNS";
    		$(".sns-wrapper").removeClass("opened-nav");
    	}
    	open = !open;
    });
});