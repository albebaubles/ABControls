# ABControls
The ABControls project's purpose is to provide various iOS controls within a reusable framework.

In the decade I've been writing iOS apps for clients I've written dozens of custom UI elements - from special labels to
barcode readers, to signature capture elements.  I thought, why not take some of the things I've learned in this 
time and put together some UI controls that would both speed my development and more importantly hopefully help others 
to learn how to create their own controls.

----------
All of the controls support @IBDesignable and @IBInspectable - so they will render within InterfaceBuilder.  All objects inherit from UIView.    To use, simply draw a UIView to your viewcontroll and change the  owner to ABControls and the class to the type of ABcontrol you'd like to use



Current List of Implemented Controls:

• ABBarcodeScanner - Allows for scanning barcodes of various types.  Inner class ABBarCode allows for creating a barcode image

• ABCheckBox - A simple checkbox control

• ABDropDown - A dropdown control.  

• ABImageViewer - Allows for specifying an array of UIImage objects, displays them in a scrollable image list and allows for selecting on to Be diaplayed/selected

• ABListBox -- exactly what you expect it to be

• ABSignatureCapture - Allows for capture a touch drawn signature - returns as data, an image or a bezierpath

• ABTouchDraw -- Similar to ABSignatureCapture -- allows for simple drawing with return data as an image.  Very nasic, plenty of room for enhancement

Additionally, I have created some placeholder classes for controls I plan to implement in the near future.

Thank you!  All feedback welcome.
