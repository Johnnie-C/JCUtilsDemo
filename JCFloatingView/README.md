# JCFloatingView
iOS floating view in App level.
<br>A simple iOS implementation of [SimpleFloating](https://github.com/recruit-lifestyle/FloatingView).
<br><br>Demo can be found in [JCUtilsDemo](https://github.com/EzlyJohnnie/JCUtilsDemo) 
<br>(See [JCHomeViewController#tableView:didSelectRowAtIndexPath:](https://github.com/EzlyJohnnie/JCUtilsDemo/blob/master/JCFrameworkDemo/JCFrameworkDemo/UI/HomeViewController/JCHomeViewController.m#L156))

## Screenshots
- default floating view

<img src="https://github.com/EzlyJohnnie/JCUtilsDemo/raw/feature/restructure/WikiResources/floating_view_1.gif" width="200">

<br>
- customize floating view

<img src="https://github.com/EzlyJohnnie/JCUtilsDemo/raw/feature/restructure/WikiResources/floating_view_2.png" width="200">

## Requirements
iOS 9+  

## How to use
#### Install
1. Follow the instruction for installing [Cocoapod](https://guides.cocoapods.org/using/using-cocoapods)
2. Add following code to podfile
```ruby
pod 'JCUtils/JCFloatingView', :git => 'https://github.com/EzlyJohnnie/JCUtilsDemo'
```

#### Usage 
```objective-c
- (void)showFloatingView{
  JCFloatingViewConfig *config = [JCFloatingViewConfig new];
  JCFloatingViewController *floatingView = [JCFloatingViewController FloatingViewWithConfig:config];
  floatingView.delegate = self;
  [floatingView showFloatingView];
}

#pragma mark - JCFloatingViewControllerDelegate
- (void)didClickedFloatingView:(JCFloatingViewController *)floatingView{
  //did click on floating view 
}

- (void)didDismissFloatingView:(JCFloatingViewController *)floatingView{
  //floating view dismissed by drag to close
}
```

## Configuration
Floating view can be configured through `JCFloatingViewConfig`
<br>
For example
```objective-c
JCFloatingViewConfig *config = [JCFloatingViewConfig new];
config.overMargin = 5;
config.stickyToEdge = YES;
config.floatingViewBorderColor = [UIColor orangeColor];
config.floatingViewWidth = 80;
config.floatingViewHeight = 110;
config.floatingViewCornerRadius = 10;
```

|Option|Description|  
|:-:|---|  
|preferredStatusBarStyle|Style of `UIStatusBarStyle`|  
|stickyToEdge|If sticky to the edge of the screen.<br>If yes, floating view will move to the closest edge after dragging|
|overMargin| Margin over the edge of the screen |  
|<br><br>|  
|floatingView| Set the UIView if you want use your customized floating view<br>**Note**: If `floatingView` is set, the reset options in this section will be ignored. Your floatingView's frame will be used for initial position and size|  
|floatingViewInitPositionX|x in screen for initial position|  
|floatingViewInitPositionY|y in screen for initial position|
|floatingViewWidth|width for floating view|
|floatingViewHeight|height for floating view|  
|floatingViewImage|image to display for floating view|  
|floatingViewBorderColor|border color for floating view|  
|floatingViewBorderWidth|border width for floating view|  
|floatingViewCornerRadius|corner radius for floating view|  
|<br><br>|  
|closeViewGradientColors|bottom close view background gradient colors (from top to bottom)<br>See `CAGradientLayer#colors` for more details|  
|closeViewGradientColorsLocations|bottom close view background gradient colors locations (from top to bottom)<br>See `CAGradientLayer#locations` for more details|  
|<br><br>||  
|closeImage|bottom close button foreground image<br>(white "x" displayed in screenshot)|  
|closeImageWidth|width for bottom close button foreground image|  
|closeImageHeight|height for bottom close button foreground image|  
|closeImageCornerRadius|corner radius for bottom close button foreground image|  
|<br><br>||  
|closeBGImage|bottom close button background image|
|closeBGColor|bottom close button background UIImageView color<br>(red circle displayed in screenshot)|  
|closeBGImageWidth|width for bottom close button background image|  
|closeBGImageHeight|height for bottom close button background image|  
|closeBGImageCornerRadius|corner radius for bottom close button background image|  

# License
Copyright 2018 Johnnie Cheng

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
