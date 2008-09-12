sfHover = function() {
  var sfEls = $("nav").getElementsByTagName("LI");
  for (var i=0; i<sfEls.length; i++) {
    sfEls[i].onmouseover=function() {
      Element.addClassName(this,"sfhover");
    }
    sfEls[i].onmouseout=function() {
      Element.removeClassName(this,"sfhover");
    }
  }
}
if (window.attachEvent) window.attachEvent("onload", sfHover);

// a sort-of cross browser script to save a bookmark
addBookmark = function(anchor) {
  // user agent sniffing is bad in general, but this is one of the times 
  // when it's really necessary
  var ua=navigator.userAgent.toLowerCase();
  var isKonq=(ua.indexOf('konqueror')!=-1);
  var isSafari=(ua.indexOf('webkit')!=-1);
  var isMac=(ua.indexOf('mac')!=-1);
  var buttonStr=isMac?'Command/Cmd':'CTRL';

  if(window.external && (!document.createTextNode || (typeof(window.external.AddFavorite)=='unknown'))) {
    // IE4/Win generates an error when you
    // execute "typeof(window.external.AddFavorite)"
    // In IE7 the page must be from a web server, not directly from a local 
    // file system, otherwise, you will get a permission denied error.
    window.external.AddFavorite(anchor.href, anchor.title); // IE/Win
  } 
  else if(isKonq) {
    alert('You need to press CTRL + B to bookmark our site.');
  } 
  else if(window.opera) {
    anchor.rel='sidebar'; // this makes it work in Opera 7+
    void(0); // do nothing here (Opera 7+)
  } 
  else if(window.home && !isSafari) { // Firefox, Netscape
    window.sidebar.addPanel(anchor.title, anchor.href,anchor.title); 
  } 
  else if(window.home || isSafari) { // Firefox, Netscape, Safari, iCab
    alert('You need to press '+buttonStr+' + D to bookmark our site.');
  } 
  else if(!window.print || isMac) { // IE5/Mac and Safari 1.0
    alert('You need to press Command/Cmd + D to bookmark our site.');    
  } 
  else {
    alert('In order to bookmark this site you need to do so manually through your browser.');
  }
}
