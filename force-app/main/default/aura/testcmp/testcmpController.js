// MyAngularContainerController.js
({
    doInit: function(component, event, helper) {
        var appDiv = document.getElementById("angularApp");
        appDiv.innerHTML = "<app-root></app-root>"; // Replace 'app-root' with your Angular app's root component selector
    }
})
