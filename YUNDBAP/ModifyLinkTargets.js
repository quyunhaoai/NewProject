function MyIPhoneApp_ModifyLinkTargets() {
    var allLinks = document.getElementsByTagName('a');
    if (allLinks) {
        var i;
        for (i=0; i<allLinks.length; i++) {
            var link = allLinks[i];
            var target = link.getAttribute('target');
            if (target && target == '_blank') {
                link.setAttribute('target','_self');
                link.href = 'newtab:'+escape(link.href);
            }
        }
    }
}

function MyIPhoneApp_ModifyWindowOpen() {
    window.open =
    function(url,target,param) {
        if (url && url.length > 0) {
            if (!target) target = "_blank";
            if (target == '_blank') {
                location.href = 'newtab:'+escape(url);
            } else {
                location.href = url;
            }
        }
    }
}