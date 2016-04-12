# ScrollViewOnKeyboardShow

Demonstrates how you can use an UIScrollView to move content out of the way of the keyboard, using the UIScrollView with Auto Layout and modifying `UIScrollView.contentSize`.

[Apple recommends](https://developer.apple.com/library/ios/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html) modifying `UIScrollView.contentInset` - Swift version on GitHub: [UIScrollViewWithAutoLayout](https://github.com/woelmer/UIScrollViewWithAutoLayout). However it leaves no space between the keyboard and the text field (see the pic below). 

![screenshot](http://i.stack.imgur.com/vovnl.png)

This case is described on Stack Overflow: [Move a view up when the keyboard covers an input field but with leaving some space between them](http://stackoverflow.com/questions/36236352/move-a-view-up-when-the-keyboard-covers-an-input-field-but-with-leaving-some-spa).

So this version modifies `UIScrollView.contentSize` instead of `UIScrollView.contentInset` to workaround it and have some additional space between those elements.
